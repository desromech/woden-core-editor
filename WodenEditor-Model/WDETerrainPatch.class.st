Class {
	#name : #WDETerrainPatch,
	#superclass : #WDELevelElement,
	#instVars : [
		'patchSize',
		'row',
		'column',
		'heights'
	],
	#category : #'WodenEditor-Model-Level'
}

{ #category : #'as yet unclassified' }
WDETerrainPatch >> buildPatchSolidWith: builder [
	| vx sourceIndex vz |
	builder
		beginTriangles.
	sourceIndex := 1.
	0 to: patchSize - 1 do: [ :y |
		vz := (y / (patchSize - 1)) + row.
		0 to: patchSize - 1 do: [ :x |
			|b t l r c|
			vx := (x / (patchSize - 1)) + column.
			t := b := l := r := c := heights at: sourceIndex.
			y > 0 ifTrue: [ b := heights at: sourceIndex - patchSize ].
			y + 1 < patchSize ifTrue: [ t := heights at: sourceIndex + patchSize ].
			x > 0 ifTrue: [ l := heights at: sourceIndex - 1 ].
			x + 1 < patchSize ifTrue: [ r := heights at: sourceIndex + 1 ].
			
			builder
				addPx: vx y: c z: vz;
				addN: (self computeNormalWithDx: r - l dz: t - b).
			sourceIndex := sourceIndex + 1.
		]
	].

	0 to: patchSize - 2 do: [ :y |
		| rowStart |
		rowStart := patchSize * y.
		0 to: patchSize - 2 do: [ :x |
			builder
				addTriangleI0: rowStart + x + patchSize + 1 i1: rowStart + x + 1 i2: rowStart + x;
				addTriangleI0: rowStart + x i1: rowStart + x + patchSize i2: rowStart + x + patchSize + 1.
			sourceIndex := sourceIndex + 1.
		].
	].
	
]

{ #category : #'as yet unclassified' }
WDETerrainPatch >> buildPatchTexturedWith: builder [
	| vx sourceIndex vz |
	builder
		beginTriangles.
	sourceIndex := 1.
	0 to: patchSize - 1 do: [ :y |
		vz := (y / (patchSize - 1)) + row.
		0 to: patchSize - 1 do: [ :x |
			| t b l r c |
			vx := (x / (patchSize - 1)) + column.
			t := b := l := r := c := heights at: sourceIndex.
			y > 0 ifTrue: [ b := heights at: sourceIndex - patchSize ].
			y + 1 < patchSize ifTrue: [ t := heights at: sourceIndex + patchSize ].
			x > 0 ifTrue: [ l := heights at: sourceIndex - 1 ].
			x + 1 < patchSize ifTrue: [ r := heights at: sourceIndex + 1 ].
			
			builder
				addPx: vx y: c z: vz;
				addN: (self computeNormalWithDx: r - l dz: t - b).
			sourceIndex := sourceIndex + 1.
		]
	].

	0 to: patchSize - 2 do: [ :y |
		| rowStart |
		rowStart := patchSize * y.
		0 to: patchSize - 2 do: [ :x |
			builder
				addTriangleI0: rowStart + x + patchSize + 1 i1: rowStart + x + 1 i2: rowStart + x;
				addTriangleI0: rowStart + x i1: rowStart + x + patchSize i2: rowStart + x + patchSize + 1.
			sourceIndex := sourceIndex + 1.
		].
	].
	
]

{ #category : #'as yet unclassified' }
WDETerrainPatch >> buildPatchWireframeWith: builder [
	| vx sourceIndex vz |
	builder
		beginLines.
	sourceIndex := 1.
	0 to: patchSize - 1 do: [ :y |
		vz := (y / (patchSize - 1)) + row.
		0 to: patchSize - 1 do: [ :x |
			vx := (x / (patchSize - 1)) + column.
			builder addPx: vx y: (heights at: sourceIndex) z: vz.
			sourceIndex := sourceIndex + 1.
		]
	].

	0 to: patchSize - 1 do: [ :y |
		| rowStart |
		rowStart := patchSize * y.
		0 to: patchSize - 1 do: [ :x |
			x + 1 < patchSize ifTrue: [ 
				builder addLineI0: rowStart + x i1: rowStart + x + 1.
			].
			y + 1 < patchSize  ifTrue: [ 
				builder addLineI0: rowStart + x i1: rowStart + x + patchSize.
			].
			sourceIndex := sourceIndex + 1.
		].
	].
	
]

{ #category : #accessing }
WDETerrainPatch >> column [

	^ column
]

{ #category : #accessing }
WDETerrainPatch >> column: anObject [

	column := anObject
]

{ #category : #'as yet unclassified' }
WDETerrainPatch >> computeNormalWithDx: dx dz: dz [
	| tangent bitangent |
	tangent := Vector3 x: 1 y: dx z: 0.
	bitangent := Vector3 x: 0 y: dz z: -1.
	^ (tangent cross: bitangent) normalized
]

{ #category : #accessing }
WDETerrainPatch >> heights [

	^ heights
]

{ #category : #accessing }
WDETerrainPatch >> heights: anObject [

	heights := anObject
]

{ #category : #initialization }
WDETerrainPatch >> initialize [
	super initialize.
	patchSize := 32.
	row := 0.
	column := 0.
	heights := FloatArray new: patchSize*patchSize.
]

{ #category : #accessing }
WDETerrainPatch >> patchSize: newPatchSize [
	patchSize  := newPatchSize.
	heights := FloatArray new: patchSize*patchSize
]

{ #category : #rendering }
WDETerrainPatch >> renderLocalHeightWith: aBlock [
	| newHeights destIndex columnOffset rowOffset |
	newHeights := FloatArray new: patchSize * patchSize.
	destIndex := 1.
	columnOffset := column. "column * (patchSize - 1) / patchSize".
	rowOffset := row. "row * (patchSize - 1) / patchSize".
	
	0 to: patchSize - 1 do: [ :y |
		0 to: patchSize - 1 do: [ :x |
			newHeights at: destIndex put: (aBlock value: x / (patchSize - 1) + columnOffset value: y / (patchSize - 1) + rowOffset).
			destIndex := destIndex + 1
		]
	].
	self heights: newHeights
]

{ #category : #accessing }
WDETerrainPatch >> row [

	^ row
]

{ #category : #accessing }
WDETerrainPatch >> row: anObject [

	row := anObject
]
