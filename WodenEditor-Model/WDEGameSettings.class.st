Class {
	#name : #WDEGameSettings,
	#superclass : #Object,
	#traits : 'TWDMModelingMaterialInfoResolver',
	#classTraits : 'TWDMModelingMaterialInfoResolver classTrait',
	#category : #'WodenEditor-Model-GameSettings'
}

{ #category : #testing }
WDEGameSettings class >> allSettings [
	^ self withAllSubclasses
		reject: [ :each | each isAbstract  ]
		thenCollect: [ :each | each new ]
]

{ #category : #accessing }
WDEGameSettings class >> default [
	^ WDEWodenGameFrameworkSettings new
]

{ #category : #testing }
WDEGameSettings class >> isAbstract [
	^ self == WDEGameSettings
]

{ #category : #'path finding' }
WDEGameSettings >> assetsFolders [
	^ #()
]

{ #category : #'path finding' }
WDEGameSettings >> emptyLevel [
	self subclassResponsibility
]

{ #category : #'path finding' }
WDEGameSettings >> loadFromFileReference: aFileReference [
	self subclassResponsibility
]

{ #category : #accessing }
WDEGameSettings >> name [
	self subclassResponsibility
]

{ #category : #'path finding' }
WDEGameSettings >> playLevelWithFileName: fileName [
	self inform: 'TODO: playMapWithFileName ' , fileName
]

{ #category : #palette }
WDEGameSettings >> topLevelElementTemplateCategories [
	^ #()
]

{ #category : #palette }
WDEGameSettings >> topLevelLightSourcePaletteCategories [
	^ #()
]

{ #category : #palette }
WDEGameSettings >> topMaterialPaletteCategories [
	^ #()
]

{ #category : #'path finding' }
WDEGameSettings >> validExtensions [
	^ self subclassResponsibility
]
