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
		'EditorColorPalette',
		'EditorColorPaletteLastGeneratedColor',
		'EditorColorPaletteRandomGenerator',
		'Epsilon'
	],
	#category : #'WodenEditor-Model-Level'
}

{ #category : #'as yet unclassified' }
WDELevelElement class >> generateEditorColor [
	| newColor |
	[
		newColor := EditorColorPalette atRandom: EditorColorPaletteRandomGenerator
	] doWhileTrue: [ EditorColorPaletteLastGeneratedColor = newColor ].
	^ (EditorColorPaletteLastGeneratedColor := newColor) asVector4
]

{ #category : #initialization }
WDELevelElement class >> initialize [
	Epsilon := 0.00001.
	EditorColorPalette := Color wheel: 13.
	EditorColorPaletteRandomGenerator := Random seed: 1.
	EditorColorPaletteLastGeneratedColor := nil.
]

{ #category : #accessing }
WDELevelElement >> addedToScene: aScene [
]

{ #category : #'as yet unclassified' }
WDELevelElement >> buildContextMenuForEditorSession: levelSession on: menuPresenter [
]

{ #category : #'constructive solid geometry' }
WDELevelElement >> canBeDuplicatedAndPlaced [
	^ false
]

{ #category : #'constructive solid geometry' }
WDELevelElement >> canBeSubtracted [
	^ false
]

{ #category : #testing }
WDELevelElement >> canBeUsedForVolumeSubtractionInEditor [
	^ false
]

{ #category : #'as yet unclassified' }
WDELevelElement >> editorTreeChildren [
	^ #()
]

{ #category : #'as yet unclassified' }
WDELevelElement >> encodeAsJSONString [
	^ (NeoJSONWriter toStringPretty: self encodeForJSON) withUnixLineEndings
]

{ #category : #'as yet unclassified' }
WDELevelElement >> encodeForJSON [
	^ OrderedDictionary newFromPairs: self encodeJsonKeyValues
]

{ #category : #'as yet unclassified' }
WDELevelElement >> encodeJsonKeyValues [
	^ self subclassResponsibility
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

{ #category : #'as yet unclassified' }
WDELevelElement >> setupForNewInstance [
]

{ #category : #'constructive solid geometry' }
WDELevelElement >> subtract: otherElement withTransform: otherElementTransform [
	^ { self }
]

{ #category : #caching }
WDELevelElement >> validateScene [
]

{ #category : #accessing }
WDELevelElement >> visibleInEditor [

	^ visibleInEditor
]

{ #category : #accessing }
WDELevelElement >> visibleInEditor: anObject [

	visibleInEditor := anObject
]
