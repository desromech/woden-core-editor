Class {
	#name : #WDEMaterialInfo,
	#superclass : #WDELevelElement,
	#instVars : [
		'index',
		'definition',
		'fileReference',
		'material'
	],
	#category : #'WodenEditor-Model-Level'
}

{ #category : #comparing }
WDEMaterialInfo >> = other [
	^ self class == other class and: [ fileReference = other fileReference and: [ definition = other definition ] ]
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
	fileReference ifNotNil: [ ^ { #path . fileReference fullPath fullName } ].
	definition ifNotNil: [ ^ definition encodeJsonKeyValues ].	
	^ #()
]

{ #category : #accessing }
WDEMaterialInfo >> fileReference [

	^ fileReference
]

{ #category : #accessing }
WDEMaterialInfo >> fileReference: anObject [

	fileReference := anObject
]

{ #category : #comparing }
WDEMaterialInfo >> hash [
	^ self class identityHash class bitXor: (fileReference hash bitXor: definition hash)
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
		fileReference := found asFileReference.
		^ self
	].

	jsonData at: #type ifPresent: [ :found |
		definition := WDMaterial loadFromJson: jsonData.
		^ self
	].
]

{ #category : #'as yet unclassified' }
WDEMaterialInfo >> makeThumbnail [
	^ self validMaterial ifNotNil: [ :mat | mat makeThumbnail ]
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
WDEMaterialInfo >> validMaterial [
	definition ifNotNil: [ ^ definition ].
	^ nil
]
