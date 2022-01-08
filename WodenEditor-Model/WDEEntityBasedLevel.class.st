"
I contain a quake style level.
"
Class {
	#name : #WDEEntityBasedLevel,
	#superclass : #WDELevel,
	#instVars : [
		'entities'
	],
	#category : #'WodenEditor-Model-Level'
}

{ #category : #adding }
WDEEntityBasedLevel >> addEntity: anEntity [
	entities add: anEntity
]

{ #category : #accessing }
WDEEntityBasedLevel >> elements [
	^ entities
]

{ #category : #accessing }
WDEEntityBasedLevel >> entities [
	^ entities
]

{ #category : #initialization }
WDEEntityBasedLevel >> initialize [
	super initialize.
	entities := OrderedCollection new.
	entities add: (WDEEntity new className: #worlspawn)
]

{ #category : #accessing }
WDEEntityBasedLevel >> rayCastAllAlong: ray [
	| result |
	result := OrderedCollection new.
	entities do: [ :each |
		result addAll: (each rayCastAllAlong: ray)
	].
	result sort: [ :a :b | a key <= b key ].
	^ result
]

{ #category : #'as yet unclassified' }
WDEEntityBasedLevel >> worldEntity [
	^ entities first
]
