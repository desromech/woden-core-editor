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

{ #category : #accessing }
WDEWodenGameFrameworkWorldLevel >> elements [
	^ world actors
]

{ #category : #accessing }
WDEWodenGameFrameworkWorldLevel >> scene [
	^ (world getOrCreateSubsystemWithClass: WDGFSceneSubsystem) scene
]

{ #category : #'as yet unclassified' }
WDEWodenGameFrameworkWorldLevel >> treeDisplayName [
	^ world treeDisplayName
]

{ #category : #accessing }
WDEWodenGameFrameworkWorldLevel >> world [

	^ world
]

{ #category : #accessing }
WDEWodenGameFrameworkWorldLevel >> world: anObject [

	world := anObject
]
