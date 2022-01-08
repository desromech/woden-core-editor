Class {
	#name : #WDELevelEditorRectangleSelectionDragToolMode,
	#superclass : #WDELevelEditorViewDragToolMode,
	#category : #'WodenEditor-UI-ViewMode'
}

{ #category : #'as yet unclassified' }
WDELevelEditorRectangleSelectionDragToolMode >> finishDraggingWith: event [
	| elements |
	super finishDraggingWith: event.
	"elements := view elementsInScreenRectangle: (dragStartPosition corner: dragEndPosition).

	event modifiers shift ifTrue: [
		^ view addElementsToSelection: elements
	].
	event modifiers ctrl ifTrue: [ 
		^ view toggleElementsFromSelection: elements
	].
	^ view setSelectedElements: elements"
]

{ #category : #accessing }
WDELevelEditorRectangleSelectionDragToolMode >> modeName [
	^ 'Rectangle selection'
]
