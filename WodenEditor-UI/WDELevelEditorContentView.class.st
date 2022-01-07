Class {
	#name : #WDELevelEditorContentView,
	#superclass : #SpPresenterWithModel,
	#instVars : [
		'sceneView',
		'scene',
		'camera',
		'axisNode',
		'gridNode',
		'subGridNode',
		'cameraNode',
		'cameraAngle',
		'viewScale',
		'gridOrientation',
		'lastDragPosition',
		'editorViewType'
	],
	#category : #'WodenEditor-UI-Spec'
}

{ #category : #specs }
WDELevelEditorContentView class >> defaultSpec [

	^ SpBoxLayout newVertical
		  add: #sceneView;
		  yourself
]

{ #category : #shading }
WDELevelEditorContentView >> activateFlatColor [
]

{ #category : #shading }
WDELevelEditorContentView >> activateFlatTextured [
]

{ #category : #shading }
WDELevelEditorContentView >> activateFullShaded [
]

{ #category : #shading }
WDELevelEditorContentView >> activateMaterialValidation [
]

{ #category : #shading }
WDELevelEditorContentView >> activateShadedColor [
]

{ #category : #shading }
WDELevelEditorContentView >> activateWireFrame [
]

{ #category : #camera }
WDELevelEditorContentView >> backView [
]

{ #category : #camera }
WDELevelEditorContentView >> bottomView [
]

{ #category : #camera }
WDELevelEditorContentView >> cameraFocalPoint [
	^ self validCameraTransform transformPosition: (Vector3 z: self cameraFocalPointDistance negated)
]

{ #category : #camera }
WDELevelEditorContentView >> cameraFocalPointDistance [
	| fov |
	fov := camera fovY.
	^ (viewScale / ((fov * 0.5) degreesToRadians tan))
]

{ #category : #initialization }
WDELevelEditorContentView >> createAxisNode [
	axisNode := WDELevelEditorMeshes uniqueInstance axisMesh asSceneNode.
	scene add: axisNode
]

{ #category : #initialization }
WDELevelEditorContentView >> createGridNode [
	| gridMaterial |
	gridMaterial := WDELevelEditorMeshes uniqueInstance gridMaterial copy colorFactor: Color gray lighter.
	gridNode := (WDELevelEditorMeshes uniqueInstance gridMesh copyWithMaterial: gridMaterial) asSceneNode.
	scene add: gridNode
]

{ #category : #initialization }
WDELevelEditorContentView >> createScene [
	scene := WDScene new.
	self createSceneNodes
]

{ #category : #initialization }
WDELevelEditorContentView >> createSceneNodes [
	camera := WDCamera new
		isPerspective: false;
		yourself.
	cameraNode := camera asSceneNode.
	sceneView 
		scene: scene;
		camera: cameraNode.
	cameraNode
		orientation: Quaternion lookAtBottom;
		position: (Vector3 x: 0 y: 1 z: 3).
	editorViewType := #top.
	self
		createSubGridNode;
		createGridNode;
		createAxisNode.
	self updateCameraAndGrid
]

{ #category : #initialization }
WDELevelEditorContentView >> createSubGridNode [
	| gridMaterial |
	gridMaterial := WDELevelEditorMeshes uniqueInstance gridMaterial copy
		colorFactor: Color darkGray darker.
	subGridNode := (WDELevelEditorMeshes uniqueInstance subGridMesh copyWithMaterial: gridMaterial) asSceneNode.
	scene add: subGridNode.
]

{ #category : #camera }
WDELevelEditorContentView >> frontView [
]

{ #category : #accessing }
WDELevelEditorContentView >> gridSize [
	^ self model ifNil: [1.0 ] ifNotNil: [:m | m gridSize]
]

{ #category : #initialization }
WDELevelEditorContentView >> initialize [
	cameraAngle := Vector3 zeros.
	gridOrientation := Quaternion identity.
	viewScale := 20.0.
	super initialize.

]

{ #category : #initialization }
WDELevelEditorContentView >> initializePresenters [
	sceneView := self instantiate: WDSpScenePresenter.
	sceneView eventHandler
		whenKeyDownDo: [ :event | self onSceneKeyDown: event ];
		whenKeyUpDo: [ :event | self onSceneKeyUp: event ];
		whenMouseDownDo: [ :event | self onSceneMouseDown: event ];
		whenMouseUpDo: [ :event | self onSceneMouseUp: event ];
		whenMouseMoveDo: [ :event | self onSceneMouseMove: event ]
]

{ #category : #camera }
WDELevelEditorContentView >> leftView [
]

{ #category : #initialization }
WDELevelEditorContentView >> levelChanged [
	self levelSceneChanged
]

{ #category : #initialization }
WDELevelEditorContentView >> levelScene [
	^ self model ifNotNil: [ :m | m levelScene ]
]

{ #category : #initialization }
WDELevelEditorContentView >> levelSceneChanged [
	self levelScene ifNil: [
		self createScene
	] ifNotNil: [ :levelScene |
		scene := levelScene.
		self createSceneNodes
	].
]

{ #category : #initialization }
WDELevelEditorContentView >> modelChanged [
	self levelSceneChanged
]

{ #category : #event }
WDELevelEditorContentView >> onSceneDrag: event delta: delta [
	event isPrimaryButton ifTrue: [
	].

	event isSecondaryButton ifTrue: [
		event controlKeyPressed ifTrue: [
			cameraAngle := cameraAngle + (Vector3 x: delta y negated degreesToRadians y: delta x negated degreesToRadians z: 0.0).
		] ifFalse: [
			cameraNode translateBy: (cameraNode orientation transformVector3: (Vector3 x: delta x y: delta y negated z: 0.0) * 0.01).
		].

		self updateCameraAndGrid
	].
]

{ #category : #event }
WDELevelEditorContentView >> onSceneKeyDown: event [
]

{ #category : #event }
WDELevelEditorContentView >> onSceneKeyUp: event [
]

{ #category : #event }
WDELevelEditorContentView >> onSceneMouseDown: event [
]

{ #category : #event }
WDELevelEditorContentView >> onSceneMouseMove: event [
	lastDragPosition ifNotNil: [
		| delta |
		delta := event position - lastDragPosition.
		self onSceneDrag: event delta: delta
	].

	(event isPrimaryButton or: [event isSecondaryButton or: [event isMiddleButton] ]) ifTrue: [
		lastDragPosition := event position.
	].
]

{ #category : #event }
WDELevelEditorContentView >> onSceneMouseUp: event [
	(event isPrimaryButton or: [event isSecondaryButton or: [event isMiddleButton] ]) ifFalse: [
		lastDragPosition := nil.
	].
]

{ #category : #camera }
WDELevelEditorContentView >> orthographicView [
	camera isPerspective: false.	
	self updateCameraAndGrid
]

{ #category : #camera }
WDELevelEditorContentView >> perspectiveView [
	camera isPerspective: true.
	self updateCameraAndGrid
]

{ #category : #camera }
WDELevelEditorContentView >> rightView [
]

{ #category : #camera }
WDELevelEditorContentView >> rotateCameraToAngles: newAngles [
	self rotateCameraToAngles: newAngles withFocalPoint: self cameraFocalPoint distance: self cameraFocalPointDistance
]

{ #category : #camera }
WDELevelEditorContentView >> rotateCameraToAngles: newAngles withFocalPoint: focalPoint distance: focalPointDistance [
	cameraAngle := newAngles.
	
	cameraNode position: (focalPoint + (self validCameraOrientation rotateVector: (Vector3 z: focalPointDistance))).
	self updateCameraAndGrid

]

{ #category : #accessing }
WDELevelEditorContentView >> sceneView [

	^ sceneView
]

{ #category : #accessing }
WDELevelEditorContentView >> session [
	^ self model
]

{ #category : #camera }
WDELevelEditorContentView >> togglePerspective [
	camera isPerspective: camera isPerspective not.
	self updateCameraAndGrid
]

{ #category : #camera }
WDELevelEditorContentView >> topView [
	camera isPerspective: false.
	gridOrientation := Quaternion lookAtBottom.
	editorViewType := #top.
	self rotateCameraToAngles: (Vector3 x: Float halfPi negated).
]

{ #category : #camera }
WDELevelEditorContentView >> updateCamera [
	cameraNode orientation: self validCameraOrientation.
]

{ #category : #camera }
WDELevelEditorContentView >> updateCameraAndGrid [
	self
		updateCamera;
		updateGrid.
	sceneView refresh
]

{ #category : #camera }
WDELevelEditorContentView >> updateGrid [
	| viewGridOrientation gridTransform scale u v du dv gridPosition |
	viewGridOrientation := camera isPerspective
		ifTrue: [ Quaternion lookAtBottom	 ]
		ifFalse: [ gridOrientation ].	
		
	scale := self gridSize / WDELevelEditorMeshes uniqueInstance baseGridSize.

	u := viewGridOrientation rotateVector: (Vector3 x: 1).
	v := viewGridOrientation rotateVector: (Vector3 y: 1).
	
	du := (u dot: cameraNode position) roundFloorWithQuantum: self gridSize.
	dv := (v dot: cameraNode position) roundFloorWithQuantum: self gridSize.

	gridPosition := (u * du) + (v * dv).	
	
	gridTransform := TRSTransform3D new
		scale: scale;
		rotation: viewGridOrientation;
		translation: gridPosition;
		yourself.
	gridNode transform: gridTransform.
	subGridNode transform: gridTransform.
]

{ #category : #camera }
WDELevelEditorContentView >> validCameraOrientation [
	^ (Quaternion yRotation: cameraAngle y) * (Quaternion xRotation: cameraAngle x)
]

{ #category : #camera }
WDELevelEditorContentView >> validCameraTransform [
	^ TRSTransform3D identity
		rotation: self validCameraOrientation;
		translation: cameraNode position;
		yourself
]
