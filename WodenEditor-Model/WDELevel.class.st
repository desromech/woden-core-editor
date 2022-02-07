"
I provide an abstract interface for connecting the level editor with an actual game specific level model.
"
Class {
	#name : #WDELevel,
	#superclass : #Object,
	#instVars : [
		'gameSettings',
		'modelingTree'
	],
	#category : #'WodenEditor-Model-Level'
}

{ #category : #'as yet unclassified' }
WDELevel >> activeGroup [
	^ self modelingTree
]

{ #category : #accessing }
WDELevel >> gameSettings [

	^ gameSettings
]

{ #category : #accessing }
WDELevel >> gameSettings: anObject [

	gameSettings := anObject
]

{ #category : #initialization }
WDELevel >> initialize [
	super initialize.
	modelingTree := WDModelingTree new.
]

{ #category : #accessing }
WDELevel >> level [
	^ self
]

{ #category : #accessing }
WDELevel >> modelingTree [
	^ modelingTree
]

{ #category : #'instance creation' }
WDELevel >> newEditorSession [
	^ WDELevelEditorSession new
		gameSettings: (gameSettings ifNil: [WDEGameSettings default]);
		level: self;
		yourself
]

{ #category : #'as yet unclassified' }
WDELevel >> rayCastAllAlong: ray [
	| picker |
	picker := WDMRayPicker ray: ray.
	modelingTree rayPickElements: picker.
	^ picker sortedDistancesWithResults
]

{ #category : #'as yet unclassified' }
WDELevel >> validExtensions [
	self subclassResponsibility
]

{ #category : #hooks }
WDELevel >> whenAddedOrRemovedElementDo: aBlock [
	modelingTree whenAddedOrRemovedElementDo: aBlock
]
