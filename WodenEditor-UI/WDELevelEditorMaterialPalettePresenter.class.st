Class {
	#name : 'WDELevelEditorMaterialPalettePresenter',
	#superclass : 'WDELevelEditorPalettePresenter',
	#category : 'WodenEditor-UI-Spec',
	#package : 'WodenEditor-UI',
	#tag : 'Spec'
}

{ #category : 'as yet unclassified' }
WDELevelEditorMaterialPalettePresenter >> fetchTopLevelPaletteCategories [
	^ self model topLevelMaterialPaletteCategories
]
