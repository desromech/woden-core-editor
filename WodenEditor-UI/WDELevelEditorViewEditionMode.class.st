Class {
	#name : #WDELevelEditorViewEditionMode,
	#superclass : #WDELevelEditorViewMode,
	#instVars : [
		'clickSelectionWheel'
	],
	#category : #'WodenEditor-UI-ViewMode'
}

{ #category : #actions }
WDELevelEditorViewEditionMode >> activateAction [
]

{ #category : #actions }
WDELevelEditorViewEditionMode >> cancelAction [
]

{ #category : #'as yet unclassified' }
WDELevelEditorViewEditionMode >> nextValidClickSelectionWheelFor: clickPosition [
	(clickSelectionWheel isNotNil and: [ clickSelectionWheel isValidForPosition: clickPosition ]) ifFalse: [
		^ clickSelectionWheel := WDELevelEditorSelectionClickWheel new
			clickPosition: clickPosition;
			elements: (view elementsInScreenPosition: clickPosition);
			yourself.
	].

	^ clickSelectionWheel advance
]

{ #category : #event }
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

{ #category : #'as yet unclassified' }
WDELevelEditorViewEditionMode >> onMouseDragStart: event [
	event isPrimaryButton ifTrue: [ ^ self startManipulatorOrActionDraggingWith: event ].
	event isMiddleButton ifTrue: [ ^ self startCameraRotateDraggingWith: event ].
	event isSecondaryButton ifTrue: [ ^ self startCameraDraggingWith: event ].
]

{ #category : #'as yet unclassified' }
WDELevelEditorViewEditionMode >> shortcuts [
	^ super shortcuts , {
		KeyboardKey escape asKeyCombination . [ self cancelAction ].
		KeyboardKey enter asKeyCombination . [ self activateAction ].

		$s command mac | $s control unix | $s control win . [ self model actionSaveFile ].
		$o command mac | $o control unix | $o control win . [ self model actionOpenFile ].

		(KeyboardKey named: #KP_ADD) asKeyCombination asKeyCombination . [ self levelEditorSession increaseGridSize ].
		(KeyboardKey named: #KP_SUBTRACT) asKeyCombination asKeyCombination . [ self levelEditorSession decreaseGridSize ].

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

{ #category : #'as yet unclassified' }
WDELevelEditorViewEditionMode >> startCameraDraggingWith: event [
	view activeToolMode: ((WDELevelEditorViewCameraDragToolMode for: view)
		dragStartedWith: event;
		yourself)
]

{ #category : #'as yet unclassified' }
WDELevelEditorViewEditionMode >> startCameraRotateDraggingWith: event [
	view activeToolMode: ((WDELevelEditorViewCameraRotateDragToolMode for: view)
		dragStartedWith: event;
		yourself)
]

{ #category : #'as yet unclassified' }
WDELevelEditorViewEditionMode >> startManipulatorOrActionDraggingWith: event [
	self supportsManipulators ifTrue: [
		| manipulator |
		manipulator := view manipulatorInScreenPosition: event position.
		manipulator ifNotNil: [
			^ manipulator startDragToolWithEvent: event on: view
		].
	].

	^ self startActionDraggingWith: event
]

{ #category : #'as yet unclassified' }
WDELevelEditorViewEditionMode >> supportsElementSelection [
	^ false
]

{ #category : #'as yet unclassified' }
WDELevelEditorViewEditionMode >> supportsManipulators [
	^ false
]
