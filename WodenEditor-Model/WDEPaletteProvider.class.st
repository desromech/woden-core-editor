Class {
	#name : 'WDEPaletteProvider',
	#superclass : 'Object',
	#category : 'WodenEditor-Model-Palette',
	#package : 'WodenEditor-Model',
	#tag : 'Palette'
}

{ #category : 'as yet unclassified' }
WDEPaletteProvider class >> allTopLevelPaletteCategories [
	| topLevelTemplateCategories |
	topLevelTemplateCategories := OrderedCollection new.
	self withAllSubclassesDo: [ :each |
		topLevelTemplateCategories addAll: each topLevelPaletteCategories
	].
	^ topLevelTemplateCategories
]

{ #category : 'as yet unclassified' }
WDEPaletteProvider class >> topLevelPaletteCategories [
	^ self new topLevelPaletteCategories
]

{ #category : 'as yet unclassified' }
WDEPaletteProvider >> topLevelPaletteCategories [
	^ #()
]
