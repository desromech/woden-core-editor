"
I am an entity in a quake style level.
"
Class {
	#name : #WDEEntity,
	#superclass : #WDELevelElement,
	#instVars : [
		'className',
		'brushes',
		'transform'
	],
	#category : #'WodenEditor-Model-Level'
}

{ #category : #adding }
WDEEntity >> addBrush: aBrush [
	brushes add: aBrush
]

{ #category : #accessing }
WDEEntity >> className [
	^ className
]

{ #category : #accessing }
WDEEntity >> className: anObject [

	className := anObject
]

{ #category : #'as yet unclassified' }
WDEEntity >> editorTreeChildren [
	^ brushes
]

{ #category : #'as yet unclassified' }
WDEEntity >> editorTreeDisplayName [
	^ className asString
]

{ #category : #initialization }
WDEEntity >> initialize [
	super initialize.
	brushes := OrderedCollection new.
	transform := TRSTransform3D identity.
]

{ #category : #testing }
WDEEntity >> isWorldEntity [
	^ #(worldspawn world) includes: className
]

{ #category : #accessing }
WDEEntity >> transform [

	^ transform
]

{ #category : #accessing }
WDEEntity >> transform: anObject [

	transform := anObject
]
