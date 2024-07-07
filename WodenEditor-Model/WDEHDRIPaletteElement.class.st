Class {
	#name : 'WDEHDRIPaletteElement',
	#superclass : 'WDEPaletteElement',
	#instVars : [
		'hdri'
	],
	#category : 'WodenEditor-Model-Palette',
	#package : 'WodenEditor-Model',
	#tag : 'Palette'
}

{ #category : 'accessing' }
WDEHDRIPaletteElement class >> path: path [
	^ self new hdri: path; yourself
]

{ #category : 'as yet unclassified' }
WDEHDRIPaletteElement >> activateInLevelSession: levelSession [
	| memento |
	memento := levelSession level modelingTree hdri.
	levelSession doWith: [
		levelSession level modelingTree hdri: hdri
	] undoWith: [
		levelSession level modelingTree hdri: memento
	].


]

{ #category : 'accessing' }
WDEHDRIPaletteElement >> hdri [

	^ hdri
]

{ #category : 'accessing' }
WDEHDRIPaletteElement >> hdri: anObject [

	hdri := anObject
]
