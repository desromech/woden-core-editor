"
I contain a quake style level.
"
Class {
	#name : #WDEQuakeStyleLevel,
	#superclass : #WDELevel,
	#instVars : [
		'entities'
	],
	#category : #'WodenEditor-Model-Level'
}

{ #category : #accessing }
WDEQuakeStyleLevel >> elements [
	^ entities
]

{ #category : #initialization }
WDEQuakeStyleLevel >> initialize [
	super initialize.
	entities := OrderedCollection new.
	entities add: (WDEQuakeStyleEntity new className: #worlspawn)
]
