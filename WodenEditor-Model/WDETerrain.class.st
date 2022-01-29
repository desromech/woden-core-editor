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

{ #category : #initialization }
WDETerrain class >> patchSize: patchSize gridExtent: gridExtent [
	^ self new patchSize: patchSize gridExtent: gridExtent; yourself
]

{ #category : #accessing }
WDETerrain >> addedToScene: aScene [
	self assert: parent isNotNil.
	
	sceneNode := WDSceneNode new.
	sceneNode transform: transform.
	parent sceneNode add: sceneNode.
	
	patches do: [ :each | each addedToScene: aScene ].
]

{ #category : #accessing }
WDETerrain >> boundingBox [
	^ self localBoundingBox transformedWith: transform
]

{ #category : #accessing }
WDETerrain >> canBeDuplicatedAndPlaced [
	^ true
]

{ #category : #accessing }
WDETerrain >> columns [
	^ columns
]

{ #category : #'as yet unclassified' }
WDETerrain >> editorTreeDisplayName [
	^ 'Terrain'
]

{ #category : #serialization }
WDETerrain >> encodeJsonKeyValues [
	^ {
		#transform . transform encodeForJSON.
		#patchSize . patchSize.
		#rows . rows.
		#columns . columns.
		#patches . patches collect: [ :each | each encodeForJSON ].
	}
]

{ #category : #accessing }
WDETerrain >> globalBoundingBox [
	^ self boundingBox transformedWith: parent transform
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
	self patchSize: 32 gridExtent: 1@1
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

{ #category : #accessing }
WDETerrain >> isManipulableInEditorSceneView [
	^ true
]

{ #category : #serialization }
WDETerrain >> loadFromJson: jsonData inLevel: level [
	patchSize := jsonData at: #patchSize.
	rows := jsonData at: #rows.
	columns := jsonData at: #columns.
	jsonData at: #transform ifPresent: [ :found | transform := TRSTransform3D loadFromJson: found ].
	patches := (jsonData at: #patches ifAbsent: [ #() ]) collectWithIndex: [ :each :index |
		WDETerrainPatch new
			patchSize: patchSize;
			row: (index - 1) // columns;
			column: (index - 1) % columns;
			loadFromJson: each inLevel: level;
			parent: self;
			yourself
	]
]

{ #category : #accessing }
WDETerrain >> localBoundingBox [
	localBoundingBox ifNil: [ 
		localBoundingBox := AABox empty.
		patches do: [ :each |
			localBoundingBox insertBox: each boundingBox
		]
	].
	^ localBoundingBox
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

{ #category : #memento }
WDETerrain >> position [
	^ transform translation
]

{ #category : #accessing }
WDETerrain >> position: aPosition [
	transform translation: aPosition.
	self transformChanged.
]

{ #category : #memento }
WDETerrain >> positionStateMemento [
	^ self position
]

{ #category : #copying }
WDETerrain >> postCopy [
	| oldPatches |
	parent := nil.
	oldPatches := patches.
	patches := #().
	self privateSetPatches: (oldPatches collect: [ :each | each copy ]).
	sceneNode := nil.
	localBoundingBox := localBoundingBox copy.
	transform := transform copy.

]

{ #category : #serialization }
WDETerrain >> prepareForSerializationInLevel: level [
	patches do: [ :each | each prepareForSerializationInLevel: level ].
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
WDETerrain >> rayCast: ray [
	| localRay bestDistance |
	bestDistance := nil.
	localRay := ray inverseTransformedWith: transform.
	patches do: [ :each |
		| intersectionDistance |
		intersectionDistance := each rayCast: localRay.
		intersectionDistance ifNotNil: [ 
			(bestDistance isNil or: [intersectionDistance < bestDistance]) ifTrue: [ 
				bestDistance := intersectionDistance
			]
		]
	].

	bestDistance ifNil: [ ^ nil ].
	^ ray distanceForPoint: (transform transformPosition: (localRay pointAtDistance: bestDistance))
]

{ #category : #accessing }
WDETerrain >> rayCastAllAlong: ray [
	| result |
	result := self rayCast: ray.
	^ result ifNil: [ #() ] ifNotNil: [ {result -> self} ]
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

{ #category : #memento }
WDETerrain >> restorePositionStateMemento: memento [
	self position: memento
]

{ #category : #memento }
WDETerrain >> restoreTransformStateMemento: memento [
	self transform: memento
]

{ #category : #accessing }
WDETerrain >> rows [
	^ rows
]

{ #category : #accessing }
WDETerrain >> sceneNode [
	^ sceneNode
]

{ #category : #accessing }
WDETerrain >> selectableGlobalBoundingBox [
	^ self globalBoundingBox
]

{ #category : #initialization }
WDETerrain >> setMaterialRecursively: newMaterial [
	patches do: [ :each | each setMaterialRecursively: newMaterial ]
]

{ #category : #'as yet unclassified' }
WDETerrain >> setupForNewInstance [
	patches do: [ :each | each setupForNewInstance ]
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

{ #category : #accessing }
WDETerrain >> transformChanged [
	sceneNode ifNotNil: [ sceneNode transform: transform ].
]

{ #category : #memento }
WDETerrain >> transformStateMemento [
	^ transform copy
]

{ #category : #transforming }
WDETerrain >> transformWith: newTransform [
	self transform: (newTransform transformTransform: self transform)
]

{ #category : #transforming }
WDETerrain >> translateBy: translation [
	self position: self position + translation
]
