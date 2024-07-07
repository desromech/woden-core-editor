Class {
	#name : 'WDEWodenGameFrameworkWorldLevel',
	#superclass : 'WDELevel',
	#category : 'WodenEditor-Model-Level',
	#package : 'WodenEditor-Model',
	#tag : 'Level'
}

{ #category : 'requirements' }
WDEWodenGameFrameworkWorldLevel class >> empty [
	^ self new
]

{ #category : 'as yet unclassified' }
WDEWodenGameFrameworkWorldLevel class >> validExtensions [
	^ #(wgfworld)
]

{ #category : 'as yet unclassified' }
WDEWodenGameFrameworkWorldLevel >> activeGroup [
	^ self modelingTree children first
]

{ #category : 'as yet unclassified' }
WDEWodenGameFrameworkWorldLevel >> activeGroupForInstantiating: aPrototype [
	(aPrototype isKindOf: WDEActor) ifTrue: [ ^ modelingTree ].
	^ self activeGroup
]

{ #category : 'initialization' }
WDEWodenGameFrameworkWorldLevel >> initialize [
	super initialize.
	modelingTree add: (WDEActor new className: WDGFStaticActor jsonObjectTypeName; yourself).
	
]

{ #category : 'as yet unclassified' }
WDEWodenGameFrameworkWorldLevel >> validExtensions [
	^ self class validExtensions
]
