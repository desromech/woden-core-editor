Class {
	#name : 'WDELevelEditorRectangleSelectionDragToolMode',
	#superclass : 'WDELevelEditorViewDragToolMode',
	#category : 'WodenEditor-UI-ViewMode',
	#package : 'WodenEditor-UI',
	#tag : 'ViewMode'
}

{ #category : 'as yet unclassified' }
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

{ #category : 'accessing' }
WDELevelEditorRectangleSelectionDragToolMode >> modeName [
	^ 'Rectangle selection'
]

{ #category : 'event' }
WDELevelEditorRectangleSelectionDragToolMode >> onMouseDrag: event delta: delta [
	super onMouseDrag: event delta: delta.
	view dragToolScreenOverlay: (WDELevelEditorDragRectangleOverlay new
		color: Color blue muchLighter;
		rectangle: (dragStartPosition - view windowOrigin corner: event position - view windowOrigin);
		yourself)
]
