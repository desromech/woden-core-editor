"
I contain a quake style level.
"
Class {
	#name : #WDEEntityBasedLevel,
	#superclass : #WDELevel,
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

{ #category : #'as yet unclassified' }
WDEEntityBasedLevel >> activeGroup [
	^ self modelingTree children first
]

{ #category : #'as yet unclassified' }
WDEEntityBasedLevel >> activeGroupForInstantiating: aPrototype [
	(aPrototype isKindOf: WDEEntity) ifTrue: [ ^ modelingTree ].
	^ self activeGroup
]

{ #category : #initialization }
WDEEntityBasedLevel >> initialize [
	super initialize.
	modelingTree add: (WDEEntity new className: #worldspawn)
]

{ #category : #serialization }
WDEEntityBasedLevel >> loadFromJson: jsonData [
	modelingTree := WDModelingTree new.
	modelingTree loadFromJson: jsonData
]

{ #category : #'as yet unclassified' }
WDEEntityBasedLevel >> validExtensions [
	^ self class validExtensions
]
