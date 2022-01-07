"
I represent a quake style level element.
"
Class {
	#name : #WDEQuakeStyleLevelElement,
	#superclass : #Object,
	#instVars : [
		'visibleInEditor'
	],
	#category : #'WodenEditor-Model-Level'
}

{ #category : #initialization }
WDEQuakeStyleLevelElement >> initialize [
	super initialize.
	visibleInEditor := true.
]

{ #category : #accessing }
WDEQuakeStyleLevelElement >> visibleInEditor [

	^ visibleInEditor
]

{ #category : #accessing }
WDEQuakeStyleLevelElement >> visibleInEditor: anObject [

	visibleInEditor := anObject
]
