Class {
	#name : 'WDELevelEditorDuplicatePlacementToolMode',
	#superclass : 'WDELevelEditorViewActionMoveToolMode',
	#instVars : [
		'oldSelection',
		'duplicatedElements',
		'transformStateMementos'
	],
	#category : 'WodenEditor-UI-ViewMode',
	#package : 'WodenEditor-UI',
	#tag : 'ViewMode'
}

{ #category : 'as yet unclassified' }
WDELevelEditorDuplicatePlacementToolMode >> applyPositionToElements [
	| translation |
	currentPosition ifNil: [ ^ self ].
	
	translation := self levelEditorSession snapToSubGrid: (view cameraXYDeltaToWorld: currentPosition - startPosition distance: screenDistance).
	duplicatedElements doWithIndex: [ :each :index |
		each
			restoreTransformStateMemento: (transformStateMementos at: index);
			translateBy: translation
	].
	view refresh.
]

{ #category : 'as yet unclassified' }
WDELevelEditorDuplicatePlacementToolMode >> dragCancelled [
	duplicatedElements do: [ :each | each removeFromParent ].
	super dragCancelled
]

{ #category : 'as yet unclassified' }
WDELevelEditorDuplicatePlacementToolMode >> dragDelta: delta [
	self applyPositionToElements
]

{ #category : 'as yet unclassified' }
WDELevelEditorDuplicatePlacementToolMode >> dragFinished [
	| parents undoBlock newSelection editorSession |
	self applyPositionToElements.
	
	parents := duplicatedElements collect: [ :each | each parent ].

	newSelection := WDELevelEditorSelection for: duplicatedElements.
	editorSession := self levelEditorSession.
	undoBlock := [
		duplicatedElements do: [ :each | each removeFromParent ].
		editorSession selection: oldSelection.
	].
	undoBlock value.
	editorSession
		doWith: [
			duplicatedElements doWithIndex: [ :each :index |
				(parents at: index) add: each
			].
			editorSession selection: newSelection.
		] undoWith: undoBlock.
	
	super dragFinished
]

{ #category : 'as yet unclassified' }
WDELevelEditorDuplicatePlacementToolMode >> dragStarted [
	| bbox |
	bbox := AABox empty.
	duplicatedElements do: [ :each |
		bbox insertBox: each boundingBox 
	].

	bbox isEmpty ifFalse: [ 
		screenDistance := view computeScreenDistanceForPoint: bbox center
	].

]

{ #category : 'accessing' }
WDELevelEditorDuplicatePlacementToolMode >> duplicatedElements [

	^ duplicatedElements
]

{ #category : 'accessing' }
WDELevelEditorDuplicatePlacementToolMode >> duplicatedElements: anObject [

	duplicatedElements := anObject.
	transformStateMementos := duplicatedElements collect: [ :each | each transformStateMemento ].
]

{ #category : 'accessing' }
WDELevelEditorDuplicatePlacementToolMode >> modeName [
	^ 'Duplicate Placement'
]

{ #category : 'accessing' }
WDELevelEditorDuplicatePlacementToolMode >> oldSelection [

	^ oldSelection
]

{ #category : 'accessing' }
WDELevelEditorDuplicatePlacementToolMode >> oldSelection: anObject [

	oldSelection := anObject
]
