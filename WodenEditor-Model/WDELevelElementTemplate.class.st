Class {
	#name : #WDELevelElementTemplate,
	#superclass : #WDEPaletteElement,
	#category : #'WodenEditor-Model-Palette'
}

{ #category : #'as yet unclassified' }
WDELevelElementTemplate >> activateInLevelSession: levelSession [
	levelSession activeLevelElementTemplate: self
]

{ #category : #testing }
WDELevelElementTemplate >> canBePlacedInLevel [
	^ true
]
