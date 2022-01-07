Class {
	#name : #WDELevelEditorViewDragToolMode,
	#superclass : #WDELevelEditorViewMode,
	#instVars : [
		'dragStartPosition',
		'dragEndPosition'
	],
	#category : #'WodenEditor-UI-ViewMode'
}

{ #category : #'as yet unclassified' }
WDELevelEditorViewDragToolMode >> dragStartedWith: startEvent [
	dragStartPosition := startEvent position.
]

{ #category : #'as yet unclassified' }
WDELevelEditorViewDragToolMode >> finishDraggingWith: event [
	dragEndPosition := event position.
	self view
		dragToolScreenOverlay: nil;
		activeToolMode: nil
]

{ #category : #event }
WDELevelEditorViewDragToolMode >> onMouseDragEnd: event [
	self finishDraggingWith: event.
]
