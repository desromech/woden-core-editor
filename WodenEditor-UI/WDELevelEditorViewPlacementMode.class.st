Class {
	#name : #WDELevelEditorViewPlacementMode,
	#superclass : #WDELevelEditorViewEditionMode,
	#category : #'WodenEditor-UI-ViewMode'
}

{ #category : #actions }
WDELevelEditorViewPlacementMode >> cancelAction [
	view activateObjectMode
]

{ #category : #testing }
WDELevelEditorViewPlacementMode >> isPlacementMode [
	^ true
]

{ #category : #accessing }
WDELevelEditorViewPlacementMode >> modeName [
	^ 'Placement Mode'
]

{ #category : #event }
WDELevelEditorViewPlacementMode >> onLeftClick: event [
	self levelEditorSession activeLevelElementTemplate ifNotNil: [ :elementTemplate |
		elementTemplate isPointElementTemplate ifTrue: [
			| entityLocation |
			entityLocation := self levelEditorSession snapToSubGrid: (view cameraXYToWorld: event position).
			elementTemplate instantiateInLevel: self levelEditorSession level placingInPoint: entityLocation session: self levelEditorSession.
			view activateObjectMode
		]
	]

]

{ #category : #'as yet unclassified' }
WDELevelEditorViewPlacementMode >> startActionDraggingWith: event [
	| manipulator |
	manipulator := view manipulatorInScreenPosition: event position.
	manipulator ifNotNil: [
		^ manipulator startDragToolWithEvent: event
	].

	self levelEditorSession activeLevelElementTemplate ifNotNil: [ :elementTemplate |
		elementTemplate isPointElementTemplate ifFalse: [
			view activeToolMode: ((WDELevelEditorBrushDrawDragToolMode for: view)
				dragStartedWith: event;
				yourself)
		]
	]
]

{ #category : #'as yet unclassified' }
WDELevelEditorViewPlacementMode >> supportsManipulators [
	^ true
]
