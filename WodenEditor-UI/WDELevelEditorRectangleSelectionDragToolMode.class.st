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

	event modifiers shift ifTrue: [
		^ self levelEditorSession addElementsToSelection: elements
	].
	event modifiers ctrl ifTrue: [ 
		^ self levelEditorSession toggleElementsFromSelection: elements
	].
	^ self levelEditorSession setSelectedElements: elements
]

{ #category : #accessing }
WDELevelEditorRectangleSelectionDragToolMode >> modeName [
	^ 'Rectangle selection'
]
