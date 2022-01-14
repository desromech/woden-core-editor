Class {
	#name : #WDEEntityBaseGameSettings,
	#superclass : #WDEGameSettings,
	#category : #'WodenEditor-Model-GameSettings'
}

{ #category : #'as yet unclassified' }
WDEEntityBaseGameSettings >> emptyLevel [
	^ WDEEntityBasedLevel new
]

{ #category : #'as yet unclassified' }
WDEEntityBaseGameSettings >> loadFromFileReference: aFileReference [
	^ WDEEntityBasedLevel loadFromJsonString: aFileReference contents
]

{ #category : #accessing }
WDEEntityBaseGameSettings >> name [
	^ 'Entity Based Game (Quake Style)'
]

{ #category : #'as yet unclassified' }
WDEEntityBaseGameSettings >> validExtensions [
	^ WDEEntityBasedLevel validExtensions
]
