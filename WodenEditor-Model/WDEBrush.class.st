Class {
	#name : #WDEBrush,
	#superclass : #WDELevelElement,
	#instVars : [
		'faces',
		'vertices',
		'sceneNode',
		'hasValidTopology',
		'transform',
		'localBoundingBox'
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

{ #category : #accessing }
WDEBrush >> addedToScene: aScene [
	| mesh |
	self assert: parent isNotNil.
	
	mesh := self computeMesh.
	sceneNode := mesh asSceneNode.
	sceneNode transform: transform.
	parent sceneNode add: sceneNode.
]

{ #category : #accessing }
WDEBrush >> boundingBox [
	^ self localBoundingBox transformedWith: transform
]

{ #category : #testing }
WDEBrush >> canBeSubtracted [
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

	frontPolyhedron := self class new faces: frontFaces; yourself.
	backPolyhedron := self class new faces: backFaces; yourself.
	^ { frontPolyhedron . backPolyhedron }
]

{ #category : #'as yet unclassified' }
WDEBrush >> computeMesh [
	| builder |
	self validateTopology.
	builder := WDMeshBuilder new.
	faces do: [ :face |
		face buildFaceMeshWith: builder
	].

	^ builder mesh
]

{ #category : #'as yet unclassified' }
WDEBrush >> editorTreeChildren [
	^ faces
]

{ #category : #'as yet unclassified' }
WDEBrush >> editorTreeDisplayName [
	^ 'Brush'
]

{ #category : #'as yet unclassified' }
WDEBrush >> faceTexturesChanged [
	sceneNode ifNotNil: [ 
		sceneNode renderables: {self computeMesh}
	].
]

{ #category : #accessing }
WDEBrush >> faces [

	^ faces
]

{ #category : #accessing }
WDEBrush >> faces: aListOfFaces [
	faces := aListOfFaces.
	faces do: [ :each | each parent: self ].
	hasValidTopology := false.
]

{ #category : #accessing }
WDEBrush >> globalBoundingBox [
	^ self boundingBox transformedWith: parent transform
]

{ #category : #testing }
WDEBrush >> hasIntersectionWith: otherElement withTransform: otherElementTransform [
	self class == otherElement class ifFalse: [ ^ false ].
	self flag: 'TODO: Implement this properly'.
	^ true
]

{ #category : #initialization }
WDEBrush >> initialize [
	super initialize.
	faces := #().
	vertices := #().
	hasValidTopology := false.
	transform := TRSTransform3D identity.
]

{ #category : #'as yet unclassified' }
WDEBrush >> instantiateForPlacingInLevel: level box: placementBox [
	| instance |
	instance := self copy.
	instance transformWith: (placementBox trsTransformToConvertToMe: instance boundingBox).
	level addBrush: instance.
	^ instance
]

{ #category : #'as yet unclassified' }
WDEBrush >> instantiateForPlacingInLevel: level point: placementPoint [
	| instance |
	instance := self copy.
	instance position: placementPoint.
	level addBrush: instance.
	^ instance
]

{ #category : #testing }
WDEBrush >> isManipulableInEditorSceneView [
	^ true
]

{ #category : #accessing }
WDEBrush >> localBoundingBox [
	self validateTopology.
	^ localBoundingBox
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
	faces := faces collect: [ :each | each copy ].
	sceneNode := nil.
	localBoundingBox := localBoundingBox copy.
	transform := transform copy.
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

	^ bestDistance
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
WDEBrush >> removeFromScene: aScene [
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

{ #category : #'constructive solid geometry' }
WDEBrush >> subtract: otherBrush withTransform: otherBrushTransform [
	| otherPlanes otherPlaneClassifications clippingPlanes result remaining |
	self validateTopology.
	(self hasIntersectionWith: otherBrush withTransform: otherBrushTransform) ifFalse: [ 
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

{ #category : #accessing }
WDEBrush >> transform [

	^ transform
]

{ #category : #accessing }
WDEBrush >> transform: anObject [
	transform := anObject.
	self transformChanged.
]

{ #category : #accessing }
WDEBrush >> transformChanged [
	sceneNode ifNotNil: [ sceneNode transform: transform ]
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

{ #category : #'as yet unclassified' }
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
