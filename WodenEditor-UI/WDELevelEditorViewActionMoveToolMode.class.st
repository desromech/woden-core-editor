Class {
	#name : #WDELevelEditorViewActionMoveToolMode,
	#superclass : #WDELevelEditorViewMode,
	#instVars : [
		'screenDistance',
		'currentPosition',
		'endPosition',
		'startPosition'
	],
	#category : #'WodenEditor-UI-ViewMode'
}

{ #category : #initialization }
WDELevelEditorViewActionMoveToolMode >> cameraXZDeltaToWorld: delta [
	^ view cameraXZDeltaToWorld: delta distance: screenDistance
]

{ #category : #'as yet unclassified' }
WDELevelEditorViewActionMoveToolMode >> dragCancelled [
	self view
		activeToolMode: nil
]

{ #category : #'as yet unclassified' }
WDELevelEditorViewActionMoveToolMode >> dragDelta: delta [
]

{ #category : #'as yet unclassified' }
WDELevelEditorViewActionMoveToolMode >> dragFinished [
	self view
		activeToolMode: nil
]

{ #category : #'as yet unclassified' }
WDELevelEditorViewActionMoveToolMode >> dragStarted [
]

{ #category : #initialization }
WDELevelEditorViewActionMoveToolMode >> initialize [
	super initialize.
	screenDistance := 1.0.
]

{ #category : #event }
WDELevelEditorViewActionMoveToolMode >> onKeyDown: event [
	(event asKeyCombination matches: Character escape asKeyCombination) ifTrue: [ 
		self dragCancelled
	]
]

{ #category : #event }
WDELevelEditorViewActionMoveToolMode >> onLeftClick: event [
	endPosition := currentPosition := event position.
	self dragFinished
]

{ #category : #event }
WDELevelEditorViewActionMoveToolMode >> onMouseMove: event [
	currentPosition := event position.
	startPosition ifNil: [
		startPosition := currentPosition.
		self dragStarted.
	] ifNotNil: [
		self dragDelta: currentPosition - startPosition
	]
]

{ #category : #event }
WDELevelEditorViewActionMoveToolMode >> onRightClick: event [
	self dragCancelled
]

{ #category : #accessing }
WDELevelEditorViewActionMoveToolMode >> view: aView [
	super view: aView.
	screenDistance := aView cameraFocalPointDistance.
]
