Class {
	#name : 'WDELevelEditorLightSourcePalettePresenter',
	#superclass : 'WDELevelEditorPalettePresenter',
	#category : 'WodenEditor-UI-Spec',
	#package : 'WodenEditor-UI',
	#tag : 'Spec'
}

{ #category : 'as yet unclassified' }
WDELevelEditorLightSourcePalettePresenter >> fetchTopLevelPaletteCategories [
	^ self model topLevelLightSourcePaletteCategories
]
