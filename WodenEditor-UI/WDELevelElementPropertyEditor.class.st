Class {
	#name : 'WDELevelElementPropertyEditor',
	#superclass : 'SpPresenterWithModel',
	#instVars : [
		'treeView',
		'propertiesNotebook'
	],
	#category : 'WodenEditor-UI-Spec',
	#package : 'WodenEditor-UI',
	#tag : 'Spec'
}

{ #category : 'specs' }
WDELevelElementPropertyEditor class >> defaultLayout [
	^ SpBoxLayout newVertical
		add: #propertiesNotebook;
		yourself
]

{ #category : 'initialization' }
WDELevelElementPropertyEditor >> initializePresenters [
	propertiesNotebook := self newNotebook.
]

{ #category : 'initialization' }
WDELevelElementPropertyEditor >> modelChanged [
	propertiesNotebook removeAll.
	self propertyPages do: [ :each |
		propertiesNotebook addPageTitle: each title provider: [ WDMPropertyPagePresenter on: each].
	].

	propertiesNotebook pages ifNotEmpty: [
		propertiesNotebook selectPageIndex: 1
	]
]

{ #category : 'as yet unclassified' }
WDELevelElementPropertyEditor >> propertiesNotebook [
	^ propertiesNotebook
]

{ #category : 'as yet unclassified' }
WDELevelElementPropertyEditor >> propertyPages [
	^ (self model
		ifNil: [#()]
		ifNotNil: [ :model | model propertyPages ])
		sorted: [ :a :b | a title <= b title ]
]
