Class {
	#name : #WDEWodenGameFrameworkSettings,
	#superclass : #WDEGameSettings,
	#category : #'WodenEditor-Model-GameSettings'
}

{ #category : #palette }
WDEWodenGameFrameworkSettings >> actorCategories [
	| category actorClassesWithPaths |
	category := WDEPaletteCategory new
			name: 'Actor Classes'.
			
	actorClassesWithPaths := OrderedCollection new.
	WDGFActor withAllSubclassesDo: [ :eachClass |
		eachClass isAbstract ifFalse: [ 
			actorClassesWithPaths add: {eachClass editorCategoryPath . eachClass editorName}
		]
	].

	actorClassesWithPaths sort: [:a :b | a first = b first
			ifTrue: [a second <= b second]
			ifFalse: [ a first <= b second ]
	].
	
	actorClassesWithPaths do: [ :pathWithClassName |
		| subcategory actorPrototype |
		subcategory := category getOrCreateSubcategoryWithPath: pathWithClassName first asFileReference path segments.
		actorPrototype := WDEActor new className: pathWithClassName second; yourself.
		subcategory addTemplate: (WDELevelElementPrototypeTemplate new
			name: actorPrototype className;
			prototype: actorPrototype;
			yourself)
	].
			
	^ { category }
]

{ #category : #accessing }
WDEWodenGameFrameworkSettings >> applicationSettings [
	^	WDGFApplicationSettings

]

{ #category : #'path finding' }
WDEWodenGameFrameworkSettings >> assetsFolders [
	^ self applicationSettings asApplicationSettings assetsLocations
]

{ #category : #palette }
WDEWodenGameFrameworkSettings >> constructPaletteForActorClass: actorClass inCategory: category [
]

{ #category : #constructing }
WDEWodenGameFrameworkSettings >> emptyLevel [
	^ WDEWodenGameFrameworkWorldLevel empty
]

{ #category : #'path finding' }
WDEWodenGameFrameworkSettings >> loadFromFileReference: aFileReference [
	^ WDEWodenGameFrameworkWorldLevel loadFromJsonString: aFileReference contents
]

{ #category : #accessing }
WDEWodenGameFrameworkSettings >> name [
	^ 'Woden Game Framework'
]

{ #category : #palette }
WDEWodenGameFrameworkSettings >> topLevelElementTemplateCategories [
	^ super topLevelElementTemplateCategories , self actorCategories
]

{ #category : #'path finding' }
WDEWodenGameFrameworkSettings >> validExtensions [
	^ WDEWodenGameFrameworkWorldLevel validExtensions
]
