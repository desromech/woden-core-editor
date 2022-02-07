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
	^ WDEWodenGameFrameworkWorldLevel new
		world: WDGFWorld new;
		yourself
]
