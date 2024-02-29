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
