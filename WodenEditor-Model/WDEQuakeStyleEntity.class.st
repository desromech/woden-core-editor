"
I am an entity in a quake style level.
"
Class {
	#name : #WDEQuakeStyleEntity,
	#superclass : #WDEQuakeStyleLevelElement,
	#instVars : [
		'className',
		'brushes'
	],
	#category : #'WodenEditor-Model-Level'
}

{ #category : #accessing }
WDEQuakeStyleEntity >> className [
	^ className
]

{ #category : #accessing }
WDEQuakeStyleEntity >> className: anObject [

	className := anObject
]

{ #category : #'as yet unclassified' }
WDEQuakeStyleEntity >> editorTreeChildren [
	^ brushes
]

{ #category : #'as yet unclassified' }
WDEQuakeStyleEntity >> editorTreeDisplayName [
	^ className asString
]

{ #category : #initialization }
WDEQuakeStyleEntity >> initialize [
	super initialize.
	brushes := OrderedCollection new.
]
