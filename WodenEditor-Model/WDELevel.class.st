"
I provide an abstract interface for connecting the level editor with an actual game specific level model.
"
Class {
	#name : #WDELevel,
	#superclass : #WDELevelElement,
	#instVars : [
		'gameSettings',
		'editorScene'
	],
	#category : #'WodenEditor-Model-Level'
}

{ #category : #accessing }
WDELevel >> addedToScene: aScene [
	self assert: editorScene isNil.
	editorScene := aScene.
]

{ #category : #'as yet unclassified' }
WDELevel >> children [
	^ self elements
]

{ #category : #accessing }
WDELevel >> editorScene [

	^ editorScene
]

{ #category : #accessing }
WDELevel >> editorScene: anObject [

	editorScene := anObject
]

{ #category : #accessing }
WDELevel >> elements [
	^ self subclassResponsibility
]

{ #category : #'as yet unclassified' }
WDELevel >> findVolumeElementsThatIntersectElements: aSetOfElements [
	^ #()
]

{ #category : #accessing }
WDELevel >> gameSettings [

	^ gameSettings
]

{ #category : #accessing }
WDELevel >> gameSettings: anObject [

	gameSettings := anObject
]

{ #category : #accessing }
WDELevel >> level [
	^ self
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
	^ #()
]

{ #category : #accessing }
WDELevel >> removedFromScene: aScene [
	"Added the level onto the specified scene"
	editorScene := nil.
]

{ #category : #accessing }
WDELevel >> scene [
	^ nil
]

{ #category : #'as yet unclassified' }
WDELevel >> treeDisplayName [
	^ 'Level'
]

{ #category : #'as yet unclassified' }
WDELevel >> validExtensions [
	self subclassResponsibility
]

{ #category : #'as yet unclassified' }
WDELevel >> visible [
	^ true
]

{ #category : #'as yet unclassified' }
WDELevel >> visible: aBoolean [
]

{ #category : #hooks }
WDELevel >> whenAddedOrRemovedElementDo: aBlock [
]

{ #category : #hooks }
WDELevel >> whenGeometryChangedDo: aBlock [
]
