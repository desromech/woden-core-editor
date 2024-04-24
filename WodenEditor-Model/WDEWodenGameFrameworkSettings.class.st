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

{ #category : #palette }
WDEWodenGameFrameworkSettings >> constructPaletteForActorClass: actorClass inCategory: category [
]

{ #category : #constructing }
WDEWodenGameFrameworkSettings >> emptyLevel [
	^ WDEWodenGameFrameworkWorldLevel empty
]

{ #category : #accessing }
WDEWodenGameFrameworkSettings >> name [
	^ 'Woden Game Framework'
]

{ #category : #palette }
WDEWodenGameFrameworkSettings >> topLevelElementTemplateCategories [
	^ super topLevelElementTemplateCategories , self actorCategories
]
