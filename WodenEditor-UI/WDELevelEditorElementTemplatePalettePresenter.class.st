Class {
	#name : 'WDELevelEditorElementTemplatePalettePresenter',
	#superclass : 'WDELevelEditorPalettePresenter',
	#category : 'WodenEditor-UI-Spec',
	#package : 'WodenEditor-UI',
	#tag : 'Spec'
}

{ #category : 'as yet unclassified' }
WDELevelEditorElementTemplatePalettePresenter >> fetchTopLevelPaletteCategories [
	^ self model topLevelElementTemplateCategories
]

{ #category : 'initialization' }
WDELevelEditorElementTemplatePalettePresenter >> setSelectedPaletteElement: paletteElement [
	self model activeLevelElementTemplate: paletteElement
]
