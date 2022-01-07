Class {
	#name : #WDEWodenGameFrameworkWorldLevel,
	#superclass : #WDELevel,
	#instVars : [
		'world'
	],
	#category : #'WodenEditor-Model-Level'
}

{ #category : #'as yet unclassified' }
WDEWodenGameFrameworkWorldLevel >> editorTreeDisplayName [
	^ world editorTreeDisplayName
]

{ #category : #accessing }
WDEWodenGameFrameworkWorldLevel >> elements [
	^ world actors
]

{ #category : #accessing }
WDEWodenGameFrameworkWorldLevel >> scene [
	^ (world getOrCreateSubsystemWithClass: WDGFSceneSubsystem) scene
]

{ #category : #accessing }
WDEWodenGameFrameworkWorldLevel >> world [

	^ world
]

{ #category : #accessing }
WDEWodenGameFrameworkWorldLevel >> world: anObject [

	world := anObject
]
