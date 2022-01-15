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
