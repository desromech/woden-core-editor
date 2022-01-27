Class {
	#name : #WDETerrain,
	#superclass : #WDELevelElement,
	#instVars : [
		'transform',
		'sceneNode',
		'patchSize',
		'patches',
		'columns',
		'rows',
		'editorColor',
		'meshWithAlternatives',
		'wireframeMesh',
		'editorColorMaterial',
		'solidMesh',
		'solidLitMesh',
		'texturedMesh',
		'texturedLitMesh',
		'editorColorLitMaterial',
		'heights'
	],
	#category : #'WodenEditor-Model-Level'
}

{ #category : #accessing }
WDETerrain >> addedToScene: aScene [
	self assert: parent isNotNil.
	
	sceneNode := self validMeshWithAlternatives asSceneNode.
	sceneNode transform: transform.
	parent sceneNode add: sceneNode.
]

{ #category : #accessing }
WDETerrain >> editorColor [

	^ editorColor
]

{ #category : #accessing }
WDETerrain >> editorColor: anObject [

	editorColor := anObject
]

{ #category : #accessing }
WDETerrain >> editorColorLitMaterial [
	^ editorColorLitMaterial ifNil: [
		editorColorLitMaterial := WDMetallicRoughnessMaterial new
			baseColorFactor: self editorColor;
			metallicFactor: 0.0;
			roughnessFactor: 0.7;
			yourself
	]
]

{ #category : #accessing }
WDETerrain >> editorColorMaterial [
	^ editorColorMaterial ifNil: [
		editorColorMaterial := WDUnlitMaterial new
		colorFactor: self editorColor;
		yourself
	]
]

{ #category : #'as yet unclassified' }
WDETerrain >> editorTreeDisplayName [
	^ 'Terrain'
]

{ #category : #accessing }
WDETerrain >> globalTransform [ 
	^ parent ifNil: [ transform ] ifNotNil: [ parent globalTransform transformTransform: transform ]
]

{ #category : #accessing }
WDETerrain >> heights [
	patchSize := 64.
	heights := FloatArray new: patchSize*patchSize.
]

{ #category : #initialization }
WDETerrain >> initialize [
	super initialize.
	transform := TRSTransform3D identity.
	editorColor := Vector4 ones.
	self patchSize: 64 gridExtent: 1@1
]

{ #category : #'as yet unclassified' }
WDETerrain >> instantiateForPlacingInLevel: level box: placementBox [
	| instance |
	instance := self copy setupForNewInstance.
	instance transformWith: (placementBox trsTransformToConvertToMe: instance boundingBox).
	level addTerrain: instance.
	^ instance
]

{ #category : #'as yet unclassified' }
WDETerrain >> instantiateForPlacingInLevel: level point: placementPoint [
	| instance |
	instance := self copy setupForNewInstance.
	instance position: placementPoint.
	level addTerrain: instance.
	^ instance
]

{ #category : #initialization }
WDETerrain >> patchSize: newPatchSize gridExtent: gridExtent [
	| newPatches |
	patchSize := newPatchSize.
	columns := gridExtent x.
	rows := gridExtent y.
	newPatches := OrderedCollection new.
	0 to: columns - 1 do: [ :y |
		0 to: rows - 1 do: [ :x |
			newPatches add: (WDETerrainPatch new
				row: y;
				column: x;
				patchSize: patchSize;
				yourself)
		]
	].
	patches := newPatches
]

{ #category : #accessing }
WDETerrain >> patches [

	^ patches
]

{ #category : #accessing }
WDETerrain >> patches: anObject [

	patches := anObject
]

{ #category : #accessing }
WDETerrain >> removeFromParent [
	parent ifNotNil: [ parent removeTerrain: self ]

]

{ #category : #accessing }
WDETerrain >> removedFromScene: aScene [
	sceneNode ifNotNil: [ 
		sceneNode removeFromScene.
		sceneNode := nil.
	]
	
]

{ #category : #rendering }
WDETerrain >> renderLocalHeightWith: aBlock [
	patches do: [ :each | each renderLocalHeightWith: aBlock ]
]

{ #category : #transforming }
WDETerrain >> transform [

	^ transform
]

{ #category : #transforming }
WDETerrain >> transform: aTransform [
	transform := aTransform asTRSTransform3D copy.
	self transformChanged.
]

{ #category : #transforming }
WDETerrain >> transformChanged [
	sceneNode ifNotNil: [ sceneNode transform: transform ].
]

{ #category : #transforming }
WDETerrain >> transformWith: newTransform [
	self transform: (newTransform transformTransform: self transform)
]

{ #category : #caching }
WDETerrain >> validMeshWithAlternatives [
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
WDETerrain >> validSolidLitMesh [
	^ solidLitMesh ifNil: [ solidLitMesh := self validSolidMesh copyWithMaterial: self editorColorLitMaterial ]
	
]

{ #category : #caching }
WDETerrain >> validSolidMesh [
	| builder |
	solidMesh ifNotNil: [ ^ solidMesh ].
	builder := WDMeshBuilder new.
	builder
		currentMaterial: self editorColorMaterial;
		translateToX: columns / 2 negated y: 0 z: rows / 2 negated.
	self patches do: [ :each | each buildPatchSolidWith: builder ].

	^ solidMesh := builder mesh
]

{ #category : #caching }
WDETerrain >> validTexturedLitMesh [
	| builder |
	texturedLitMesh ifNotNil: [ ^ texturedLitMesh ].
	builder := WDMeshBuilder new.
	builder
		currentMaterial: WDELevelEditorMeshes uniqueInstance defaultMaterial;
		translateToX: columns / 2 negated y: 0 z: rows / 2 negated.
	self patches do: [ :each | each buildPatchTexturedWith: builder ].

	^ texturedLitMesh := builder mesh
]

{ #category : #caching }
WDETerrain >> validTexturedMesh [
	^ texturedMesh ifNil: [ texturedMesh := self validTexturedLitMesh copyTransformingMaterialsWith: [ :mat | mat asUnlitMaterial ] ]
]

{ #category : #caching }
WDETerrain >> validWireframeMesh [
	| builder |
	wireframeMesh ifNotNil: [ ^ wireframeMesh ].
	builder := WDMeshBuilder new.
	builder
		currentMaterial: self editorColorMaterial;
		translateToX: columns / 2 negated y: 0 z: rows / 2 negated.
	self patches do: [ :each | each buildPatchWireframeWith: builder ].
	^ wireframeMesh := builder mesh
]

{ #category : #caching }
WDETerrain >> validateScene [
	sceneNode ifNotNil: [ 
		sceneNode renderables: { self validMeshWithAlternatives }
	].
	
]
