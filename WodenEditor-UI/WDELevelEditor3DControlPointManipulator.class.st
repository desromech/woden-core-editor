Class {
	#name : #WDELevelEditor3DControlPointManipulator,
	#superclass : #WDELevelEditor3DManipulator,
	#instVars : [
		'controlPoint',
		'material',
		'currentHalfExtent'
	],
	#category : #'WodenEditor-UI-Manipulators'
}

{ #category : #adding }
WDELevelEditor3DControlPointManipulator >> addToScene: aScene [
	sceneNode := self createSceneNode.
	sceneNode ifNotNil: [ parent sceneNode add: sceneNode ].
	children do: [ :each | each addToScene: aScene ].
]

{ #category : #'as yet unclassified' }
WDELevelEditor3DControlPointManipulator >> applyHighlightingEffect [
	material ifNotNil: [
		material colorFactor: self currentColor.
		view refresh
	]
]

{ #category : #'element manipulation' }
WDELevelEditor3DControlPointManipulator >> applyTransform: transform [
	controlPoint transformWith: (parent transform inverseTransformTransform: transform).
	self controlPointChanged.
]

{ #category : #'element manipulation' }
WDELevelEditor3DControlPointManipulator >> applyTransformForTranslationDelta: translation [
	| localTranslation |
	localTranslation := (parent transform inverseTransformVector3: translation).
	controlPoint translateBy: localTranslation.
	self controlPointChanged.
]

{ #category : #accessing }
WDELevelEditor3DControlPointManipulator >> boundingBoxChanged [
	sceneNode ifNotNil: [ 
		sceneNode transform: boundingBox trsTransformToConvertUnitBoxToMe
	]
]

{ #category : #accessing }
WDELevelEditor3DControlPointManipulator >> controlPoint [

	^ controlPoint
]

{ #category : #accessing }
WDELevelEditor3DControlPointManipulator >> controlPoint: anObject [
	controlPoint := anObject.
	self controlPointChanged.
]

{ #category : #accessing }
WDELevelEditor3DControlPointManipulator >> controlPointChanged [
	boundingBox := AABox center: self position halfExtent: currentHalfExtent.
	self boundingBoxChanged
]

{ #category : #scene }
WDELevelEditor3DControlPointManipulator >> createSceneNode [
	boundingBox isEmpty ifTrue: [ ^ nil ].
	material := WDUnlitMaterial new
		xray: true;
		alphaMode: #BLEND;
		colorFactor: self currentColor;
		yourself.
	^ (WDELevelEditorMeshes uniqueInstance flatShadedTranslucentUnitCubeMesh copyWithMaterial: material) asSceneNode
		transform: (TRSTransform3D translation: self position);
		yourself
]

{ #category : #'brick-properties' }
WDELevelEditor3DControlPointManipulator >> currentColor [
	^ highlighted
		ifTrue: [ self editorTheme highlightedBoxCornerHandleColor  ]
		ifFalse: [ self editorTheme boxCornerHandleColor ]
]

{ #category : #'as yet unclassified' }
WDELevelEditor3DControlPointManipulator >> currentDragToolClass [
	^ WDELevelEditorViewTranslateManipulatorDragToolMode
]

{ #category : #accessing }
WDELevelEditor3DControlPointManipulator >> halfExtent: halfExtent [
	currentHalfExtent := halfExtent.
	self controlPointChanged.
]

{ #category : #initialization }
WDELevelEditor3DControlPointManipulator >> initialize [
	super initialize.
	currentHalfExtent:= Vector3 withAll: 0.1.
]

{ #category : #memento }
WDELevelEditor3DControlPointManipulator >> mementoForDragging [
	^ {boundingBox . self controlPoint position}
]

{ #category : #accessing }
WDELevelEditor3DControlPointManipulator >> position [
	parent ifNil: [ ^ controlPoint position ].
	^ parent transform transformPosition: controlPoint position
]

{ #category : #memento }
WDELevelEditor3DControlPointManipulator >> restoreMementoForDragging: memento [
	boundingBox := memento first.
	controlPoint position: memento second
]

{ #category : #'as yet unclassified' }
WDELevelEditor3DControlPointManipulator >> sizeScaleFactorForPosition: position [
	| worldScale |
	worldScale := super sizeScaleFactorForPosition: self position.
	^ worldScale * 2.0
]

{ #category : #'as yet unclassified' }
WDELevelEditor3DControlPointManipulator >> updateForViewCamera [
	super updateForViewCamera.
	self halfExtent: 0.005 * (self sizeScaleFactorForPosition: (self position)).
]
