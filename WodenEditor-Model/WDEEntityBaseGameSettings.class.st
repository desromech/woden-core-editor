Class {
	#name : #WDEEntityBaseGameSettings,
	#superclass : #WDEGameSettings,
	#category : #'WodenEditor-Model-GameSettings'
}

{ #category : #palette }
WDEEntityBaseGameSettings >> basicEntityTemplates [
	^ WDELevelGenericElementTemplateProvider new basicEntities
]

{ #category : #'as yet unclassified' }
WDEEntityBaseGameSettings >> emptyLevel [
	^ WDEEntityBasedLevel new
]

{ #category : #'as yet unclassified' }
WDEEntityBaseGameSettings >> loadFromFileReference: aFileReference [
	^ WDEEntityBasedLevel loadFromJsonString: aFileReference contents
]

{ #category : #accessing }
WDEEntityBaseGameSettings >> name [
	^ 'Entity Based Game (Quake Style)'
]

{ #category : #palette }
WDEEntityBaseGameSettings >> topLevelElementTemplateCategories [
	^ super topLevelElementTemplateCategories , {self basicEntityTemplates}
]

{ #category : #'as yet unclassified' }
WDEEntityBaseGameSettings >> validExtensions [
	^ WDEEntityBasedLevel validExtensions
]
