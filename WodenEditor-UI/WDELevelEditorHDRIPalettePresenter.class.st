Class {
	#name : 'WDELevelEditorHDRIPalettePresenter',
	#superclass : 'WDELevelEditorPalettePresenter',
	#category : 'WodenEditor-UI-Spec',
	#package : 'WodenEditor-UI',
	#tag : 'Spec'
}

{ #category : 'as yet unclassified' }
WDELevelEditorHDRIPalettePresenter >> fetchTopLevelPaletteCategories [
	^ self model topLevelHDRIPaletteCategories
]
