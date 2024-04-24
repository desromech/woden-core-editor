Class {
	#name : #WDEWodenGameFrameworkWorldLevel,
	#superclass : #WDELevel,
	#instVars : [
		'world'
	],
	#category : #'WodenEditor-Model-Level'
}

{ #category : #requirements }
WDEWodenGameFrameworkWorldLevel class >> empty [
	^ self new
		world: WDGFWorld new;
		yourself
]

{ #category : #'as yet unclassified' }
WDEWodenGameFrameworkWorldLevel class >> validExtensions [
	^ #(wgfworld)
]

{ #category : #'as yet unclassified' }
WDEWodenGameFrameworkWorldLevel >> activeGroup [
	^ self modelingTree children first
]

{ #category : #'as yet unclassified' }
WDEWodenGameFrameworkWorldLevel >> activeGroupForInstantiating: aPrototype [
	(aPrototype isKindOf: WDEActor) ifTrue: [ ^ modelingTree ].
	^ self activeGroup
]

{ #category : #initialization }
WDEWodenGameFrameworkWorldLevel >> initialize [
	super initialize.
	modelingTree add: (WDEActor new name: 'LevelStatic'; className: WDGFActor jsonObjectTypeName; yourself).
	
]

{ #category : #'as yet unclassified' }
WDEWodenGameFrameworkWorldLevel >> validExtensions [
	^ self class validExtensions
]

{ #category : #accessing }
WDEWodenGameFrameworkWorldLevel >> world [

	^ world
]

{ #category : #accessing }
WDEWodenGameFrameworkWorldLevel >> world: anObject [

	world := anObject
]
