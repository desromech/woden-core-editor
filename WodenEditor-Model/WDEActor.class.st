"
I am an actor from the Woden Game Framework.
"
Class {
	#name : #WDEActor,
	#superclass : #WDModelingGroup,
	#instVars : [
		'className'
	],
	#category : #'WodenEditor-Model-Level'
}

{ #category : #serialization }
WDEActor class >> jsonObjectTypeName [
	^ self name withoutPrefix: 'WDE'
]

{ #category : #'property pages' }
WDEActor >> buildModelingElementMainPropertyPageWith: builder [
	super buildModelingElementMainPropertyPageWith: builder.
	builder
		stringPropertyNamed: 'Class Name' selector: #className.
]

{ #category : #testing }
WDEActor >> canBeDuplicatedAndPlaced [
	^ self isLevelStatic not
]

{ #category : #accessing }
WDEActor >> className [

	^ className
]

{ #category : #accessing }
WDEActor >> className: anObject [

	className := anObject
]

{ #category : #serialization }
WDEActor >> encodeJsonKeyValuesWithContext: serializationContext [
	^ (super encodeJsonKeyValuesWithContext: serializationContext) , {
		#className . className .
	}
]

{ #category : #initialization }
WDEActor >> initialize [
	super initialize.
	className := 'Actor'.
]

{ #category : #testing }
WDEActor >> isLevelStatic [
	^ className = 'StaticActor'

]

{ #category : #testing }
WDEActor >> isPointPlacedElement [
	^ true
]

{ #category : #testing }
WDEActor >> isSceneSelectableObject [
	^ self isLevelStatic not
]

{ #category : #serialization }
WDEActor >> loadFromJson: jsonData withContext: level [
	super loadFromJson: jsonData withContext: level.
	className := jsonData at: #className ifAbsent: [ className ].

]

{ #category : #accessing }
WDEActor >> localBoundingBox [
	self isLevelStatic ifFalse: [
		^ WDModelingCommonMeshes uniqueInstance pointObjectBoundingBox
	].
	^ super localBoundingBox
]

{ #category : #accessing }
WDEActor >> objectTypeName [
	^ (className isNil or: [className isEmpty]) ifTrue: ['Actor'] ifFalse: [ self className ]
]

{ #category : #'scene presentation' }
WDEActor >> updateScenePresentationHandle: aHandle [
	super updateScenePresentationHandle: aHandle.
	self isLevelStatic ifTrue: [ ^ self ].
	
	aHandle sceneNode
		castShadows: false;
		renderables: {
		WDModelingCommonMeshes uniqueInstance pointObjectDisplayBox copyWithMaterial: WDModelingCommonMeshes uniqueInstance greenPointObjectDisplayMaterial
	}
]
