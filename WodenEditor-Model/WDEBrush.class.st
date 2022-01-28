Class {
	#name : #WDEBrush,
	#superclass : #WDELevelElement,
	#instVars : [
		'faces',
		'vertices',
		'sceneNode',
		'hasValidTopology',
		'transform',
		'localBoundingBox',
		'editorColor',
		'wireframeMesh',
		'texturedMesh',
		'solidMesh',
		'editorColorMaterial',
		'editorColorLitMaterial',
		'solidLitMesh',
		'texturedLitMesh',
		'meshWithAlternatives'
	],
	#category : #'WodenEditor-Model-Level'
}

{ #category : #'as yet unclassified' }
WDEBrush class >> forBox: aBox [
	^ self withFaces: { 
		WDEBrushFace plane: (Plane nx: -1 ny: 0 nz: 0 distance: aBox min x abs).
		WDEBrushFace plane: (Plane nx: 1 ny: 0 nz: 0 distance: aBox max x abs).
		WDEBrushFace plane: (Plane nx: 0 ny: -1 nz: 0 distance: aBox min y abs).
		WDEBrushFace plane: (Plane nx: 0 ny: 1 nz: 0 distance: aBox max y abs).
		WDEBrushFace plane: (Plane nx: 0 ny: 0 nz: -1 distance: aBox min z abs).
		WDEBrushFace plane: (Plane nx: 0 ny: 0 nz: 1 distance: aBox max z abs).
	}
]

{ #category : #'as yet unclassified' }
WDEBrush class >> withFaces: aCollectionOfFaces [
	^ self new faces: aCollectionOfFaces; yourself
]

{ #category : #adding }
WDEBrush >> addToEntity: anEntity [
	^ anEntity addBrush: self
]

{ #category : #accessing }
WDEBrush >> addedToScene: aScene [
	self assert: parent isNotNil.
	
	sceneNode := self validMeshWithAlternatives asSceneNode.
	sceneNode transform: transform.
	parent sceneNode add: sceneNode.
]

{ #category : #accessing }
WDEBrush >> boundingBox [
	^ self localBoundingBox transformedWith: transform
]

{ #category : #testing }
WDEBrush >> canBeDuplicatedAndPlaced [
	^ true
]

{ #category : #testing }
WDEBrush >> canBeSubtracted [
	^ true
]

{ #category : #testing }
WDEBrush >> canBeUsedForVolumeSubtractionInEditor [
	^ true
]

{ #category : #'as yet unclassified' }
WDEBrush >> clipAgainstPlane: plane [
	| classification frontFaces backFaces planeInFront planeInBack frontPolyhedron backPolyhedron |
	self validateTopology.
	classification := plane classifyVertices: vertices epsilon: Epsilon.
	self assert: classification ~~ #inside.
	classification == #front ifTrue: [ ^ { self . nil } ].
	classification == #back ifTrue: [ ^ { nil . self } ].
	self assert: classification == #frontAndBack.
	
	frontFaces := OrderedCollection new.
	backFaces := OrderedCollection new.
	
	planeInFront := false.
	planeInBack := false.
	faces do: [ :eachFace |
		| faceClassification |
		faceClassification := plane classifyVertices: eachFace vertices epsilon: Epsilon.
		faceClassification == #inside ifTrue: [
			| normalDirection |
			normalDirection := eachFace plane normal dot: plane normal.
			normalDirection > 0 ifTrue: [
				self assert: (eachFace plane normal normalized closeTo: plane normal normalized).
				backFaces add: eachFace copy.
				planeInBack := true.
			] ifFalse: [ 
				self assert: (eachFace plane normal normalized closeTo: plane normal normalized).
				frontFaces add: (eachFace copy plane: eachFace plane negated).
				planeInFront := true.
			].
		].
		faceClassification == #front ifTrue: [ 
			frontFaces add: eachFace copy		
		].
		faceClassification == #back ifTrue: [ 
			backFaces add: eachFace copy
		].
		faceClassification == #frontAndBack ifTrue: [ 
			frontFaces add: eachFace copy.
			backFaces add: eachFace copy.
		].
	].

	planeInBack ifFalse: [
		backFaces add: (WDEBrushFace plane: plane)
	].
	planeInFront ifFalse: [
		frontFaces add: (WDEBrushFace plane: plane negated)
	].

	frontPolyhedron := self class new
		setupForNewInstance;
		faces: frontFaces;
		yourself.
	backPolyhedron := self class new
		setupForNewInstance;
		faces: backFaces;
		yourself.
	^ { frontPolyhedron . backPolyhedron }
]

{ #category : #accessing }
WDEBrush >> editorColor [
	^ editorColor
]

{ #category : #accessing }
WDEBrush >> editorColor: anObject [
	editorColor := anObject.
	editorColorMaterial ifNotNil: [ editorColorMaterial colorFactor: editorColor ].
	editorColorLitMaterial ifNotNil: [ editorColorLitMaterial baseColorFactor: editorColor ].
]

{ #category : #accessing }
WDEBrush >> editorColorLitMaterial [
	^ editorColorLitMaterial ifNil: [
		editorColorLitMaterial := WDMetallicRoughnessMaterial new
			baseColorFactor: self editorColor;
			metallicFactor: 0.0;
			roughnessFactor: 0.7;
			yourself
	]
]

{ #category : #accessing }
WDEBrush >> editorColorMaterial [
	^ editorColorMaterial ifNil: [
		editorColorMaterial := WDUnlitMaterial new
		colorFactor: self editorColor;
		yourself
	]
]

{ #category : #'as yet unclassified' }
WDEBrush >> editorTreeChildren [
	^ faces
]

{ #category : #'as yet unclassified' }
WDEBrush >> editorTreeDisplayName [
	^ 'Brush'
]

{ #category : #serialization }
WDEBrush >> encodeJsonKeyValues [
	^ {
		#editorColor . editorColor encodeForJSON.
		#transform . transform encodeForJSON.
		#faces . faces collect: [ :each | each encodeForJSON ]
	}
]

{ #category : #caching }
WDEBrush >> faceTexturesChanged [
	self invalidateTexturedMeshes
]

{ #category : #accessing }
WDEBrush >> faces [

	^ faces
]

{ #category : #accessing }
WDEBrush >> faces: aListOfFaces [
	faces := aListOfFaces.
	faces do: [ :each | each parent: self ].
	self invalidateTopology
]

{ #category : #'as yet unclassified' }
WDEBrush >> generateEditorColor [
	self editorColor: self class generateEditorColor.
]

{ #category : #accessing }
WDEBrush >> globalBoundingBox [
	^ self boundingBox transformedWith: parent transform
]

{ #category : #accessing }
WDEBrush >> globalTransform [ 
	^ parent ifNil: [ transform ] ifNotNil: [ parent globalTransform transformTransform: transform ]
]

{ #category : #testing }
WDEBrush >> hasIntersectionWithBrush: otherElement withTransform: otherElementTransform [
	| otherSupportFunction |
	self class == otherElement class ifFalse: [ ^ false ].
	
	"Test the bounding to quickly discard."
	(self localBoundingBox hasIntersectionWithBox: (otherElement localBoundingBox transformedWith: otherElementTransform)) ifFalse: [ ^ false ].
	
	"Test using GJK."
	otherSupportFunction := GeometricFunctions transformSupportFunction: (otherElement localSupportFunction) with: otherElementTransform.
	
	^ GeometricFunctions gjkIntersectionTest: self localSupportFunction with: otherSupportFunction
]

{ #category : #testing }
WDEBrush >> hasIntersectionWithConvexSupportFunction: otherSupportFunction [
	^ GeometricFunctions gjkIntersectionTest: self supportFunction with: otherSupportFunction
]

{ #category : #testing }
WDEBrush >> hasIntersectsWithVolume: volumeToTest [
	volumeToTest class == self class ifTrue: [
		^ self hasIntersectionWithBrush: volumeToTest withTransform: (self globalTransform inverseTransformTransform: volumeToTest globalTransform)
	].

	^ volumeToTest hasIntersectionWithConvexSupportFunction: self supportFunction
]

{ #category : #initialization }
WDEBrush >> initialize [
	super initialize.
	faces := #().
	vertices := #().
	hasValidTopology := false.
	transform := TRSTransform3D identity.
	editorColor := Vector4 ones.
]

{ #category : #'as yet unclassified' }
WDEBrush >> instantiateForPlacingInLevel: level box: placementBox [
	| instance |
	instance := self copy setupForNewInstance.
	instance transformWith: (placementBox trsTransformToConvertToMe: instance boundingBox).
	level addBrush: instance.
	^ instance
]

{ #category : #'as yet unclassified' }
WDEBrush >> instantiateForPlacingInLevel: level point: placementPoint [
	| instance |
	instance := self copy setupForNewInstance.
	instance position: placementPoint.
	level addBrush: instance.
	^ instance
]

{ #category : #caching }
WDEBrush >> invalidateMeshes [
	wireframeMesh := nil.
	solidMesh := nil.
	solidLitMesh := nil.
	self invalidateTexturedMeshes
]

{ #category : #caching }
WDEBrush >> invalidateTexturedMeshes [
	texturedLitMesh := nil.
	texturedMesh := nil.
	meshWithAlternatives := nil.
	self level ifNotNil: [ :level | level recordElementWithInvalidScene: self ].
]

{ #category : #caching }
WDEBrush >> invalidateTopology [
	hasValidTopology := false.
	self invalidateMeshes
]

{ #category : #testing }
WDEBrush >> isManipulableInEditorSceneView [
	^ true
]

{ #category : #serialization }
WDEBrush >> loadFromJson: jsonData inLevel: level [
	jsonData at: #editorColor ifPresent: [ :found | editorColor := Vector4 loadFromJson: found ].
	jsonData at: #transform ifPresent: [ :found | transform := TRSTransform3D loadFromJson: found ].
	self faces: ((jsonData at: #faces ifAbsent: [ #() ]) collect: [ :each |
		WDEBrushFace new
			loadFromJson: each inLevel: level
	])
]

{ #category : #accessing }
WDEBrush >> localBoundingBox [
	self validateTopology.
	^ localBoundingBox
]

{ #category : #support }
WDEBrush >> localSupportFunction [
	self validateTopology.
	^ [ :d |
		| best bestDot |
		best := nil.
		bestDot := Float negativeInfinity.
		vertices do: [ :v |
			| dot |
			dot := v dot: d.
			dot > bestDot ifTrue: [
				best := v.
				bestDot := dot
			]
		].
	
		best
	]
]

{ #category : #memento }
WDEBrush >> materialStateMemento [
	^ faces collect: [ :each | each materialStateMemento ]
]

{ #category : #accessing }
WDEBrush >> position [
	^ transform translation
]

{ #category : #accessing }
WDEBrush >> position: aPosition [
	transform translation: aPosition.
	self transformChanged.
]

{ #category : #memento }
WDEBrush >> positionStateMemento [
	^ self position
]

{ #category : #copying }
WDEBrush >> postCopy [
	parent := nil.
	self faces: (faces collect: [ :each | each copy ]).
	sceneNode := nil.
	localBoundingBox := localBoundingBox copy.
	transform := transform copy.
	
	meshWithAlternatives := nil.
	wireframeMesh := nil.
	solidMesh := nil.
	solidLitMesh := nil.
	texturedMesh := nil.
	texturedLitMesh := nil.
	editorColorMaterial := nil.
]

{ #category : #serialization }
WDEBrush >> prepareForSerializationInLevel: level [
	faces do: [ :each | each prepareForSerializationInLevel: level ].
	
]

{ #category : #'as yet unclassified' }
WDEBrush >> rayCast: ray [
	| localRay bestDistance |
	bestDistance := nil.
	localRay := ray inverseTransformedWith: transform.
	faces do: [ :face |
		| intersectionDistance  |
		intersectionDistance := face plane intersectionWithRay: localRay.
		intersectionDistance ifNotNil: [
			| intersectionPoint |
			intersectionPoint := localRay pointAtDistance: intersectionDistance.
			(faces allSatisfy: [ :otherFace | otherFace == face or: [ otherFace plane isPointInsideOrBehind: intersectionPoint ] ]) ifTrue: [ 
				(bestDistance isNil or: [ intersectionDistance < bestDistance ]) ifTrue: [ 
					bestDistance := intersectionDistance
				]
			]
		].
	].

	bestDistance ifNil: [ ^ nil ].

	^ ray distanceForPoint: (transform transformPosition: (localRay pointAtDistance: bestDistance))
]

{ #category : #accessing }
WDEBrush >> rayCastAllAlong: ray [
	| result |
	result := self rayCast: ray.
	^ result ifNil: [ #() ] ifNotNil: [ {result -> self} ]
]

{ #category : #removing }
WDEBrush >> removeFromParent [
	parent ifNotNil: [ parent removeBrush: self ]

]

{ #category : #accessing }
WDEBrush >> removedFromScene: aScene [
	sceneNode ifNotNil: [ 
		sceneNode removeFromScene.
		sceneNode := nil.
	]
	
]

{ #category : #memento }
WDEBrush >> restoreMaterialStateMemento: memento [
	faces doWithIndex: [ :face :faceIndex | face restoreMaterialStateMemento: (memento at: faceIndex) ]
]

{ #category : #memento }
WDEBrush >> restorePositionStateMemento: memento [
	self position: memento
]

{ #category : #memento }
WDEBrush >> restoreTransformStateMemento: memento [
	self transform: memento
]

{ #category : #accessing }
WDEBrush >> selectableGlobalBoundingBox [
	^ self globalBoundingBox
]

{ #category : #initialization }
WDEBrush >> setMaterialRecursively: newMaterial [
	faces do: [ :face | face setMaterialRecursively: newMaterial ]
]

{ #category : #'as yet unclassified' }
WDEBrush >> setupForNewInstance [
	self generateEditorColor
]

{ #category : #'constructive solid geometry' }
WDEBrush >> subtract: otherBrush [
	| otherBrushTransform myTransform |
	otherBrush class == self class ifFalse: [ ^ { self } ].
	
	otherBrushTransform := otherBrush globalTransform.
	myTransform := self globalTransform.
	^ self subtract: otherBrush withTransform: (myTransform inverseTransformTransform: otherBrushTransform)
]

{ #category : #'constructive solid geometry' }
WDEBrush >> subtract: otherBrush withTransform: otherBrushTransform [
	| otherPlanes otherPlaneClassifications clippingPlanes result remaining |
	self validateTopology.
	(self hasIntersectionWithBrush: otherBrush withTransform: otherBrushTransform) ifFalse: [ 
		^ super subtract: otherBrush withTransform: otherBrushTransform
	].
	otherPlanes := otherBrush faces collect: [ :face | face plane transformedWith: otherBrushTransform ].
	otherPlanes ifEmpty: [ ^ { self } ].

	otherPlaneClassifications := otherPlanes collect: [ :eachPlane | eachPlane classifyVertices: vertices epsilon: Epsilon ].
	
	"Am I fully contained in the other polytope?"
	(otherPlaneClassifications allSatisfy: [:each | #(back inside) includes: each ]) ifTrue: [ ^ #() ].

	"Am I fully outside the other polytope?"
	(otherPlaneClassifications anySatisfy: [:each | #(front inside) includes: each ]) ifTrue: [ ^ { self } ].

	"We only clip against front and back planes."
	clippingPlanes := OrderedCollection new.
	otherPlaneClassifications doWithIndex: [ :classification :index |
		classification == #frontAndBack ifTrue: [ 
			clippingPlanes add: (otherPlanes at: index)
		].
	].

	self assert: clippingPlanes isNotEmpty.
	result := OrderedCollection new. 
	remaining := self.
	clippingPlanes do: [ :plane |
		| frontAndBack front back |
		frontAndBack := remaining clipAgainstPlane: plane.
		front := frontAndBack first.
		back := frontAndBack second.
		front ifNotNil: [
			result add: front
		].

		self assert: back isNotNil.
		remaining := back
	].
	
	^ result
]

{ #category : #support }
WDEBrush >> supportFunction [
	^ GeometricFunctions transformSupportFunction: self localSupportFunction with: self globalTransform
]

{ #category : #accessing }
WDEBrush >> transform [

	^ transform
]

{ #category : #accessing }
WDEBrush >> transform: aTransform [
	transform := aTransform asTRSTransform3D copy.
	self transformChanged.
]

{ #category : #accessing }
WDEBrush >> transformChanged [
	sceneNode ifNotNil: [ sceneNode transform: transform ].
	self invalidateTexturedMeshes.
]

{ #category : #memento }
WDEBrush >> transformStateMemento [
	^ transform copy
]

{ #category : #transforming }
WDEBrush >> transformWith: newTransform [
	self transform: (newTransform transformTransform: self transform)
]

{ #category : #transforming }
WDEBrush >> translateBy: translation [
	self position: self position + translation
]

{ #category : #caching }
WDEBrush >> validMeshWithAlternatives [
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
WDEBrush >> validSolidLitMesh [
	^ solidLitMesh ifNil: [ solidLitMesh := self validSolidMesh copyWithMaterial: self editorColorLitMaterial ]
	
]

{ #category : #caching }
WDEBrush >> validSolidMesh [
	| builder |
	solidMesh ifNotNil: [ ^ solidMesh ].
	self validateTopology.
	builder := WDMeshBuilder new.
	builder currentMaterial: self editorColorMaterial.
	faces do: [ :face |
		face buildSolidFaceMeshWith: builder
	].

	^ solidMesh := builder mesh
]

{ #category : #caching }
WDEBrush >> validTexturedLitMesh [
	| builder globalTransform |
	texturedLitMesh ifNotNil: [ ^ texturedLitMesh ].
	self validateTopology.
	builder := WDMeshBuilder new.
	globalTransform := self globalTransform.
	faces do: [ :face |
		face buildTexturedFaceMeshWith: builder transform: globalTransform
	].

	^ texturedLitMesh := builder mesh
]

{ #category : #caching }
WDEBrush >> validTexturedMesh [
	^ texturedMesh ifNil: [ texturedMesh := self validTexturedLitMesh copyTransformingMaterialsWith: [ :mat | mat asUnlitMaterial ] ]
]

{ #category : #caching }
WDEBrush >> validWireframeMesh [
	| builder |
	wireframeMesh ifNotNil: [ ^ wireframeMesh ].
	self validateTopology.
	builder := WDMeshBuilder new.
	builder currentMaterial: self editorColorMaterial.
	faces do: [ :face |
		face buildWireframeFaceMeshWith: builder
	].

	^ wireframeMesh := builder mesh
]

{ #category : #caching }
WDEBrush >> validateScene [
	sceneNode ifNotNil: [ 
		sceneNode renderables: { self validMeshWithAlternatives }
	].
	
]

{ #category : #caching }
WDEBrush >> validateTopology [
	| faceCount |
	hasValidTopology ifTrue: [ ^ self ].
	faceCount := faces size.
	vertices := OrderedCollection new.
	faces do: [ :f | f clearIndices ].
	
	1 to: faceCount do: [ :i |
		| f1 p1 |
		f1 := (faces at: i).
		p1 := f1 plane.
		i + 1 to: faceCount do: [ :j |
			| f2 p2 |
			f2 := (faces at: j).
			p2 := f2 plane.
			j + 1 to: faceCount do: [ :k |
				| f3 p3 |
				f3 := (faces at: k).
				p3 := f3 plane.
				(i ~= j and: [j ~= k]) ifTrue: [
					| m |
					m := Matrix3x3 rows: { p1 normal . p2 normal . p3 normal }.
					(m determinant closeTo: 0) ifFalse: [ 
						| v p vi |
						v := Vector3 x: p1 distance y: p2 distance z: p3 distance.
						p := m inverse * v.
						vi := vertices size.
						vertices add: p.
						f1 addIndex: vi.
						f2 addIndex: vi.
						f3 addIndex: vi.
					].
				]
			]
		]
	].

	localBoundingBox := AABox empty.
	faces do: [ :f |
		f sortIndices; computeBoundingBox.
		localBoundingBox insertBox: f boundingBox
	].
	hasValidTopology := true
]

{ #category : #accessing }
WDEBrush >> vertices [
	^ vertices
]
