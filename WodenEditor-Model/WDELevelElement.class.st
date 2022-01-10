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

{ #category : #accessing }
WDELevelElement >> addedToScene: aScene [
]

{ #category : #'as yet unclassified' }
WDELevelElement >> editorTreeChildren [
	^ #()
]

{ #category : #initialization }
WDELevelElement >> initialize [
	super initialize.
	visibleInEditor := true.
]

{ #category : #testing }
WDELevelElement >> isLevelEditorEntity [
	^ false
]

{ #category : #accessing }
WDELevelElement >> rayCastAllAlong: ray [
	^ #()
]

{ #category : #accessing }
WDELevelElement >> removeFromScene: aScene [
]

{ #category : #accessing }
WDELevelElement >> visibleInEditor [

	^ visibleInEditor
]

{ #category : #accessing }
WDELevelElement >> visibleInEditor: anObject [

	visibleInEditor := anObject
]
