Class {
	#name : 'WDELevelEditorViewObjectEditionMode',
	#superclass : 'WDELevelEditorViewEditionMode',
	#category : 'WodenEditor-UI-ViewMode',
	#package : 'WodenEditor-UI',
	#tag : 'ViewMode'
}

{ #category : 'as yet unclassified' }
WDELevelEditorViewObjectEditionMode >> modeName [
	^ 'Object Mode'
]

{ #category : 'as yet unclassified' }
WDELevelEditorViewObjectEditionMode >> startActionDraggingWith: event [
	view activeToolMode: ((WDELevelEditorRectangleSelectionDragToolMode for: view)
		dragStartedWith: event;
		yourself)
	
]

{ #category : 'as yet unclassified' }
WDELevelEditorViewObjectEditionMode >> supportsElementSelection [
	^ true
]

{ #category : 'as yet unclassified' }
WDELevelEditorViewObjectEditionMode >> supportsManipulators [
	^ true
]
