Class {
	#name : #WDEBrushFace,
	#superclass : #WDELevelElement,
	#instVars : [
		'plane'
	],
	#category : #'WodenEditor-Model-Level'
}

{ #category : #accessing }
WDEBrushFace class >> plane: aPlane [
	^ self new plane: aPlane; yourself
]

{ #category : #'as yet unclassified' }
WDEBrushFace >> editorTreeDisplayName [
	^ 'Face'
]

{ #category : #initialization }
WDEBrushFace >> initialize [
	super initialize.
]

{ #category : #accessing }
WDEBrushFace >> plane [

	^ plane
]

{ #category : #accessing }
WDEBrushFace >> plane: anObject [

	plane := anObject
]
