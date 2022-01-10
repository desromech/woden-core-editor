Class {
	#name : #WDEGameSettings,
	#superclass : #Object,
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
