"
I am an entity in a quake style level.
"
Class {
	#name : #WDEEntity,
	#superclass : #WDELevelElement,
	#instVars : [
		'className',
		'brushes',
		'transform',
		'sceneNode'
	],
	#category : #'WodenEditor-Model-Level'
}

{ #category : #adding }
WDEEntity >> addBrush: aBrush [
	brushes add: aBrush.
	aBrush parent: self.
]

{ #category : #accessing }
WDEEntity >> addedToScene: aScene [
	sceneNode := WDSceneNode new
		transform: transform;
		yourself.
	aScene add: sceneNode.
	
	brushes do: [ :each | each addedToScene: aScene ].
]

{ #category : #accessing }
WDEEntity >> className [
	^ className
]

{ #category : #accessing }
WDEEntity >> className: anObject [

	className := anObject
]

{ #category : #'as yet unclassified' }
WDEEntity >> editorTreeChildren [
	^ brushes
]

{ #category : #'as yet unclassified' }
WDEEntity >> editorTreeDisplayName [
	^ className asString
]

{ #category : #initialization }
WDEEntity >> initialize [
	super initialize.
	brushes := OrderedCollection new.
	transform := TRSTransform3D identity.
]

{ #category : #testing }
WDEEntity >> isWorldEntity [
	^ #(worldspawn world) includes: className
]

{ #category : #accessing }
WDEEntity >> rayCastAllAlong: ray [
	| localRay result |
	localRay := ray inverseTransformedWith: transform.

	result := OrderedCollection new.
	brushes do: [ :brush |
		result addAll: (brush rayCastAllAlong: localRay)
	].
	^ result
]

{ #category : #accessing }
WDEEntity >> removeFromScene: aScene [
	brushes do: [ :each | each removeFromScene: aScene ].
	sceneNode ifNotNil: [ 
		sceneNode removeFromScene.
		sceneNode := nil.
	]
]

{ #category : #accessing }
WDEEntity >> sceneNode [
	^ sceneNode
]

{ #category : #accessing }
WDEEntity >> transform [

	^ transform
]

{ #category : #accessing }
WDEEntity >> transform: anObject [

	transform := anObject
]
