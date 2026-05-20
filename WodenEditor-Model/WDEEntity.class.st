"
I am an entity in a quake style level.
"
Class {
	#name : 'WDEEntity',
	#superclass : 'WDModelingGroup',
	#instVars : [
		'className',
		'properties'
	],
	#category : 'WodenEditor-Model-Level',
	#package : 'WodenEditor-Model',
	#tag : 'Level'
}

{ #category : 'serialization' }
WDEEntity class >> jsonObjectTypeName [
	^ self name withoutPrefix: 'WDE'
]

{ #category : 'property pages' }
WDEEntity >> buildModelingElementMainPropertyPageWith: builder [
	super buildModelingElementMainPropertyPageWith: builder.
	builder
		stringPropertyNamed: 'Class Name' selector: #className
]

{ #category : 'testing' }
WDEEntity >> canBeDuplicatedAndPlaced [
	^ self isWorldEntity not
]

{ #category : 'accessing' }
WDEEntity >> className [
	^ className
]

{ #category : 'accessing' }
WDEEntity >> className: anObject [

	className := anObject
]

{ #category : 'serialization' }
WDEEntity >> encodeJsonKeyValuesWithContext: serializationContext [
	^ (super encodeJsonKeyValuesWithContext: serializationContext) , {
		#className . className .
		#properties . properties.
	}
]

{ #category : 'accessing' }
WDEEntity >> exportToMap: out [
	| sortedProperties |
	out nextPutAll: '// entity ';lf.

	out nextPutAll: '{'; lf.
	className  = 'worldspawn' ifTrue: [ 
		out nextPutAll: ('"{1}" "{2}"' format: {'mapversion'. '220'}); lf.
	].
	out nextPutAll: ('"{1}" "{2}"' format: {'classname'. className}); lf.
	
	transform translation = Vector3 zeros ifFalse: [ 
		| origin |
		origin := self class wodenToQuakeCoordinates: transform translation.
		out nextPutAll: ('"{1}" "{2} {3} {4}"' format: {
			'origin'. origin x rounded printString. origin y rounded printString. origin z rounded printString 
		}); lf.
	].
	
	sortedProperties := OrderedCollection new.
	properties keysAndValuesDo: [ :key : value |
		sortedProperties add: key -> value
	].
	sortedProperties sort.
	sortedProperties do: [ :property |
		out nextPutAll: ('"{1}" "{2}"' format: {property key. property value}); lf.
	].

	self children select: [ :each | each isBSPBrush ] thenDo: [ :each |
		each exportToMap: out
	].
	out nextPutAll: '}'; lf.
]

{ #category : 'initialization' }
WDEEntity >> initialize [
	super initialize.
	className := ''.
	properties := Dictionary new.
]

{ #category : 'testing' }
WDEEntity >> isPointEntity [
	^ self children isEmpty and: [ self isWorldEntity not ]
]

{ #category : 'testing' }
WDEEntity >> isPointModelingElement [
	^ self isPointEntity
]

{ #category : 'testing' }
WDEEntity >> isPointPlacedElement [
	^ self isPointEntity
]

{ #category : 'testing' }
WDEEntity >> isSceneSelectableObject [
	^ self isWorldEntity not
]

{ #category : 'testing' }
WDEEntity >> isWorldEntity [
	^ #(worldspawn world) includes: className
]

{ #category : 'serialization' }
WDEEntity >> loadFromJson: jsonData withContext: level [
	super loadFromJson: jsonData withContext: level.
	className := jsonData at: #className ifAbsent: [ className ].
	properties := jsonData at: #properties ifAbsent: [ properties ].

]

{ #category : 'accessing' }
WDEEntity >> localBoundingBox [
	self isPointEntity ifTrue: [
		^ WDModelingCommonMeshes uniqueInstance pointObjectBoundingBox
	].
	^ super localBoundingBox
]

{ #category : 'accessing' }
WDEEntity >> objectTypeName [
	^ 'Entity'
]

{ #category : 'scene presentation' }
WDEEntity >> updateScenePresentationHandle: aHandle [
	super updateScenePresentationHandle: aHandle.
	self isPointEntity ifTrue: [
		aHandle sceneNode
			castShadows: false;
			renderables: {
			WDModelingCommonMeshes uniqueInstance pointObjectDisplayBox copyWithMaterial: WDModelingCommonMeshes uniqueInstance greenPointObjectDisplayMaterial
		}
	].
]
