Class {
	#name : #WDELevelEditor3DBoxCornerHandle,
	#superclass : #WDELevelEditor3DManipulator,
	#instVars : [
		'currentHalfExtent',
		'material'
	],
	#category : #'WodenEditor-UI-Manipulators'
}

{ #category : #'as yet unclassified' }
WDELevelEditor3DBoxCornerHandle >> applyHighlightingEffect [
	material ifNotNil: [
		material colorFactor: self currentColor.
		view refresh
	]
]

{ #category : #'element manipulation' }
WDELevelEditor3DBoxCornerHandle >> applyTransformForTranslationDelta: translation [
	| axis constrainedTranslation originalBox min max newBox transform sanitizedNewBox |
	originalBox := parent boundingBox.
	axis := self manipulatedBoxCornerAxis.
	constrainedTranslation := translation * axis abs.

	min := originalBox min copy.
	max := originalBox max copy.
	axis x < 0 ifTrue: [ min x: min x + constrainedTranslation x ].
	axis x > 0 ifTrue: [ max x: max x + constrainedTranslation x ].
	axis y < 0 ifTrue: [ min y: min y + constrainedTranslation y ].
	axis y > 0 ifTrue: [ max y: max y + constrainedTranslation y ].
	axis z < 0 ifTrue: [ min z: min z + constrainedTranslation z ].
	axis z > 0 ifTrue: [ max z: max z + constrainedTranslation z ].

	newBox := AABox min: (min min: max) max: (min max: max).
	sanitizedNewBox := AABox center: newBox center halfExtent: (newBox halfExtent max: 0.001).
	transform := sanitizedNewBox trsTransformToConvertToMe: originalBox.
	parent applyTransform: transform
]

{ #category : #accessing }
WDELevelEditor3DBoxCornerHandle >> boundingBoxChanged [
	sceneNode ifNotNil: [ 
		sceneNode transform: boundingBox trsTransformToConvertUnitBoxToMe
	]
]

{ #category : #scene }
WDELevelEditor3DBoxCornerHandle >> createSceneNode [
	boundingBox isEmpty ifTrue: [ ^ nil ].
	material := WDUnlitMaterial new colorFactor: self currentColor.
	^ (WDELevelEditorMeshes uniqueInstance flatShadedTranslucentUnitCubeMesh copyWithMaterial: material) asSceneNode
		transform: boundingBox trsTransformToConvertUnitBoxToMe;
		yourself
]

{ #category : #'brick-properties' }
WDELevelEditor3DBoxCornerHandle >> currentColor [
	^ highlighted
		ifTrue: [ self editorTheme highlightedBoxCornerHandleColor  ]
		ifFalse: [ self editorTheme boxCornerHandleColor ]
]

{ #category : #'as yet unclassified' }
WDELevelEditor3DBoxCornerHandle >> currentDragToolClass [
	^ WDELevelEditorViewTranslateManipulatorDragToolMode
]

{ #category : #initialization }
WDELevelEditor3DBoxCornerHandle >> initialize [
	super initialize.
	currentHalfExtent:= Vector3 withAll: 0.1
]

{ #category : #'element manipulation' }
WDELevelEditor3DBoxCornerHandle >> manipulatedBoxCornerAxis [
	^ (self position - self parent boundingBox center roundTo: 0.00001) sign.
]

{ #category : #memento }
WDELevelEditor3DBoxCornerHandle >> mementoForDragging [
	^ {boundingBox . parent transformStateMemento}
]

{ #category : #accessing }
WDELevelEditor3DBoxCornerHandle >> position [
	^ boundingBox center
]

{ #category : #accessing }
WDELevelEditor3DBoxCornerHandle >> position: position [
	boundingBox := AABox center: position halfExtent: currentHalfExtent.
	self boundingBoxChanged
]

{ #category : #memento }
WDELevelEditor3DBoxCornerHandle >> restoreMementoForDragging: memento [
	boundingBox := memento first.
	parent restoreTransformStateMemento: memento second.
	view refresh
]
