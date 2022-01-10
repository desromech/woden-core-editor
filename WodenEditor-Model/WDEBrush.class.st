Class {
	#name : #WDEBrush,
	#superclass : #WDELevelElement,
	#instVars : [
		'parent',
		'faces',
		'sceneNode',
		'hasValidTopology',
		'boundingBox'
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
	parent sceneNode add: sceneNode.
]

{ #category : #accessing }
WDEBrush >> boundingBox [
	^ boundingBox
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

{ #category : #accessing }
WDEBrush >> faces [

	^ faces
]

{ #category : #accessing }
WDEBrush >> faces: anObject [
	faces := anObject.
	hasValidTopology := false.
]

{ #category : #initialization }
WDEBrush >> initialize [
	super initialize.
	faces := #().
	hasValidTopology := false.
]

{ #category : #accessing }
WDEBrush >> parent [

	^ parent
]

{ #category : #accessing }
WDEBrush >> parent: anObject [

	parent := anObject
]

{ #category : #'as yet unclassified' }
WDEBrush >> rayCast: ray [
	| bestDistance |
	bestDistance := nil.
	faces do: [ :face |
		| intersectionDistance  |
		intersectionDistance := face plane intersectionWithRay: ray.
		intersectionDistance ifNotNil: [
			| intersectionPoint |
			intersectionPoint := ray pointAtDistance: intersectionDistance.
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

{ #category : #accessing }
WDEBrush >> removeFromScene: aScene [
	sceneNode ifNotNil: [ 
		sceneNode removeFromScene.
		sceneNode := nil.
	]
	
]

{ #category : #'as yet unclassified' }
WDEBrush >> validateTopology [
	| faceCount |
	faceCount := faces size.
	faces do: [ :f | f clearVertices ].
	
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
					m := Matrix3x3 columns: { p1 normal . p2 normal . p3 normal }.
					(m determinant closeTo: 0) ifFalse: [ 
						| v p |
						v := Vector3 x: p1 distance y: p2 distance z: p3 distance.
						p := m inverse * v.
						f1 addVertex: p.
						f2 addVertex: p.
						f3 addVertex: p.
					].
				]
			]
		]
	].

	boundingBox := AABox empty.
	faces do: [ :f |
		f sortVertices; computeBoundingBox.
		boundingBox insertBox: f boundingBox
	].

]