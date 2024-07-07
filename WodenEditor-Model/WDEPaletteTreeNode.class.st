Class {
	#name : 'WDEPaletteTreeNode',
	#superclass : 'Object',
	#category : 'WodenEditor-Model-Palette',
	#package : 'WodenEditor-Model',
	#tag : 'Palette'
}

{ #category : 'as yet unclassified' }
WDEPaletteTreeNode >> activateInLevelSession: levelSession [
	"This gives an opportunity to apply the palette element to the selected elements."
]

{ #category : 'testing' }
WDEPaletteTreeNode >> canBePlacedInLevel [
	^ false
]

{ #category : 'accessing' }
WDEPaletteTreeNode >> name [
	^ self subclassResponsibility
]

{ #category : 'accessing' }
WDEPaletteTreeNode >> thumbnailFor: levelEditorSession [
	^ nil
]
