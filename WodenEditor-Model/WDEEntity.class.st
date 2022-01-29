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
		'sceneNode',
		'editorColor',
		'properties',
		'terrains'
	],
	#category : #'WodenEditor-Model-Level'
}

{ #category : #adding }
WDEEntity >> addBrush: aBrush [
	brushes add: aBrush.
	aBrush parent: self.
	sceneNode ifNotNil: [ aBrush addedToScene: self level editorScene ].
	self level ifNotNil: [ :l | l addedOrRemovedElement ].
]

{ #category : #adding }
WDEEntity >> addChild: child [
	child addToEntity: self
]

{ #category : #adding }
WDEEntity >> addTerrain: aTerrain [
	terrains add: aTerrain.
	aTerrain parent: self.
	sceneNode ifNotNil: [ aTerrain addedToScene: self level editorScene ].
	self level ifNotNil: [ :l | l addedOrRemovedElement ].
]

{ #category : #accessing }
WDEEntity >> addedToScene: aScene [
	sceneNode := WDSceneNode new
		transform: transform;
		yourself.
	aScene add: sceneNode.
	
	brushes do: [ :each | each addedToScene: aScene ].
	terrains do: [ :each | each addedToScene: aScene ].
]

{ #category : #accessing }
WDEEntity >> brushes [
	^ brushes
]

{ #category : #testing }
WDEEntity >> canBeDuplicatedAndPlaced [
	^ self isWorldEntity not
]

{ #category : #accessing }
WDEEntity >> className [
	^ className
]

{ #category : #accessing }
WDEEntity >> className: anObject [

	className := anObject
]

{ #category : #accessing }
WDEEntity >> editorColor [

	^ editorColor
]

{ #category : #accessing }
WDEEntity >> editorColor: anObject [

	editorColor := anObject
]

{ #category : #'as yet unclassified' }
WDEEntity >> editorTreeChildren [
	^ brushes , terrains
]

{ #category : #'as yet unclassified' }
WDEEntity >> editorTreeDisplayName [
	^ className asString
]

{ #category : #serialization }
WDEEntity >> encodeJsonKeyValues [
	^ {
		#className . className .
		#transform . transform encodeForJSON.
		#editorColor . editorColor encodeForJSON.
		#properties . properties.
		#brushes . brushes collect: [ :each | each encodeForJSON ].
		#terrains . terrains collect: [ :each | each encodeForJSON ].
	}
]

{ #category : #'as yet unclassified' }
WDEEntity >> findVolumeElementsThatIntersectElements: elementsToTest [
	| result |
	result := OrderedCollection new.
	brushes do: [ :eachBrush |
		(elementsToTest includes: eachBrush) ifFalse: [
			(elementsToTest anySatisfy: [ :testElement | eachBrush hasIntersectsWithVolume: testElement ]) ifTrue: [ 
				result add: eachBrush
			]
		]
	].
	^ result
]

{ #category : #'as yet unclassified' }
WDEEntity >> generateEditorColor [
	editorColor := self class generateEditorColor.
]

{ #category : #accessing }
WDEEntity >> globalTransform [
	^ parent
		ifNil: [transform]
		ifNotNil: [parent globalTransform transformTransform: transform]
]

{ #category : #initialization }
WDEEntity >> initialize [
	super initialize.
	brushes := OrderedCollection new.
	terrains := OrderedCollection new.
	transform := TRSTransform3D identity.
	properties := Dictionary new.
	editorColor := Vector4 ones.
]

{ #category : #'as yet unclassified' }
WDEEntity >> instantiateForPlacingInLevel: level box: placementBox [
	| instance |
	instance := self copy setupForNewInstance.
	instance transformWith: (placementBox trsTransformToConvertToMe: instance boundingBox).
	level addEntity: instance.
	^ instance
]

{ #category : #'as yet unclassified' }
WDEEntity >> instantiateForPlacingInLevel: level point: placementPoint [
	| instance |
	instance := self copy setupForNewInstance.
	instance position: placementPoint.
	level addEntity: instance.
	^ instance
]

{ #category : #testing }
WDEEntity >> isWorldEntity [
	^ #(worldspawn world) includes: className
]

{ #category : #serialization }
WDEEntity >> loadFromJson: jsonData inLevel: level [
	className := jsonData at: #className ifAbsent: [ '' ].
	jsonData at: #transform ifPresent: [ :found | transform := TRSTransform3D loadFromJson: found ].
	jsonData at: #editorColor ifPresent: [ :found | editorColor := Vector4 loadFromJson: found ].
	properties := properties at: #properties ifAbsent: [ Dictionary new ].
	brushes := (jsonData at: #brushes ifAbsent: [ #() ]) collect: [ :each |
		WDEBrush new
			loadFromJson: each inLevel: level;
			parent: self;
			yourself
	] as: OrderedCollection.
	terrains := (jsonData at: #terrains ifAbsent: [ #() ]) collect: [ :each |
		WDETerrain new
			loadFromJson: each inLevel: level;
			parent: self;
			yourself
	] as: OrderedCollection.
]

{ #category : #copying }
WDEEntity >> postCopy [
	brushes := brushes collect: [ :each | each copy ].
	sceneNode := nil.
	transform := transform copy.
]

{ #category : #serialization }
WDEEntity >> prepareForSerializationInLevel: level [
	brushes do: [ :each | each prepareForSerializationInLevel: level ].
	terrains do: [ :each | each prepareForSerializationInLevel: level ].
]

{ #category : #accessing }
WDEEntity >> rayCastAllAlong: ray [
	| localRay result |
	localRay := ray inverseTransformedWith: transform.

	result := OrderedCollection new.
	brushes do: [ :brush |
		result addAll: (brush rayCastAllAlong: localRay)
	].
	terrains do: [ :terrain |
		result addAll: (terrain rayCastAllAlong: localRay)
	].

	^ result collect: [ :each |
		(ray distanceForPoint: (transform transformPosition: (localRay pointAtDistance: each key))) -> each value
	]
]

{ #category : #removing }
WDEEntity >> removeBrush: aBrush [
	brushes remove: aBrush.
	sceneNode ifNotNil: [ 
		aBrush removedFromScene: self level editorScene
	].
	aBrush parent: nil.
	self level ifNotNil: [ :l | l addedOrRemovedElement ].
]

{ #category : #removing }
WDEEntity >> removeFromParent [
	parent ifNotNil: [ parent removeEntity: self ]

]

{ #category : #removing }
WDEEntity >> removeTerrain: aTerrain [
	terrains remove: aTerrain.
	sceneNode ifNotNil: [ 
		aTerrain removedFromScene: self level editorScene
	].
	aTerrain parent: nil.
	self level ifNotNil: [ :l | l addedOrRemovedElement ].
]

{ #category : #accessing }
WDEEntity >> removedFromScene: aScene [
	brushes do: [ :each | each removedFromScene: aScene ].
	terrains do: [ :each | each removedFromScene: aScene ].
	sceneNode ifNotNil: [ 
		sceneNode removeFromScene.
		sceneNode := nil.
	]
]

{ #category : #accessing }
WDEEntity >> sceneNode [
	^ sceneNode
]

{ #category : #'as yet unclassified' }
WDEEntity >> setupForNewInstance [
	self generateEditorColor
]

{ #category : #accessing }
WDEEntity >> transform [

	^ transform
]

{ #category : #accessing }
WDEEntity >> transform: anObject [

	transform := anObject
]
