Class {
	#name : #WDELevelEditorSelectionTransformToolMode,
	#superclass : #WDELevelEditorViewActionMoveToolMode,
	#instVars : [
		'elements',
		'pivot',
		'selectedAxis',
		'screenPivot'
	],
	#category : #'WodenEditor-UI-ViewMode'
}

{ #category : #'as yet unclassified' }
WDELevelEditorSelectionTransformToolMode >> applyTransformToElements [
	self subclassResponsibility
]

{ #category : #'as yet unclassified' }
WDELevelEditorSelectionTransformToolMode >> dragCancelled [
	self restoreMementos.
	view selectedItemsBoundingBoxChanged; refresh.
	super dragCancelled
]

{ #category : #'as yet unclassified' }
WDELevelEditorSelectionTransformToolMode >> dragDelta: delta [
	self applyTransformToElements
]

{ #category : #'as yet unclassified' }
WDELevelEditorSelectionTransformToolMode >> dragFinished [
	self levelEditorSession
		doWith: [
			self applyTransformToElements.
		] undoWith: [
			self restoreMementos
		].
	
	super dragFinished
]

{ #category : #'as yet unclassified' }
WDELevelEditorSelectionTransformToolMode >> dragStarted [
	| bbox |
	bbox := AABox empty.
	elements do: [ :each |
		bbox insertBox: each boundingBox 
	].

	pivot := Vector3 zeros.
	bbox isEmpty ifFalse: [
		pivot := bbox center.
		screenPivot := view computeScreenPositionForPoint: pivot.
		screenDistance := view computeScreenDistanceForPoint: pivot.
	].

]

{ #category : #accessing }
WDELevelEditorSelectionTransformToolMode >> elements: newElements [

	elements := newElements.
	self storeMementos
]

{ #category : #'as yet unclassified' }
WDELevelEditorSelectionTransformToolMode >> restoreMementos [
	self subclassResponsibility
]

{ #category : #'as yet unclassified' }
WDELevelEditorSelectionTransformToolMode >> shortcuts [
	^ super shortcuts , {
		$x asKeyCombination . [ self toggleAxisSelection: (Vector3 x: 1) ].
		$y asKeyCombination . [ self toggleAxisSelection: (Vector3 y: 1) ].
		$z asKeyCombination . [ self toggleAxisSelection: (Vector3 z: 1) ].
		
		$x shift . [ self toggleAxisSelection: (Vector3 x: 0 y: 1 z: 1) ].
		$y shift . [ self toggleAxisSelection: (Vector3 x: 1 y: 0 z: 1) ].
		$z shift . [ self toggleAxisSelection: (Vector3 x: 1 y: 1 z: 0) ].
	}
]

{ #category : #'as yet unclassified' }
WDELevelEditorSelectionTransformToolMode >> storeMementos [
	self subclassResponsibility
]

{ #category : #'as yet unclassified' }
WDELevelEditorSelectionTransformToolMode >> toggleAxisSelection: newAxis [
	selectedAxis = newAxis ifTrue: [ 
		selectedAxis := nil
	] ifFalse: [ 
		selectedAxis := newAxis
	].
	self applyTransformToElements
]
