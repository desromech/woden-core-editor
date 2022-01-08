"
I provide an abstract interface for connecting the level editor with an actual game specific level model.
"
Class {
	#name : #WDELevel,
	#superclass : #Object,
	#instVars : [
		'gameSettings'
	],
	#category : #'WodenEditor-Model-Level'
}

{ #category : #requirements }
WDELevel class >> empty [
	^ WDEWodenGameFrameworkWorldLevel new
		world: WDGFWorld new;
		yourself
]

{ #category : #'as yet unclassified' }
WDELevel >> editorTreeChildren [
	^ self elements
]

{ #category : #'as yet unclassified' }
WDELevel >> editorTreeDisplayName [
	^ 'Level'
]

{ #category : #accessing }
WDELevel >> elements [
	^ self subclassResponsibility
]

{ #category : #accessing }
WDELevel >> gameSettings [

	^ gameSettings
]

{ #category : #accessing }
WDELevel >> gameSettings: anObject [

	gameSettings := anObject
]

{ #category : #'instance creation' }
WDELevel >> newEditorSession [
	^ WDELevelEditorSession new level: self; yourself
]

{ #category : #'as yet unclassified' }
WDELevel >> rayCastAllAlong: ray [
	^ #()
]

{ #category : #accessing }
WDELevel >> scene [
	^ nil
]

{ #category : #'as yet unclassified' }
WDELevel >> visibleInEditor [
	^ true
]

{ #category : #'as yet unclassified' }
WDELevel >> visibleInEditor: aBoolean [
]

{ #category : #hooks }
WDELevel >> whenAddedOrRemovedElementDo: aBlock [
]
