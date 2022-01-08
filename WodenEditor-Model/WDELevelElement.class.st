"
I represent a quake style level element.
"
Class {
	#name : #WDELevelElement,
	#superclass : #Object,
	#instVars : [
		'visibleInEditor'
	],
	#category : #'WodenEditor-Model-Level'
}

{ #category : #'as yet unclassified' }
WDELevelElement >> editorTreeChildren [
	^ #()
]

{ #category : #initialization }
WDELevelElement >> initialize [
	super initialize.
	visibleInEditor := true.
]

{ #category : #accessing }
WDELevelElement >> rayCastAllAlong: ray [
	^ #()
]

{ #category : #accessing }
WDELevelElement >> visibleInEditor [

	^ visibleInEditor
]

{ #category : #accessing }
WDELevelElement >> visibleInEditor: anObject [

	visibleInEditor := anObject
]
