Class {
	#name : 'WDELevelEditor3DManipulator',
	#superclass : 'Object',
	#instVars : [
		'view',
		'highlighted',
		'boundingBox',
		'parent',
		'children',
		'sceneNode'
	],
	#category : 'WodenEditor-UI-Manipulators',
	#package : 'WodenEditor-UI',
	#tag : 'Manipulators'
}

{ #category : 'instance creation' }
WDELevelEditor3DManipulator class >> for: aView [
	^ self new view: aView; yourself
]

{ #category : 'actions' }
WDELevelEditor3DManipulator >> activateAction [
	"This activates and action associated with this manipulator"
]

{ #category : 'scene' }
WDELevelEditor3DManipulator >> addToScene: aScene [
	sceneNode := self createSceneNode.
	sceneNode ifNotNil: [ aScene add: sceneNode ].
	children do: [ :each | each addToScene: aScene ].
]

{ #category : 'as yet unclassified' }
WDELevelEditor3DManipulator >> applyHighlightingEffect [
]

{ #category : 'element manipulation' }
WDELevelEditor3DManipulator >> applyTransform: transformation [
]

{ #category : 'element manipulation' }
WDELevelEditor3DManipulator >> applyTransformForTranslationDelta: translationDelta [
]

{ #category : 'accessing' }
WDELevelEditor3DManipulator >> boundingBox [
	^ boundingBox
]

{ #category : 'accessing' }
WDELevelEditor3DManipulator >> children: newChildren [
	sceneNode ifNotNil: [
		children do: [ :each | each removeFromScene ].
	].
	children := newChildren.
	children do: [ :each | each parent: self ].
	sceneNode ifNotNil: [
		children do: [ :each | each addToScene: sceneNode scene ]
	]
]

{ #category : 'scene' }
WDELevelEditor3DManipulator >> createSceneNode [
	self subclassResponsibility
]

{ #category : 'as yet unclassified' }
WDELevelEditor3DManipulator >> currentDragToolClass [
	^ nil
]

{ #category : 'as yet unclassified' }
WDELevelEditor3DManipulator >> editorTheme [
	^ WDELevelEditorTheme current
]

{ #category : 'accessing' }
WDELevelEditor3DManipulator >> highlighted [

	^ highlighted
]

{ #category : 'accessing' }
WDELevelEditor3DManipulator >> highlighted: aBoolean [
	highlighted := aBoolean.
	self applyHighlightingEffect.
]

{ #category : 'initialization' }
WDELevelEditor3DManipulator >> initialize [
	super initialize.
	highlighted := false.
	boundingBox := AABox empty.
	children := #().
]

{ #category : 'memento' }
WDELevelEditor3DManipulator >> mementoForDragging [
	^ nil
]

{ #category : 'accessing' }
WDELevelEditor3DManipulator >> parent [

	^ parent
]

{ #category : 'accessing' }
WDELevelEditor3DManipulator >> parent: anObject [

	parent := anObject
]

{ #category : 'as yet unclassified' }
WDELevelEditor3DManipulator >> rayCast: ray [
	| bestResult distance |
	self visible ifFalse: [ ^ nil ].
	bestResult := nil.
	children do: [ :each |
		(each rayCast: ray) ifNotNil: [:childResult |
			(bestResult isNil or: [childResult < bestResult]) ifTrue: [
				bestResult := childResult
			]
		]
	].
	bestResult value ifNotNil: [ ^ bestResult ].
	boundingBox isEmpty ifTrue: [ ^ nil ].

	distance := boundingBox intersectionWithRay: ray.
	distance ifNil: [ ^ nil ].
	^ distance -> self.
]

{ #category : 'scene' }
WDELevelEditor3DManipulator >> removeFromScene [
	children do: [ :each | each removeFromScene ].
	sceneNode ifNotNil: [
		sceneNode removeFromScene.
		sceneNode := nil
	]
]

{ #category : 'memento' }
WDELevelEditor3DManipulator >> restoreMementoForDragging: memento [
]

{ #category : 'accessing' }
WDELevelEditor3DManipulator >> sceneNode [
	^ sceneNode
]

{ #category : 'as yet unclassified' }
WDELevelEditor3DManipulator >> selectedItemsBoundingBoxChanged [
]

{ #category : 'as yet unclassified' }
WDELevelEditor3DManipulator >> sizeScaleFactorForPosition: position [
	^ view isPerspective
		ifTrue: [ (position - view cameraPosition) length max: 1.0 ]
		ifFalse: [ view viewScale * 2.0 ]
]

{ #category : 'as yet unclassified' }
WDELevelEditor3DManipulator >> startDragToolWithEvent: event [
	| dragToolClass |
	dragToolClass := self currentDragToolClass.
	dragToolClass ifNil: [^ self].
	view activeToolMode:
		((dragToolClass for: view)
			manipulator: self;
			dragStartedWith: event;
			yourself)
]

{ #category : 'as yet unclassified' }
WDELevelEditor3DManipulator >> updateForViewCamera [
	children do: [ :each | each updateForViewCamera ].
]

{ #category : 'accessing' }
WDELevelEditor3DManipulator >> view [

	^ view
]

{ #category : 'accessing' }
WDELevelEditor3DManipulator >> view: anObject [

	view := anObject
]

{ #category : 'accessing' }
WDELevelEditor3DManipulator >> visible [
	^ sceneNode notNil and: [ sceneNode visible ]
]

{ #category : 'accessing' }
WDELevelEditor3DManipulator >> visible: aBoolean [
	sceneNode ifNotNil: [
		sceneNode visible: aBoolean.
		view refresh
	]
]
