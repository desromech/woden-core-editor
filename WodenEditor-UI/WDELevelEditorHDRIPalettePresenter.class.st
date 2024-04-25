Class {
	#name : #WDELevelEditorHDRIPalettePresenter,
	#superclass : #WDELevelEditorPalettePresenter,
	#category : #'WodenEditor-UI-Spec'
}

{ #category : #'as yet unclassified' }
WDELevelEditorHDRIPalettePresenter >> fetchTopLevelPaletteCategories [
	^ self model topLevelHDRIPaletteCategories
]
