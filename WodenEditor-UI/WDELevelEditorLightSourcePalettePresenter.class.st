Class {
	#name : #WDELevelEditorLightSourcePalettePresenter,
	#superclass : #WDELevelEditorPalettePresenter,
	#category : #'WodenEditor-UI-Spec'
}

{ #category : #'as yet unclassified' }
WDELevelEditorLightSourcePalettePresenter >> fetchTopLevelPaletteCategories [
	^ self model topLevelLightSourcePaletteCategories
]
