Class {
	#name : #WDELevelEditorRectangleSelectionDragToolMode,
	#superclass : #WDELevelEditorViewDragToolMode,
	#category : #'WodenEditor-UI-ViewMode'
}

{ #category : #'as yet unclassified' }
WDELevelEditorRectangleSelectionDragToolMode >> finishDraggingWith: event [
	| elements |
	super finishDraggingWith: event.
	elements := view elementsInScreenRectangle: (dragStartPosition corner: dragEndPosition).

	event shiftPressed ifTrue: [
		^ self levelEditorSession addElementsToSelection: elements
	].
	event controlKeyPressed ifTrue: [ 
		^ self levelEditorSession toggleElementsFromSelection: elements
	].
	^ self levelEditorSession setSelectedElements: elements
]

{ #category : #accessing }
WDELevelEditorRectangleSelectionDragToolMode >> modeName [
	^ 'Rectangle selection'
]
