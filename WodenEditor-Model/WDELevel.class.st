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

{ #category : #'as yet unclassified' }
WDELevel >> elementsInFrustum: frustum [
	^ modelingTree findVolumeElementsThatIntersectFrustum: frustum
]

{ #category : #accessing }
WDELevel >> gameSettings [

	^ gameSettings
]

{ #category : #accessing }
WDELevel >> gameSettings: anObject [
	gameSettings := anObject.
	modelingTree ifNotNil: [ modelingTree materialResolver: gameSettings ]
	
]

{ #category : #initialization }
WDELevel >> initialize [
	super initialize.
	modelingTree := WDModelingTree new.
	modelingTree materialResolver: gameSettings.
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
WDELevel >> rayPickElement: ray mode: modelingEditionMode [
	| picker |
	picker := WDMFirstRayPicker ray: ray editionMode: modelingEditionMode.
	modelingTree rayPickElements: picker.
	^ picker result
]

{ #category : #'as yet unclassified' }
WDELevel >> rayPickElements: ray mode: modelingEditionMode [
	| picker |
	picker := WDMRayPicker ray: ray editionMode: modelingEditionMode.
	modelingTree rayPickElements: picker.
	^ picker sortedDistancesWithResults
]

{ #category : #fileout }
WDELevel >> saveTo: aFileReference [
	| encodedLevel |
	encodedLevel := modelingTree encodeAsJSONString.
	aFileReference writeStreamDo: [ :out | out truncate; nextPutAll: encodedLevel ].
]

{ #category : #'as yet unclassified' }
WDELevel >> validExtensions [
	self subclassResponsibility
]

{ #category : #hooks }
WDELevel >> whenAddedOrRemovedElementDo: aBlock [
	modelingTree whenAddedOrRemovedElementDo: aBlock
]
