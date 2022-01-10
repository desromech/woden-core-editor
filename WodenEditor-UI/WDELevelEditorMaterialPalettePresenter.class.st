Class {
	#name : #WDELevelEditorMaterialPalettePresenter,
	#superclass : #WDELevelEditorPalettePresenter,
	#category : #'WodenEditor-UI-Spec'
}

{ #category : #'as yet unclassified' }
WDELevelEditorMaterialPalettePresenter >> fetchTopLevelPaletteCategories [
	^ self model topMaterialPaletteCategories
]
