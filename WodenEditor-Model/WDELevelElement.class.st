"
I represent a quake style level element.
"
Class {
	#name : #WDELevelElement,
	#superclass : #Object,
	#instVars : [
		'visibleInEditor',
		'parent'
	],
	#classVars : [
		'Epsilon'
	],
	#category : #'WodenEditor-Model-Level'
}

{ #category : #initialization }
WDELevelElement class >> initialize [
	Epsilon := 0.00001.
]

{ #category : #accessing }
WDELevelElement >> addedToScene: aScene [
]

{ #category : #'constructive solid geometry' }
WDELevelElement >> canBeSubtracted [
	^ false
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

{ #category : #'as yet unclassified' }
WDELevelElement >> instantiateForPlacingInLevel: level box: placementBox [
	self subclassResponsibility
]

{ #category : #'as yet unclassified' }
WDELevelElement >> instantiateForPlacingInLevel: level point: placementPoint [
	self subclassResponsibility
]

{ #category : #testing }
WDELevelElement >> isManipulableInEditorSceneView [
	^ false
]

{ #category : #accessing }
WDELevelElement >> level [
	^ parent ifNotNil: [ parent level ]
]

{ #category : #memento }
WDELevelElement >> materialStateMemento [
	^ nil
]

{ #category : #accessing }
WDELevelElement >> parent [

	^ parent
]

{ #category : #accessing }
WDELevelElement >> parent: anObject [

	parent := anObject
]

{ #category : #accessing }
WDELevelElement >> rayCastAllAlong: ray [
	^ #()
]

{ #category : #removing }
WDELevelElement >> removeFromParent [
]

{ #category : #accessing }
WDELevelElement >> removeFromScene: aScene [
]

{ #category : #memento }
WDELevelElement >> restoreMaterialStateMemento: memento [
]

{ #category : #initialization }
WDELevelElement >> setMaterialRecursively: newMaterial [
]

{ #category : #'constructive solid geometry' }
WDELevelElement >> subtract: otherElement withTransform: otherElementTransform [
	^ { self }
]

{ #category : #accessing }
WDELevelElement >> visibleInEditor [

	^ visibleInEditor
]

{ #category : #accessing }
WDELevelElement >> visibleInEditor: anObject [

	visibleInEditor := anObject
]
