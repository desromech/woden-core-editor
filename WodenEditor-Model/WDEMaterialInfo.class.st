Class {
	#name : #WDEMaterialInfo,
	#superclass : #WDELevelElement,
	#instVars : [
		'index',
		'definition',
		'path',
		'material'
	],
	#category : #'WodenEditor-Model-Level'
}

{ #category : #comparing }
WDEMaterialInfo >> = other [
	^ self class == other class and: [ path = other path and: [ definition = other definition ] ]
]

{ #category : #converting }
WDEMaterialInfo >> asWDEMaterialInfo [
	^ self
]

{ #category : #accessing }
WDEMaterialInfo >> definition [

	^ definition
]

{ #category : #accessing }
WDEMaterialInfo >> definition: anObject [

	definition := anObject
]

{ #category : #accessing }
WDEMaterialInfo >> encodeJsonKeyValues [
	path ifNotNil: [ ^ { #path . path } ].
	definition ifNotNil: [ ^ definition encodeJsonKeyValues ].	
	^ #()
]

{ #category : #comparing }
WDEMaterialInfo >> hash [
	^ self class identityHash class bitXor: (path hash bitXor: definition hash)
]

{ #category : #accessing }
WDEMaterialInfo >> index [

	^ index
]

{ #category : #accessing }
WDEMaterialInfo >> index: anObject [

	index := anObject
]

{ #category : #serialization }
WDEMaterialInfo >> loadFromJson: jsonData [
	jsonData at: #path ifPresent: [ :found |
		path := found.
		^ self
	].

	jsonData at: #type ifPresent: [ :found |
		definition := WDMaterial loadFromJson: jsonData.
		^ self
	].
]

{ #category : #accessing }
WDEMaterialInfo >> material [

	^ material
]

{ #category : #accessing }
WDEMaterialInfo >> material: anObject [

	material := anObject
]

{ #category : #accessing }
WDEMaterialInfo >> path [

	^ path
]

{ #category : #accessing }
WDEMaterialInfo >> path: anObject [

	path := anObject
]

{ #category : #'as yet unclassified' }
WDEMaterialInfo >> thumbnailFor: levelEditorSession [
	^ (self validMaterialForGameSettings: levelEditorSession gameSettings) ifNotNil: [ :mat | mat makeThumbnail ]
]

{ #category : #accessing }
WDEMaterialInfo >> validMaterialForGameSettings: gameSettings [
	definition ifNotNil: [ ^ definition ].
	material ifNil: [
		gameSettings ifNotNil: [
			material := gameSettings loadValidMaterialFor: self
		]
	].
	^ material
]
