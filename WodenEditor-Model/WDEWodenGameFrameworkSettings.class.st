Class {
	#name : #WDEWodenGameFrameworkSettings,
	#superclass : #WDEGameSettings,
	#category : #'WodenEditor-Model-GameSettings'
}

{ #category : #'as yet unclassified' }
WDEWodenGameFrameworkSettings >> emptyLevel [
	^ WDEWodenGameFrameworkWorldLevel empty
]

{ #category : #accessing }
WDEWodenGameFrameworkSettings >> name [
	^ 'Woden Game Framework'
]
