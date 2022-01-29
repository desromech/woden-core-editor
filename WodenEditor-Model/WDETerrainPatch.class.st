Class {
	#name : #WDETerrainPatch,
	#superclass : #WDELevelElement,
	#instVars : [
		'patchSize',
		'row',
		'column',
		'heights',
		'material',
		'textureScale',
		'textureOffset',
		'textureRotation',
		'meshWithAlternatives',
		'wireframeMesh',
		'solidMesh',
		'solidLitMesh',
		'texturedMesh',
		'texturedLitMesh',
		'editorColorMaterial',
		'editorColor',
		'editorColorLitMaterial',
		'localBoundingBox',
		'sceneNode'
	],
	#category : #'WodenEditor-Model-Level'
}

{ #category : #accessing }
WDETerrainPatch >> addedToScene: aScene [
	sceneNode := self validMeshWithAlternatives asSceneNode.
	sceneNode position: self position.
	parent sceneNode add: sceneNode.
]

{ #category : #accessing }
WDETerrainPatch >> boundingBox [
	^ self localBoundingBox translatedBy: self position
]

{ #category : #'as yet unclassified' }
WDETerrainPatch >> buildPatchSolidWith: builder [
	| vx sourceIndex vz |
	builder
		beginTriangles.
	sourceIndex := 1.
	0 to: patchSize - 1 do: [ :y |
		vz := (y / (patchSize - 1)).
		0 to: patchSize - 1 do: [ :x |
			|b t l r c|
			vx := (x / (patchSize - 1)).
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
	| vx sourceIndex vz textureMatrix terrainScale |
	builder
		currentMaterial: ((material ifNotNil: [ material validMaterialForGameSettings: self gameSettings ])
			ifNil: [WDELevelEditorMeshes uniqueInstance defaultMaterial]);
		beginTriangles.
	terrainScale := parent ifNotNil: [parent transform scale] ifNil: [Vector3 withAll: 1].
	sourceIndex := 1.
	textureMatrix := self computeTextureMatrix.
	0 to: patchSize - 1 do: [ :y |
		vz := (y / (patchSize - 1)).
		0 to: patchSize - 1 do: [ :x |
			| t b l r c tc |
			vx := (x / (patchSize - 1)).
			t := b := l := r := c := heights at: sourceIndex.
			y > 0 ifTrue: [ b := heights at: sourceIndex - patchSize ].
			y + 1 < patchSize ifTrue: [ t := heights at: sourceIndex + patchSize ].
			x > 0 ifTrue: [ l := heights at: sourceIndex - 1 ].
			x + 1 < patchSize ifTrue: [ r := heights at: sourceIndex + 1 ].
			tc := textureMatrix transformVector2: (Vector2 x: vx * terrainScale x y: vz * terrainScale z).
			
			builder
				addPx: vx y: c z: vz;
				addT0: tc;
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
		vz := (y / (patchSize - 1)).
		0 to: patchSize - 1 do: [ :x |
			vx := (x / (patchSize - 1)).
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
WDETerrainPatch >> columns [
	^ parent ifNil: [ 1 ] ifNotNil: [ parent columns ]
]

{ #category : #'as yet unclassified' }
WDETerrainPatch >> computeNormalWithDx: dx dz: dz [
	| tangent bitangent |
	tangent := Vector3 x: 1 y: dx z: 0.
	bitangent := Vector3 x: 0 y: dz z: -1.
	^ (tangent cross: bitangent) normalized
]

{ #category : #'as yet unclassified' }
WDETerrainPatch >> computeTextureMatrix [
	^ Matrix3x3 texScale: textureScale offset: textureOffset
]

{ #category : #accessing }
WDETerrainPatch >> editorColor [

	^ editorColor
]

{ #category : #accessing }
WDETerrainPatch >> editorColor: anObject [

	editorColor := anObject
]

{ #category : #accessing }
WDETerrainPatch >> editorColorLitMaterial [
	^ editorColorLitMaterial ifNil: [
		editorColorLitMaterial := WDMetallicRoughnessMaterial new
			baseColorFactor: self editorColor;
			metallicFactor: 0.0;
			roughnessFactor: 0.7;
			yourself
	]
]

{ #category : #accessing }
WDETerrainPatch >> editorColorMaterial [
	^ editorColorMaterial ifNil: [
		editorColorMaterial := WDUnlitMaterial new
		colorFactor: self editorColor;
		yourself
	]
]

{ #category : #serialization }
WDETerrainPatch >> encodeJsonKeyValues [
	| heightBytes encodedHeights |
	heightBytes := heights shallowCopy.
	ByteArray adoptInstance: heightBytes.
	encodedHeights := heightBytes base64Encoded.
	^ {
		#editorColor . editorColor encodeForJSON.
		#heights . encodedHeights.
		#material . material ifNotNil: [ material index ].
		#textureScale . textureScale encodeForJSON.
		#textureOffset . textureOffset encodeForJSON.
		#textureRotation . textureRotation.
	} 
]

{ #category : #'as yet unclassified' }
WDETerrainPatch >> generateEditorColor [
	self editorColor: self class generateEditorColor.
]

{ #category : #accessing }
WDETerrainPatch >> globalTransform [ 
	^ parent ifNil: [ self transform ] ifNotNil: [ parent globalTransform transformTransform: self transform ]
]

{ #category : #accessing }
WDETerrainPatch >> heights [

	^ heights
]

{ #category : #accessing }
WDETerrainPatch >> heights: newHeight [
	heights := newHeight.
	self heightsChanged
	
]

{ #category : #accessing }
WDETerrainPatch >> heightsChanged [
	self invalidateMeshes.
	localBoundingBox := nil.
	parent ifNotNil: [ parent invalidateLocalBoundingBox ]
	
]

{ #category : #initialization }
WDETerrainPatch >> initialize [
	super initialize.
	editorColor := Vector4 ones.
	patchSize := 32.
	row := 0.
	column := 0.
	heights := FloatArray new: patchSize*patchSize.
	textureScale := Vector2 withAll: 1.0.
	textureOffset := Vector2 withAll: 0.0.
	textureRotation := 0.0
]

{ #category : #'as yet unclassified' }
WDETerrainPatch >> instantiateForPlacingInLevel: level box: placementBox [
	self shouldNotImplement
]

{ #category : #'as yet unclassified' }
WDETerrainPatch >> instantiateForPlacingInLevel: level point: placementPoint [
	self shouldNotImplement
]

{ #category : #caching }
WDETerrainPatch >> invalidateMeshes [
	wireframeMesh := nil.
	solidMesh := nil.
	solidLitMesh := nil.
	self invalidateTexturedMeshes
]

{ #category : #caching }
WDETerrainPatch >> invalidateTexturedMeshes [
	texturedLitMesh := nil.
	texturedMesh := nil.
	meshWithAlternatives := nil.
	self level ifNotNil: [ :level | level recordElementWithInvalidScene: self ].
]

{ #category : #serialization }
WDETerrainPatch >> loadFromJson: jsonData inLevel: level [
	| encodedHeights |
	encodedHeights := jsonData at: #heights.
	jsonData at: #editorColor ifPresent: [ :found | editorColor := Vector4 loadFromJson: found ].
	heights := encodedHeights base64Decoded shallowCopy.
	FloatArray adoptInstance: heights.
	(jsonData at: #material ifAbsent: [nil]) ifNotNil: [ :materialIndex |
		material := level getMaterialWithIndex: materialIndex
	].
	textureScale := Vector2 loadFromJson: (jsonData at: #textureScale).
	textureOffset := Vector2 loadFromJson: (jsonData at: #textureOffset).
	textureRotation := jsonData at: #textureRotation.
]

{ #category : #accessing }
WDETerrainPatch >> localBoundingBox [
	localBoundingBox ifNil: [ 
		localBoundingBox := AABox min: (Vector3 x: 0 y: heights min z: 0) max: (Vector3 x: 1 y: heights max z: 1)
	].
	^ localBoundingBox
]

{ #category : #accessing }
WDETerrainPatch >> material [

	^ material
]

{ #category : #accessing }
WDETerrainPatch >> material: aMaterial [
	| changed newMaterial |
	newMaterial := aMaterial asWDEMaterialInfo.
	changed := material ~~ newMaterial.
	material := newMaterial.
	changed ifTrue: [ self texturingChanged ].
]

{ #category : #accessing }
WDETerrainPatch >> patchSize: newPatchSize [
	patchSize  := newPatchSize.
	heights := FloatArray new: patchSize*patchSize
]

{ #category : #accessing }
WDETerrainPatch >> position [
	^ Vector3 x: column - (self columns / 2) y: 0 z: row - (self rows / 2)
]

{ #category : #copying }
WDETerrainPatch >> postCopy [
	meshWithAlternatives := nil.
	wireframeMesh := nil.
	solidMesh := nil.
	solidLitMesh := nil.
	texturedMesh := nil.
	texturedLitMesh := nil.
	editorColorMaterial := nil.
]

{ #category : #serialization }
WDETerrainPatch >> prepareForSerializationInLevel: level [
	level recordMaterialInfo: material.
]

{ #category : #accessing }
WDETerrainPatch >> rayCast: ray [
	| position bbox boxHit entryPoint exitPoint previousPointHeight previousHeightSample |
	position := self position.
	bbox := self boundingBox.
	boxHit := bbox intersectionsWithRay: ray.
	boxHit ifNil: [ ^ nil ].
	
	entryPoint := (ray pointAtDistance: boxHit first) - position.
	exitPoint := (ray pointAtDistance: boxHit second) - position.

	previousPointHeight := entryPoint y.
	previousHeightSample := self sampleHeightAtX: entryPoint x z: entryPoint z.
	0 to: 1 by: (1 / patchSize) do: [ :alpha |
		| testPoint heightSample testPointHeight minHeightSample maxHeightSample minPointHeight maxPointHeight |
		testPoint := entryPoint interpolateTo: exitPoint at: alpha.
		heightSample := self sampleHeightAtX: testPoint x z: testPoint z.
		testPointHeight := testPoint y.
		
		minHeightSample := previousHeightSample min: heightSample.
		maxHeightSample := previousHeightSample max: heightSample.

		minPointHeight := previousPointHeight min: testPointHeight.
		maxPointHeight := previousPointHeight max: testPointHeight.
		
		(maxPointHeight < minHeightSample or: [ maxHeightSample < minPointHeight ]) ifFalse: [
			^ boxHit first interpolateTo: boxHit second at: alpha
		].
		
		previousPointHeight := testPointHeight.
		previousHeightSample := heightSample.
	].
	
	^ nil
]

{ #category : #accessing }
WDETerrainPatch >> removedFromScene: aScene [
	sceneNode ifNotNil: [ 
		sceneNode removeFromScene.
		sceneNode := nil.
	]

]

{ #category : #rendering }
WDETerrainPatch >> renderLocalHeightWith: aBlock [
	| newHeights destIndex columnOffset rowOffset |
	newHeights := FloatArray new: patchSize * patchSize.
	destIndex := 1.
	columnOffset := column.
	rowOffset := row.
	
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

{ #category : #accessing }
WDETerrainPatch >> rows [
	^ parent ifNil: [ 1 ] ifNotNil: [ parent rows ]
]

{ #category : #'as yet unclassified' }
WDETerrainPatch >> sampleHeightAtX: x z: z [
	| sampleColumn sampleRow |
	sampleColumn := (x * patchSize) floor min: patchSize - 1 max: 0.
	sampleRow := (z * patchSize) floor min: patchSize - 1 max: 0.
	^ heights at: sampleRow*patchSize + sampleColumn + 1
]

{ #category : #initialization }
WDETerrainPatch >> setMaterialRecursively: newMaterial [
	self material: newMaterial
]

{ #category : #'as yet unclassified' }
WDETerrainPatch >> setupForNewInstance [
	self generateEditorColor
]

{ #category : #accessing }
WDETerrainPatch >> textureOffset [

	^ textureOffset
]

{ #category : #accessing }
WDETerrainPatch >> textureOffset: anObject [

	textureOffset := anObject
]

{ #category : #accessing }
WDETerrainPatch >> textureRotation [

	^ textureRotation
]

{ #category : #accessing }
WDETerrainPatch >> textureRotation: anObject [

	textureRotation := anObject
]

{ #category : #accessing }
WDETerrainPatch >> textureScale [

	^ textureScale
]

{ #category : #accessing }
WDETerrainPatch >> textureScale: anObject [

	textureScale := anObject
]

{ #category : #'as yet unclassified' }
WDETerrainPatch >> texturingChanged [
	self invalidateTexturedMeshes
]

{ #category : #accessing }
WDETerrainPatch >> transform [
	^ TRSTransform3D translation: self position
]

{ #category : #caching }
WDETerrainPatch >> validMeshWithAlternatives [
	^ meshWithAlternatives ifNil: [ meshWithAlternatives := WDRenderableWithViewModeAlternatives new
		wireframe: self validWireframeMesh;
		flatColor: self validSolidMesh;
		flatColorShaded: self validSolidLitMesh;
		flatTextured: self validTexturedMesh;
		fullShaded: self validTexturedLitMesh;
		yourself
	]
]

{ #category : #caching }
WDETerrainPatch >> validSolidLitMesh [
	^ solidLitMesh ifNil: [ solidLitMesh := self validSolidMesh copyWithMaterial: self editorColorLitMaterial ]
	
]

{ #category : #caching }
WDETerrainPatch >> validSolidMesh [
	| builder |
	solidMesh ifNotNil: [ ^ solidMesh ].
	builder := WDMeshBuilder new.
	builder
		currentMaterial: self editorColorMaterial.
	self buildPatchSolidWith: builder.

	^ solidMesh := builder mesh
]

{ #category : #caching }
WDETerrainPatch >> validTexturedLitMesh [
	| builder |
	texturedLitMesh ifNotNil: [ ^ texturedLitMesh ].
	builder := WDMeshBuilder new.
	builder
		currentMaterial: WDELevelEditorMeshes uniqueInstance defaultMaterial.
	self buildPatchTexturedWith: builder.

	^ texturedLitMesh := builder mesh
]

{ #category : #caching }
WDETerrainPatch >> validTexturedMesh [
	^ texturedMesh ifNil: [ texturedMesh := self validTexturedLitMesh copyTransformingMaterialsWith: [ :mat | mat asUnlitMaterial ] ]
]

{ #category : #caching }
WDETerrainPatch >> validWireframeMesh [
	| builder |
	wireframeMesh ifNotNil: [ ^ wireframeMesh ].
	builder := WDMeshBuilder new.
	builder currentMaterial: self editorColorMaterial.
	self buildPatchWireframeWith: builder.
	^ wireframeMesh := builder mesh
]

{ #category : #caching }
WDETerrainPatch >> validateScene [
	sceneNode ifNotNil: [ 
		sceneNode renderables: { self validMeshWithAlternatives }
	].
	
]
