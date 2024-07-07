Class {
	#name : 'WDEEntityBaseGameSettings',
	#superclass : 'WDEGameSettings',
	#category : 'WodenEditor-Model-GameSettings',
	#package : 'WodenEditor-Model',
	#tag : 'GameSettings'
}

{ #category : 'testing' }
WDEEntityBaseGameSettings class >> isAbstract [
	^ self == WDEEntityBaseGameSettings
]

{ #category : 'palette' }
WDEEntityBaseGameSettings >> basicEntityTemplates [
	^ WDELevelGenericElementTemplateProvider new basicEntities
]

{ #category : 'path finding' }
WDEEntityBaseGameSettings >> emptyLevel [
	^ WDEEntityBasedLevel new
]

{ #category : 'path finding' }
WDEEntityBaseGameSettings >> loadFromFileReference: aFileReference [
	^ WDEEntityBasedLevel loadFromJsonString: aFileReference contents
]

{ #category : 'accessing' }
WDEEntityBaseGameSettings >> name [
	^ 'Entity Based Game (Quake Style)'
]

{ #category : 'palette' }
WDEEntityBaseGameSettings >> topLevelElementTemplateCategories [
	^ super topLevelElementTemplateCategories , {self basicEntityTemplates}
]

{ #category : 'path finding' }
WDEEntityBaseGameSettings >> validExtensions [
	^ WDEEntityBasedLevel validExtensions
]
