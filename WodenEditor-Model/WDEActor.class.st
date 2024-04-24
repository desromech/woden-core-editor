"
I am an actor from the Woden Game Framework.
"
Class {
	#name : #WDEActor,
	#superclass : #WDModelingGroup,
	#instVars : [
		'className'
	],
	#category : #'WodenEditor-Model-Level'
}

{ #category : #serialization }
WDEActor class >> jsonObjectTypeName [
	^ self name withoutPrefix: 'WDE'
]

{ #category : #accessing }
WDEActor >> className [

	^ className
]

{ #category : #accessing }
WDEActor >> className: anObject [

	className := anObject
]
