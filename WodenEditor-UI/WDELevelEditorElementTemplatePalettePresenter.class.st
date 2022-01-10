Class {
	#name : #WDELevelEditorElementTemplatePalettePresenter,
	#superclass : #WDELevelEditorPalettePresenter,
	#category : #'WodenEditor-UI-Spec'
}

{ #category : #'as yet unclassified' }
WDELevelEditorElementTemplatePalettePresenter >> fetchTopLevelPaletteCategories [
	^ self model topLevelElementTemplateCategories
]

{ #category : #initialization }
WDELevelEditorElementTemplatePalettePresenter >> setSelectedPaletteElement: paletteElement [
	self model activeLevelElementTemplate: paletteElement
]
