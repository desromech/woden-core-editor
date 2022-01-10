Class {
	#name : #WDEBrushFace,
	#superclass : #WDELevelElement,
	#instVars : [
		'plane',
		'vertices',
		'boundingBox'
	],
	#category : #'WodenEditor-Model-Level'
}

{ #category : #accessing }
WDEBrushFace class >> plane: aPlane [
	^ self new plane: aPlane; yourself
]

{ #category : #'mesh building' }
WDEBrushFace >> addVertex: position [
	vertices add: position
]

{ #category : #accessing }
WDEBrushFace >> boundingBox [
	^ boundingBox
]

{ #category : #'mesh building' }
WDEBrushFace >> buildFaceMeshWith: builder [
	| normal |
	builder beginTriangles.
	normal := plane normal.
	vertices do: [ :v |
		builder addP: v; addN: normal
	].
	2 to: vertices size - 1 do: [ :i |
		builder addTriangleI0: 0 i1: i - 1 i2: i
	].
]

{ #category : #'mesh building' }
WDEBrushFace >> clearVertices [
	vertices := OrderedCollection new.
	boundingBox := AABox empty.
]

{ #category : #'mesh building' }
WDEBrushFace >> computeBoundingBox [
	boundingBox := AABox empty.
	vertices do: [ :v | boundingBox insertPoint: v ].
	
]

{ #category : #'as yet unclassified' }
WDEBrushFace >> editorTreeDisplayName [
	^ 'Face'
]

{ #category : #initialization }
WDEBrushFace >> initialize [
	super initialize.
	boundingBox := AABox empty.
]

{ #category : #'as yet unclassified' }
WDEBrushFace >> instantiateForPlacingInLevel: level box: placementBox [
	self shouldNotImplement
]

{ #category : #'as yet unclassified' }
WDEBrushFace >> instantiateForPlacingInLevel: level point: placementPoint [
	self shouldNotImplement
]

{ #category : #accessing }
WDEBrushFace >> plane [

	^ plane
]

{ #category : #accessing }
WDEBrushFace >> plane: anObject [

	plane := anObject
]

{ #category : #'mesh building' }
WDEBrushFace >> sortVertices [
	| centroid n |
	centroid := vertices sum / vertices size.
	n := plane normal.
	vertices sort: [ :a :b |
		| u v |
		u := centroid - a.
		v := centroid - b.
		((u cross: v) dot: n) >= 0
	]
]
