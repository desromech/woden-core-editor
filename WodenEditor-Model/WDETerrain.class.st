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
		'localBoundingBox'
	],
	#category : #'WodenEditor-Model-Level'
}

{ #category : #accessing }
WDETerrain >> addedToScene: aScene [
	self assert: parent isNotNil.
	
	sceneNode := WDSceneNode new.
	sceneNode transform: transform.
	parent sceneNode add: sceneNode.
	
	patches do: [ :each | each addedToScene: aScene ].
]

{ #category : #accessing }
WDETerrain >> columns [
	^ columns
]

{ #category : #'as yet unclassified' }
WDETerrain >> editorTreeDisplayName [
	^ 'Terrain'
]

{ #category : #accessing }
WDETerrain >> globalTransform [ 
	^ parent ifNil: [ transform ] ifNotNil: [ parent globalTransform transformTransform: transform ]
]

{ #category : #initialization }
WDETerrain >> initialize [
	super initialize.
	transform := TRSTransform3D identity.
	patches := #().
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

{ #category : #'as yet unclassified' }
WDETerrain >> invalidateLocalBoundingBox [
	localBoundingBox := nil
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
	self privateSetPatches: newPatches
]

{ #category : #accessing }
WDETerrain >> patches [

	^ patches
]

{ #category : #copying }
WDETerrain >> postCopy [
	parent := nil.
	patches := #().
	self privateSetPatches: (patches collect: [ :each | each copy ]).
	sceneNode := nil.
	localBoundingBox := localBoundingBox copy.
	transform := transform copy.

]

{ #category : #'as yet unclassified' }
WDETerrain >> privateSetPatches: newPatches [
	sceneNode ifNotNil: [ 
		patches do: [ :each | each removedFromScene: self level editorScene ].
	].
	patches do: [ :each | each parent: nil ].

	patches := newPatches.

	patches do: [ :each | each parent: self ].
	sceneNode ifNotNil: [ 
		patches do: [ :each | each addedToScene: self level editorScene ].
	].
	
]

{ #category : #accessing }
WDETerrain >> removeFromParent [
	parent ifNotNil: [ parent removeTerrain: self ]

]

{ #category : #accessing }
WDETerrain >> removedFromScene: aScene [
	patches do: [ :each | each removedFromScene: aScene ].
	sceneNode ifNotNil: [ 
		sceneNode removeFromScene.
		sceneNode := nil.
	]
	
]

{ #category : #rendering }
WDETerrain >> renderLocalHeightWith: aBlock [
	patches do: [ :each | each renderLocalHeightWith: aBlock ]
]

{ #category : #accessing }
WDETerrain >> rows [
	^ rows
]

{ #category : #accessing }
WDETerrain >> sceneNode [
	^ sceneNode
]

{ #category : #initialization }
WDETerrain >> setMaterialRecursively: newMaterial [
	patches do: [ :each | each setMaterialRecursively: newMaterial ]
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
