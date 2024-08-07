Class {
	#name : 'WDELevelEditorViewEditionMode',
	#superclass : 'WDELevelEditorViewMode',
	#instVars : [
		'clickSelectionWheel'
	],
	#category : 'WodenEditor-UI-ViewMode',
	#package : 'WodenEditor-UI',
	#tag : 'ViewMode'
}

{ #category : 'actions' }
WDELevelEditorViewEditionMode >> activateAction [
	view activeToolManipulator ifNotNil: [ :manip |
		manip activateAction
	]
]

{ #category : 'actions' }
WDELevelEditorViewEditionMode >> cancelAction [
]

{ #category : 'as yet unclassified' }
WDELevelEditorViewEditionMode >> currentModelingEditionMode [
	^ WDObjectEditionMode
]

{ #category : 'as yet unclassified' }
WDELevelEditorViewEditionMode >> elementInPositionWithRayPicking: position mode: modelingEditionMode [
	^ view elementInPositionWithRayPicking: position mode: modelingEditionMode
]

{ #category : 'as yet unclassified' }
WDELevelEditorViewEditionMode >> manipulatorForSelection: selection [
	(self supportsElementSelection and: [ self supportsManipulators ]) ifTrue: [ 
		| selectedElements |
		selectedElements := selection selectedItems select: [:item | item isSceneSelectableObject ].
		selectedElements ifNotEmpty: [
			^ (WDELevelEditor3DSelectionManipulator for: view)
				selectedElements: selectedElements;
				yourself
		].
	].

	^ nil
]

{ #category : 'as yet unclassified' }
WDELevelEditorViewEditionMode >> nextValidClickSelectionWheelFor: clickPosition [
	(clickSelectionWheel notNil and: [ clickSelectionWheel isValidForPosition: clickPosition ]) ifFalse: [
		^ clickSelectionWheel := WDELevelEditorSelectionClickWheel new
			clickPosition: clickPosition;
			elements: (view elementsInPositionWithRayPicking: clickPosition mode: self currentModelingEditionMode);
			yourself.
	].

	^ clickSelectionWheel advance
]

{ #category : 'event' }
WDELevelEditorViewEditionMode >> onLeftClick: event [
	| elements |
	self supportsElementSelection ifFalse: [ ^ self ].
	elements := (self nextValidClickSelectionWheelFor: event position) currentElement ifNil: [ #() ] ifNotNil: [ :e | { e } ].
	
	event shiftPressed ifTrue: [
		^ self levelEditorSession addElementsToSelection: elements
	].
	event controlKeyPressed ifTrue: [ 
		^ self levelEditorSession toggleElementsFromSelection: elements
	].

	^ self levelEditorSession setSelectedElements: elements
]

{ #category : 'as yet unclassified' }
WDELevelEditorViewEditionMode >> onMouseDragStart: event [
	event isPrimaryButton ifTrue: [ ^ self startManipulatorOrActionDraggingWith: event ].
	event isMiddleButton ifTrue: [ ^ self startCameraRotateDraggingWith: event ].
	event isSecondaryButton ifTrue: [ ^ self startCameraDraggingWith: event ].
]

{ #category : 'event' }
WDELevelEditorViewEditionMode >> onMouseMove: event [
	| elementBeingPointed manipulatorBeingPointed |
	manipulatorBeingPointed := self supportsManipulators
		ifTrue: [view manipulatorInScreenPosition: event position]
		ifFalse: [nil].

	manipulatorBeingPointed ifNotNil: [ 
		view
			highlightManipulator: manipulatorBeingPointed;
			highlightElement: nil
	] ifNil: [
		
		(self supportsElementSelection and: [self levelEditorSession selection selectedItems isEmpty not]) ifTrue: [ 
			elementBeingPointed := self supportsElementSelection
				ifTrue: [self elementInPositionWithRayPicking: event position mode: self currentModelingEditionMode]
				ifFalse: [nil].
			view
				highlightElement: elementBeingPointed;
				highlightManipulator: nil
		] ifFalse: [ 
			view
				highlightElement: nil;
				highlightManipulator: nil
		]
	].

	^ super onMouseMove: event
]

{ #category : 'event' }
WDELevelEditorViewEditionMode >> onMouseWheel: event [
	| delta |
	delta := 0.
	event isUp ifTrue: [ delta := 1 ].
	event isDown ifTrue: [ delta := -1 ].
	delta = 0 ifTrue: [ ^ self ].

	view isPerspective ifTrue: [ 
		view translateCameraBy: (view zDragDirection * delta * 0.5)
	] ifFalse: [
		view viewScale: view viewScale *(1.0 - (delta*0.1) max:0.1)
	].
	view refresh.

]

{ #category : 'event' }
WDELevelEditorViewEditionMode >> onRightClick: event [
	| elements |
	self supportsElementSelection ifFalse: [ ^ self ].
	elements := (self validRightClickSelectionWheelFor: event position) currentElement ifNil: [ #() ] ifNotNil: [ :e | { e } ].
	view setSelectedElements: elements.
	elements ifNotEmpty: [ 
		self levelEditorSession buildSelectionContextMenu openWithSpecAtPointer
	].

]

{ #category : 'as yet unclassified' }
WDELevelEditorViewEditionMode >> shortcuts [
	^ super shortcuts , {
		KeyboardKey escape asKeyCombination . [ self cancelAction ].
		KeyboardKey enter asKeyCombination . [ self activateAction ].

		$s command mac | $s control unix | $s control win . [ view actionSaveFile ].
		$o command mac | $o control unix | $o control win . [ view actionOpenFile ].

		(KeyboardKey named: #KP_ADD) asKeyCombination asKeyCombination . [ self levelEditorSession increaseGridSize ].
		(KeyboardKey named: #KP_SUBTRACT) asKeyCombination asKeyCombination . [ self levelEditorSession decreaseGridSize ].

		$g asKeyCombination . [ view translateSelectedElements ].
		$r asKeyCombination . [ view rotateSelectedElements ].
		$s asKeyCombination . [ view scaleSelectedElements ].

		$z asKeyCombination . [ view openShadingMenu ].
		$z command mac | $z control unix | $z control win . [ self levelEditorSession undo ].
		$z command shift mac | $z control shift unix | $z control shift win . [ self levelEditorSession redo ].

		$d command mac | $d control unix | $d control win . [ self levelEditorSession duplicateSelectedItems  ].
		$p command mac | $p control unix | $p control win . [ self levelEditorSession playLevel ].
		$- command shift mac | $- control shift unix | $- control shift win . [ self levelEditorSession subtractSelectedItems  ].

		KeyboardKey delete asKeyCombination . [ self levelEditorSession deleteSelectedItems  ].

		(KeyboardKey named: #KP_7) asKeyCombination . [ self view topView ].
		(KeyboardKey named: #KP_7) command mac | (KeyboardKey named: #KP_7) control unix | (KeyboardKey named: #KP_7) control win . [ self view bottomView ].

		(KeyboardKey named: #KP_1) asKeyCombination . [ self view frontView ].
		(KeyboardKey named: #KP_1) command mac | (KeyboardKey named: #KP_1) control unix | (KeyboardKey named: #KP_1) control win . [ self view backView ].

		(KeyboardKey named: #KP_3) asKeyCombination . [ self view leftView ].
		(KeyboardKey named: #KP_3) command mac | (KeyboardKey named: #KP_3) control unix | (KeyboardKey named: #KP_3) control win . [ self view rightView ].

		(KeyboardKey named: #KP_5) asKeyCombination . [ self view togglePerspective ].
		KeyboardKey delete asKeyCombination . [ self levelEditorSession deleteSelectedItems ].
	}
]

{ #category : 'as yet unclassified' }
WDELevelEditorViewEditionMode >> startActionDraggingWith: event [
]

{ #category : 'as yet unclassified' }
WDELevelEditorViewEditionMode >> startCameraDraggingWith: event [
	view activeToolMode: ((WDELevelEditorViewCameraDragToolMode for: view)
		dragStartedWith: event;
		yourself)
]

{ #category : 'as yet unclassified' }
WDELevelEditorViewEditionMode >> startCameraRotateDraggingWith: event [
	view activeToolMode: ((WDELevelEditorViewCameraRotateDragToolMode for: view)
		dragStartedWith: event;
		yourself)
]

{ #category : 'as yet unclassified' }
WDELevelEditorViewEditionMode >> startManipulatorOrActionDraggingWith: event [
	self supportsManipulators ifTrue: [
		| manipulator |
		manipulator := view manipulatorInScreenPosition: event position.
		manipulator ifNotNil: [
			^ manipulator startDragToolWithEvent: event
		].
	].

	^ self startActionDraggingWith: event
]

{ #category : 'as yet unclassified' }
WDELevelEditorViewEditionMode >> supportsElementSelection [
	^ false
]

{ #category : 'as yet unclassified' }
WDELevelEditorViewEditionMode >> supportsManipulators [
	^ false
]

{ #category : 'as yet unclassified' }
WDELevelEditorViewEditionMode >> validRightClickSelectionWheelFor: clickPosition [
	(clickSelectionWheel notNil and: [ clickSelectionWheel isValidForPositionForRightClick: clickPosition view: view ]) ifFalse: [
		^ clickSelectionWheel := WDELevelEditorSelectionClickWheel new
			clickPosition: clickPosition;
			elements: (view elementsInPositionWithRayPicking: clickPosition mode: self currentModelingEditionMode);
			yourself.
	].

	^ clickSelectionWheel
]
