Class {
	#name : #WDELevelEditorViewTranslateManipulatorDragToolMode,
	#superclass : #WDELevelEditorViewManipulatorDragToolMode,
	#category : #'WodenEditor-UI-ViewMode'
}

{ #category : #accessing }
WDELevelEditorViewTranslateManipulatorDragToolMode >> modeName [
	^ 'Translate'
]

{ #category : #accessing }
WDELevelEditorViewTranslateManipulatorDragToolMode >> onMouseDrag: event delta: delta [
	| mouseDelta worldDelta |
	mouseDelta := event position - dragStartPosition.
	
	worldDelta := event controlKeyPressed ifTrue: [
		view cameraXZDeltaToWorld: mouseDelta distance: dragScreenDistance
	] ifFalse: [
		view cameraXYDeltaToWorld: mouseDelta distance: dragScreenDistance
	].

	manipulator
		restoreMementoForDragging: memento;
		applyTransformForTranslationDelta: (self levelEditorSession snapToSubGrid: worldDelta).
	view refresh.
]
