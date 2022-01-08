Class {
	#name : #WDELevelEditor3DManipulator,
	#superclass : #Object,
	#instVars : [
		'view',
		'highlighted',
		'boundingBox',
		'children',
		'sceneNode'
	],
	#category : #'WodenEditor-UI-Manipulators'
}

{ #category : #'instance creation' }
WDELevelEditor3DManipulator class >> for: aView [
	^ self new view: aView; yourself
]

{ #category : #actions }
WDELevelEditor3DManipulator >> activateAction [
	"This activates and action associated with this manipulator"
]

{ #category : #scene }
WDELevelEditor3DManipulator >> addToScene: aScene [
	sceneNode := self createSceneNode.
	sceneNode ifNotNil: [ aScene add: sceneNode ].
	children do: [ :each | each addToScene: aScene ].
]

{ #category : #scene }
WDELevelEditor3DManipulator >> createSceneNode [
	self subclassResponsibility
]

{ #category : #'as yet unclassified' }
WDELevelEditor3DManipulator >> currentDragToolClass [
	^ nil
]

{ #category : #initialization }
WDELevelEditor3DManipulator >> initialize [
	super initialize.
	highlighted := false.
	boundingBox := AABox empty.
	children := #().
]

{ #category : #scene }
WDELevelEditor3DManipulator >> removeFromScene [
	children do: [ :each | each removeFromScene ].
	sceneNode ifNotNil: [
		sceneNode removeFromScene.
		sceneNode := nil
	]
]

{ #category : #accessing }
WDELevelEditor3DManipulator >> view [

	^ view
]

{ #category : #accessing }
WDELevelEditor3DManipulator >> view: anObject [

	view := anObject
]
