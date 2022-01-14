"
I contain a quake style level.
"
Class {
	#name : #WDEEntityBasedLevel,
	#superclass : #WDELevel,
	#instVars : [
		'entities',
		'addedOrRemovedElementsBlock',
		'invalidSceneElements'
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

{ #category : #accessing }
WDEEntityBasedLevel >> encodeJsonKeyValues [
	^ {
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
	invalidSceneElements add: anElement
]

{ #category : #removing }
WDEEntityBasedLevel >> removeEntity: anEntity [
	entities remove: anEntity.
	editorScene ifNotNil: [ 
		anEntity removedFromScene: editorScene
	].
	
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

{ #category : #'as yet unclassified' }
WDEEntityBasedLevel >> worldEntity [
	^ entities first
]
