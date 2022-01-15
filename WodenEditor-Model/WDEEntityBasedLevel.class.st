"
I contain a quake style level.
"
Class {
	#name : #WDEEntityBasedLevel,
	#superclass : #WDELevel,
	#instVars : [
		'entities',
		'addedOrRemovedElementsBlock',
		'invalidSceneElements',
		'usedMaterials',
		'usedMaterialSet',
		'geometryChangedBlock'
	],
	#category : #'WodenEditor-Model-Level'
}

{ #category : #serialization }
WDEEntityBasedLevel class >> loadFromJson: jsonData [
	^ self new loadFromJson: jsonData
]

{ #category : #'as yet unclassified' }
WDEEntityBasedLevel class >> loadFromJsonString: jsonString [
	^ self loadFromJson: (NeoJSONReader fromString: jsonString)
]

{ #category : #'as yet unclassified' }
WDEEntityBasedLevel class >> validExtensions [
	^ #(weblvl)
]

{ #category : #adding }
WDEEntityBasedLevel >> addBrush: aBrush [
	self worldEntity addBrush: aBrush
]

{ #category : #adding }
WDEEntityBasedLevel >> addEntity: anEntity [
	entities add: anEntity.
	anEntity parent: self.
	editorScene ifNotNil: [anEntity addedToScene: editorScene].
	self addedOrRemovedElement.
]

{ #category : #'as yet unclassified' }
WDEEntityBasedLevel >> addedOrRemovedElement [
	addedOrRemovedElementsBlock value
]

{ #category : #accessing }
WDEEntityBasedLevel >> addedToScene: aScene [
	super addedToScene: aScene.
	entities do: [ :each | each addedToScene: aScene ]
]

{ #category : #accessing }
WDEEntityBasedLevel >> elements [
	^ entities
]

{ #category : #serialization }
WDEEntityBasedLevel >> encodeJsonKeyValues [
	usedMaterials := OrderedCollection new.
	usedMaterialSet := IdentityDictionary new.
	entities do: [ :each | each prepareForSerializationInLevel: self ].
	
	^ {
		#materials . usedMaterials collect: [ :each | each encodeForJSON ].
		#entities . entities collect: [ :each | each encodeForJSON ]
	}
]

{ #category : #accessing }
WDEEntityBasedLevel >> entities [
	^ entities
]

{ #category : #'as yet unclassified' }
WDEEntityBasedLevel >> findVolumeElementsThatIntersectElements: aSetOfElements [
	^ self worldEntity findVolumeElementsThatIntersectElements: aSetOfElements
]

{ #category : #'as yet unclassified' }
WDEEntityBasedLevel >> geometryChanged [
	geometryChangedBlock value
]

{ #category : #'as yet unclassified' }
WDEEntityBasedLevel >> getMaterialWithIndex: materialIndex [
	^ usedMaterials at: materialIndex + 1
]

{ #category : #accessing }
WDEEntityBasedLevel >> globalTransform [
	^ TRSTransform3D identity
]

{ #category : #initialization }
WDEEntityBasedLevel >> initialize [
	super initialize.
	entities := OrderedCollection new.
	invalidSceneElements := IdentitySet new.
	self addEntity: (WDEEntity new className: #worldspawn)
]

{ #category : #serialization }
WDEEntityBasedLevel >> loadFromJson: jsonData [
	usedMaterials := (jsonData at: #materials ifAbsent: [ #() ]) collect: [ :each | WDEMaterialInfo new loadFromJson: each ].
	
	entities := (jsonData at: #entities ifAbsent: [nil]) collect: [ :each |
		WDEEntity new
			loadFromJson: each inLevel: self;
			parent: self
	] as: OrderedCollection.

	self assert: entities first isWorldEntity
]

{ #category : #accessing }
WDEEntityBasedLevel >> rayCastAllAlong: ray [
	| result |
	result := OrderedCollection new.
	entities do: [ :each |
		result addAll: (each rayCastAllAlong: ray)
	].
	result sort: [ :a :b | a key <= b key ].
	^ result
]

{ #category : #'as yet unclassified' }
WDEEntityBasedLevel >> recordElementWithInvalidScene: anElement [
	| changed |
	changed := invalidSceneElements isEmpty.
	invalidSceneElements add: anElement.
	changed ifTrue: [ self geometryChanged ].

]

{ #category : #serialization }
WDEEntityBasedLevel >> recordMaterialInfo: material [
	(material isNil or: [ usedMaterialSet includesKey: material ]) ifTrue: [ ^ self ].
	usedMaterialSet at: material put: usedMaterials size.
	usedMaterials add: material
]

{ #category : #removing }
WDEEntityBasedLevel >> removeEntity: anEntity [
	entities remove: anEntity.
	editorScene ifNotNil: [ 
		anEntity removedFromScene: editorScene
	].
	
]

{ #category : #fileout }
WDEEntityBasedLevel >> saveTo: aFileReference [
	| encodedLevel |
	encodedLevel := self encodeAsJSONString.
	aFileReference writeStreamDo: [ :out | out truncate; nextPutAll: encodedLevel ].
]

{ #category : #'as yet unclassified' }
WDEEntityBasedLevel >> validExtensions [
	^ self class validExtensions
]

{ #category : #'as yet unclassified' }
WDEEntityBasedLevel >> validateScene [
	invalidSceneElements do: [ :each | each validateScene ].
	invalidSceneElements removeAll
]

{ #category : #enumerating }
WDEEntityBasedLevel >> whenAddedOrRemovedElementDo: aBlock [
	addedOrRemovedElementsBlock := aBlock
]

{ #category : #enumerating }
WDEEntityBasedLevel >> whenGeometryChangedDo: aBlock [
	geometryChangedBlock := aBlock
]

{ #category : #'as yet unclassified' }
WDEEntityBasedLevel >> worldEntity [
	^ entities first
]
