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
WDETerrainPatch >> buildPatchWireframeWith: builder [
	| vx sourceIndex vz |
	builder
		beginLines.
	sourceIndex := 1.
	0 to: patchSize - 1 do: [ :y |
		vz := 1 - (y / (patchSize - 1)) + row.
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
	| newHeights destIndex |
	newHeights := FloatArray new: patchSize * patchSize.
	destIndex := 1.
	0 to: patchSize - 1 do: [ :y |
		0 to: patchSize - 1 do: [ :x |
			newHeights at: destIndex put: (aBlock value: x / (patchSize - 1) + column value: y / (patchSize - 1) + row).
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
