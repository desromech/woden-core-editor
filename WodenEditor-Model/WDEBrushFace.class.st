Class {
	#name : #WDEBrushFace,
	#superclass : #WDELevelElement,
	#instVars : [
		'plane',
		'indices',
		'boundingBox',
		'material',
		'vertices',
		'textureScale',
		'textureOffset',
		'textureRotation'
	],
	#classVars : [
		'BitangentAxis',
		'NormalAxis',
		'TangentAxis'
	],
	#category : #'WodenEditor-Model-Level'
}

{ #category : #'as yet unclassified' }
WDEBrushFace class >> findAxisForNormal: normal [
	| bestAmount best |
	bestAmount := Float infinity negated.
	best := 1.
	1 to: 6 do: [ :i |
		| axis amount |
		axis := NormalAxis at: i.
		amount := normal dot: axis.
		amount > bestAmount ifTrue: [ 
			best := i.
			bestAmount := amount
		].
	].
	^ best
]

{ #category : #'as yet unclassified' }
WDEBrushFace class >> getBitangentForNormalAxis: axis [
	^ BitangentAxis at: axis
]

{ #category : #'as yet unclassified' }
WDEBrushFace class >> getTangentForNormalAxis: axis [
	^ TangentAxis at: axis
]

{ #category : #initialization }
WDEBrushFace class >> initialize [
	NormalAxis := { 
		Vector3 x: 1.
		Vector3 x: -1.
		Vector3 y: 1.
		Vector3 y: -1.
		Vector3 z: 1.
		Vector3 z: -1.
	}.
	
	TangentAxis := { 
		Vector3 z: -1.
		Vector3 z: 1.
		Vector3 x: 1.
		Vector3 x: 1.
		Vector3 x: 1.
		Vector3 x: -1.
	}.
	
	BitangentAxis := {
		Vector3 y: -1.
		Vector3 y: -1.
		Vector3 z: 1.
		Vector3 z: -1.
		Vector3 y: -1.
		Vector3 y: -1.
	}.
]

{ #category : #accessing }
WDEBrushFace class >> plane: aPlane [
	^ self new plane: aPlane; yourself
]

{ #category : #'mesh building' }
WDEBrushFace >> addIndex: index [
	indices add: index.
	vertices := nil.
]

{ #category : #accessing }
WDEBrushFace >> boundingBox [
	^ boundingBox
]

{ #category : #'mesh building' }
WDEBrushFace >> buildSolidFaceMeshWith: builder [
	| normal brushVertices |
	builder
		beginTriangles.
	normal := plane normal.
	brushVertices := parent vertices.
	indices do: [ :i |
		| v |
		v := brushVertices at: i + 1.
		builder addP: v; addN: normal
	].
	2 to: indices size - 1 do: [ :i |
		builder addTriangleI0: 0 i1: i - 1 i2: i
	].
]

{ #category : #'mesh building' }
WDEBrushFace >> buildTexturedFaceMeshWith: builder transform: globalTransform [
	| normal brushVertices textureMatrix normalAxis tangent bitangent |
	builder
		currentMaterial: ((material ifNotNil: [ material validMaterialForGameSettings: self gameSettings ])
			ifNil: [WDELevelEditorMeshes uniqueInstance defaultMaterial]);
		beginTriangles.
	textureMatrix := self computeTextureMatrix.
		
	normal := plane normal.
	normalAxis := self class findAxisForNormal: normal.
	tangent := self class getTangentForNormalAxis: normalAxis.
	bitangent := self class getBitangentForNormalAxis: normalAxis.

	brushVertices := parent vertices.
	indices do: [ :i |
		| v wv tu tv  tc |
		v := brushVertices at: i + 1.
		wv := globalTransform transformPosition: v.
		tu := wv dot: tangent.
		tv := wv dot: bitangent.
		tc := textureMatrix transformVector2: (Vector2 x: tu y: tv).
		builder addP: v; addT0: tc; addN: normal
	].
	2 to: indices size - 1 do: [ :i |
		builder addTriangleI0: 0 i1: i - 1 i2: i
	].
]

{ #category : #'mesh building' }
WDEBrushFace >> buildWireframeFaceMeshWith: builder [
	| normal brushVertices |
	builder
		beginLines.
	normal := plane normal.
	brushVertices := parent vertices.
	indices do: [ :i |
		| v |
		v := brushVertices at: i + 1.
		builder addP: v
	].
	0 to: indices size - 1 do: [ :i |
		builder addLineI0: i i1: (i + 1) % indices size
	].
]

{ #category : #'mesh building' }
WDEBrushFace >> clearIndices [
	indices := OrderedCollection new.
	vertices := nil.
	boundingBox := AABox empty.
]

{ #category : #'mesh building' }
WDEBrushFace >> computeBoundingBox [
	| brushVertices |
	boundingBox := AABox empty.
	brushVertices := parent vertices.
	indices do: [ :i | boundingBox insertPoint: (brushVertices at: i + 1) ].
	
]

{ #category : #'as yet unclassified' }
WDEBrushFace >> computeTextureMatrix [
	^ Matrix3x3 texScale: textureScale offset: textureOffset
]

{ #category : #serialization }
WDEBrushFace >> encodeJsonKeyValues [
	^ {
		#plane . plane encodeForJSON.
		#material . material ifNotNil: [ material index ].
		#textureScale . textureScale encodeForJSON.
		#textureOffset . textureOffset encodeForJSON.
		#textureRotation . textureRotation.
	}
]

{ #category : #accessing }
WDEBrushFace >> indices [
	^ indices
]

{ #category : #initialization }
WDEBrushFace >> initialize [
	super initialize.
	boundingBox := AABox empty.
	textureScale := Vector2 withAll: 0.25.
	textureOffset := Vector2 zeros.
	textureRotation := 0.
]

{ #category : #'as yet unclassified' }
WDEBrushFace >> instantiateForPlacingInLevel: level box: placementBox [
	self shouldNotImplement
]

{ #category : #'as yet unclassified' }
WDEBrushFace >> instantiateForPlacingInLevel: level point: placementPoint [
	self shouldNotImplement
]

{ #category : #serialization }
WDEBrushFace >> loadFromJson: jsonData inLevel: level [
	plane := Plane loadFromJson: (jsonData at: #plane).
	(jsonData at: #material ifAbsent: [nil]) ifNotNil: [ :materialIndex |
		material := level getMaterialWithIndex: materialIndex
	].
	textureScale := Vector2 loadFromJson: (jsonData at: #textureScale).
	textureOffset := Vector2 loadFromJson: (jsonData at: #textureOffset).
	textureRotation := jsonData at: #textureRotation.

]

{ #category : #accessing }
WDEBrushFace >> material [
	^ material
]

{ #category : #accessing }
WDEBrushFace >> material: aMaterial [
	| changed newMaterial |
	newMaterial := aMaterial asWDEMaterialInfo.
	changed := material ~~ newMaterial.
	material := newMaterial.
	(changed and: [parent isNotNil]) ifTrue: [ parent faceTexturesChanged ].
]

{ #category : #memento }
WDEBrushFace >> materialStateMemento [
	^ material
]

{ #category : #accessing }
WDEBrushFace >> plane [

	^ plane
]

{ #category : #accessing }
WDEBrushFace >> plane: anObject [

	plane := anObject
]

{ #category : #copying }
WDEBrushFace >> postCopy [
	parent := nil.
	indices := nil.
	vertices := nil.
	boundingBox := AABox empty.
]

{ #category : #serialization }
WDEBrushFace >> prepareForSerializationInLevel: level [
	level recordMaterialInfo: material.
]

{ #category : #printing }
WDEBrushFace >> printOn: aStream [
	aStream nextPutAll: self class name;
		nextPutAll: ' plane: '; print: plane
]

{ #category : #memento }
WDEBrushFace >> restoreMaterialStateMemento: memento [
	self material: memento
]

{ #category : #initialization }
WDEBrushFace >> setMaterialRecursively: newMaterial [
	self material: newMaterial
]

{ #category : #'mesh building' }
WDEBrushFace >> sortIndices [
	| centroid n brushVertices |
	brushVertices := parent vertices.
	centroid := Vector3 zeros.
	indices do: [ :i |
		centroid := centroid + (brushVertices at: i + 1)
	].
	centroid := centroid / indices size.
	n := plane normal.

	indices sort: [ :a :b |
		| u v |
		u := centroid - (brushVertices at: a + 1).
		v := centroid - (brushVertices at: b + 1).
		((u cross: v) dot: n) >= 0
	]
]

{ #category : #'as yet unclassified' }
WDEBrushFace >> treeDisplayName [
	^ 'Face'
]

{ #category : #accessing }
WDEBrushFace >> vertices [
	^ vertices ifNil: [
		| brushVertices |
		brushVertices := parent vertices.
		vertices := indices collect: [ :i | brushVertices at: i + 1 ]
	]
]
