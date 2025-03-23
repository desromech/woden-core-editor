Class {
	#name : 'WDELevelEditorContentView',
	#superclass : 'SpPresenterWithModel',
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
		'editorViewType',
		'activeEditionMode',
		'activeToolMode',
		'activeToolManipulator',
		'highlightedManipulator',
		'highlightBoxNode',
		'lastDownEvent',
		'cameraLight',
		'levelPresentationHandle',
		'activeToolEditionElementsManipulator'
	],
	#classVars : [
		'OrthographicFarDistance',
		'OrthographicNearDistance',
		'PerspectiveFarDistance',
		'PerspectiveNearDistance'
	],
	#category : 'WodenEditor-UI-Spec',
	#package : 'WodenEditor-UI',
	#tag : 'Spec'
}

{ #category : 'specs' }
WDELevelEditorContentView class >> defaultLayout [

	^ SpBoxLayout newVertical
		  add: #sceneView;
		  yourself
]

{ #category : 'initialization' }
WDELevelEditorContentView class >> initialize [
	PerspectiveNearDistance := 0.1.
	PerspectiveFarDistance := 10000.0.
	
	OrthographicNearDistance := -10000.0.
	OrthographicFarDistance := 10000.0.
]

{ #category : 'actions' }
WDELevelEditorContentView >> actionOpenFile [
	| dialog result |
	dialog := self createLevelFileDialog.
	dialog title: 'Select the level to open'; answerPathName.
	result := dialog openModal answer.
	result ifNil: [ ^ self ].
	self model openFrom: result asFileReference
]

{ #category : 'actions' }
WDELevelEditorContentView >> actionSaveFile [
	self model levelFileReference ifNotNil: [ :fileReference |
		self model saveTo: fileReference
	] ifNil: [
		self actionSaveFileAs
	]
]

{ #category : 'actions' }
WDELevelEditorContentView >> actionSaveFileAs [
	| dialog result |
	dialog := self createLevelFileDialog.
	dialog
		title: 'Select the location to save the level';
		fileNameText: 'level.' , self level validExtensions first;
		answerSaveFile.
	self model levelFileReference ifNotNil: [ :fileRef |
		dialog
			fileNameText: fileRef basename;
			selectPath: fileRef parent
	].

	result := dialog openModal answer.
	result ifNil: [ ^ self ].
	self model saveTo: result asFileReference
]

{ #category : 'editor modes' }
WDELevelEditorContentView >> activateFaceTexturingMode [
	self activeEditionMode: (WDELevelEditorViewFaceTexturingMode for: self)
]

{ #category : 'shading' }
WDELevelEditorContentView >> activateFlatColor [
	camera viewMode: WDFlatColorViewMode.
	self refresh
]

{ #category : 'shading' }
WDELevelEditorContentView >> activateFlatTextured [
	camera viewMode: WDFlatTexturedViewMode.
	self refresh
]

{ #category : 'shading' }
WDELevelEditorContentView >> activateFullShaded [
	camera viewMode: WDFullShadedViewMode.
	self refresh
]

{ #category : 'shading' }
WDELevelEditorContentView >> activateMaterialValidation [
	camera viewMode: WDMaterialValidationViewMode.
	self refresh
]

{ #category : 'editor modes' }
WDELevelEditorContentView >> activateObjectMode [
	self activeEditionMode: (WDELevelEditorViewObjectEditionMode for: self)
]

{ #category : 'editor modes' }
WDELevelEditorContentView >> activatePlacementMode [
	self activeEditionMode: (WDELevelEditorViewPlacementMode for: self)
]

{ #category : 'editor modes' }
WDELevelEditorContentView >> activateSculptingMode [
	self activeEditionMode: (WDELevelEditorViewSculptingMode for: self) withElements: (self model selectedItemsThatSupportModelingEditionMode: WDSculptEditionMode)
]

{ #category : 'shading' }
WDELevelEditorContentView >> activateShadedColor [
	camera viewMode: WDFlatColorShadedViewMode.
	self refresh
]

{ #category : 'editor modes' }
WDELevelEditorContentView >> activateTopologyEditionMode [
	self activeEditionMode: (WDELevelEditorViewTopologyEditionMode for: self) withElements: (self model selectedItemsThatSupportModelingEditionMode: WDTopologyEditionMode)
]

{ #category : 'shading' }
WDELevelEditorContentView >> activateWireFrame [
	camera viewMode: WDWireframeViewMode.
	self refresh
]

{ #category : 'editor modes' }
WDELevelEditorContentView >> activeEditionMode [
	activeEditionMode ifNil: [ self activateObjectMode ].
	^ activeEditionMode
]

{ #category : 'editor modes' }
WDELevelEditorContentView >> activeEditionMode: newEditionMode [
	| suppressManipulatorChanges |
	suppressManipulatorChanges := false.
	activeEditionMode ifNotNil: [
		activeEditionMode commitModeChanges.
		suppressManipulatorChanges := activeEditionMode doNotAffectManipulators
	].

	activeEditionMode := newEditionMode.
	suppressManipulatorChanges ifTrue: [ 
		self updateActiveToolStatusBarIndicator
	] ifFalse: [ 
		self activeToolModeOrEditionModeChanged.
	].

]

{ #category : 'editor modes' }
WDELevelEditorContentView >> activeEditionMode: newEditionMode withElements: newActiveEditionElements [
	activeEditionMode ifNotNil: [ activeEditionMode commitModeChanges ].
	newActiveEditionElements ifEmpty: [ ^ self ].
	self model
		activeEditionElements: newActiveEditionElements;
		selection: WDELevelEditorSelection empty.
	self activeEditionMode: newEditionMode
]

{ #category : 'enumerating' }
WDELevelEditorContentView >> activeManipulatorsDo: aBlock [
	activeToolManipulator ifNotNil: [ aBlock value: activeToolManipulator ].
	activeToolEditionElementsManipulator ifNotNil: [ aBlock value: activeToolEditionElementsManipulator ].
]

{ #category : 'accessing' }
WDELevelEditorContentView >> activeToolEditionElementsManipulator [
	^ activeToolEditionElementsManipulator
]

{ #category : 'accessing' }
WDELevelEditorContentView >> activeToolEditionElementsManipulator: newManipulator [
	activeToolEditionElementsManipulator ifNotNil: [
		activeToolEditionElementsManipulator removeFromScene.
		activeToolEditionElementsManipulator := nil.
	].

	activeToolEditionElementsManipulator := newManipulator.
	activeToolEditionElementsManipulator ifNotNil: [
		activeToolEditionElementsManipulator addToScene: scene.
		self highlightManipulator: nil; highlightElement: nil.
		activeToolEditionElementsManipulator updateForViewCamera
	].
	sceneView refresh.
]

{ #category : 'accessing' }
WDELevelEditorContentView >> activeToolManipulator [
	^ activeToolManipulator
]

{ #category : 'accessing' }
WDELevelEditorContentView >> activeToolManipulator: newManipulator [
	activeToolManipulator ifNotNil: [
		activeToolManipulator removeFromScene.
		activeToolManipulator := nil.
	].

	activeToolManipulator := newManipulator.
	activeToolManipulator ifNotNil: [
		activeToolManipulator addToScene: scene.
		self highlightManipulator: nil; highlightElement: nil.
		activeToolManipulator updateForViewCamera
	].
	sceneView refresh.
]

{ #category : 'editor modes' }
WDELevelEditorContentView >> activeToolMode: anObject [
	| suppressManipulatorChanges |
	suppressManipulatorChanges := false.
	activeToolMode ifNotNil: [
		suppressManipulatorChanges := activeToolMode doNotAffectManipulators
	].

	activeToolMode := anObject.
	suppressManipulatorChanges ifTrue: [ 
		self updateActiveToolStatusBarIndicator
	] ifFalse: [ 
		self activeToolModeOrEditionModeChanged.
	].

]

{ #category : 'editor modes' }
WDELevelEditorContentView >> activeToolModeOrEditionMode [
	^ activeToolMode ifNil: [ self activeEditionMode ]
]

{ #category : 'editor modes' }
WDELevelEditorContentView >> activeToolModeOrEditionModeChanged [
	self updateActiveToolStatusBarIndicator.
	self applyNewSelection: self model selection.
	self applyNewActiveEditionElements: self model activeEditionElements.
]

{ #category : 'as yet unclassified' }
WDELevelEditorContentView >> applyNewActiveEditionElements: newEditionElements [
	self activeToolModeOrEditionMode ifNotNil: [ :toolMode |
		toolMode doNotAffectManipulators ifTrue: [ ^ self ]
	].
	self activeToolEditionElementsManipulator: (self activeToolModeOrEditionMode ifNotNil: [:mode | mode manipulatorForActiveEditionElements: newEditionElements])

]

{ #category : 'as yet unclassified' }
WDELevelEditorContentView >> applyNewSelection: newSelection [
	self activeToolModeOrEditionMode ifNotNil: [ :toolMode |
		toolMode doNotAffectManipulators ifTrue: [ ^ self ]
	].
	self activeToolManipulator: (self activeToolModeOrEditionMode ifNotNil: [:mode | mode manipulatorForSelection: newSelection])

]

{ #category : 'camera views' }
WDELevelEditorContentView >> backView [
	camera isPerspective: false.
	gridOrientation := Quaternion lookAtBack.
	editorViewType := #back.
	self rotateCameraToAngles: (Vector3 y: Float pi).
]

{ #category : 'camera views' }
WDELevelEditorContentView >> bottomView [
	camera isPerspective: false.
	gridOrientation := Quaternion lookAtBottom.
	editorViewType := #bottom.
	self rotateCameraToAngles: (Vector3 x: Float halfPi).
]

{ #category : 'camera' }
WDELevelEditorContentView >> cameraFocalPoint [
	^ self validCameraTransform transformPosition: (Vector3 z: self cameraFocalPointDistance negated)
]

{ #category : 'camera' }
WDELevelEditorContentView >> cameraFocalPointDistance [
	| fov |
	fov := camera fovY.
	^ (viewScale / ((fov * 0.5) degreesToRadians tan))
]

{ #category : 'accessing' }
WDELevelEditorContentView >> cameraFrustum [
	| sceneExtent |
	sceneExtent := sceneView adapter extent.
	^ camera frustumWithAspect: sceneExtent x asFloat / (sceneExtent y max: 1)
]

{ #category : 'accessing' }
WDELevelEditorContentView >> cameraPosition [
	^ cameraNode position
]

{ #category : 'camera' }
WDELevelEditorContentView >> cameraProjectionMatrix [
	| sceneExtent |
	sceneExtent := sceneView adapter extent.
	^ camera projectionMatrixWithAspect: sceneExtent x asFloat / (sceneExtent y max: 1)
]

{ #category : 'camera' }
WDELevelEditorContentView >> cameraXYDeltaToWorld: screenDelta [
	^ self cameraXYDeltaToWorld: screenDelta distance: self cameraFocalPointDistance
]

{ #category : 'camera' }
WDELevelEditorContentView >> cameraXYDeltaToWorld: screenDelta distance: screenDistance [
	| depth cameraDelta |
	depth := self depthAtCameraDistance: screenDistance.
	cameraDelta := (self windowToLocal: screenDelta depth: depth) - (self windowToLocal: 0@0 depth: depth).
	^ (cameraDelta x * self xDragDirection) + (cameraDelta y * self yDragDirection)
]

{ #category : 'camera' }
WDELevelEditorContentView >> cameraXYToWorld: screenPosition [
	^ self cameraXYToWorld: screenPosition distance: self cameraFocalPointDistance
]

{ #category : 'camera' }
WDELevelEditorContentView >> cameraXYToWorld: screenPosition distance: screenDistance [
	| depth cameraPosition |
	depth := self depthAtCameraDistance: screenDistance.
	cameraPosition := (self screenToLocal: screenPosition depth: depth).
	^ cameraNode position +
	(cameraPosition x * self xDragDirection) + (cameraPosition y * self yDragDirection) + (screenDistance * self zDragDirection)
]

{ #category : 'camera' }
WDELevelEditorContentView >> cameraXZDeltaToWorld: screenDelta [
	^ self cameraXZDeltaToWorld: screenDelta distance: self cameraFocalPointDistance
]

{ #category : 'camera' }
WDELevelEditorContentView >> cameraXZDeltaToWorld: screenDelta distance: screenDistance [
	| depth cameraDelta |
	depth := self depthAtCameraDistance: screenDistance.
	cameraDelta := (self windowToLocal: screenDelta depth: depth) - (self windowToLocal: 0@0 depth: depth).
	^ (cameraDelta x * self xDragDirection) + (cameraDelta y * self zDragDirection)
]

{ #category : 'camera' }
WDELevelEditorContentView >> computeScreenDistanceForPoint: aPoint [
	^ (cameraNode transform inverseTransformPosition: aPoint) z negated
]

{ #category : 'camera' }
WDELevelEditorContentView >> computeScreenPositionForPoint: aPoint [
	| viewPoint ndcPoint projectedPoint sceneExtent sceneScreenPosition |
	sceneExtent := sceneView adapter extent.
	viewPoint := cameraNode transform inverseTransformPosition: aPoint.
	projectedPoint := self cameraProjectionMatrix * (Vector4 xyz: viewPoint w: 1.0).
	projectedPoint w = 0 ifTrue: [ ^ nil ].
	
	ndcPoint := (projectedPoint xyz / projectedPoint w) * 0.5 + 0.5.
	sceneScreenPosition := (ndcPoint x * sceneExtent x) @ ((1.0 - ndcPoint) y * sceneExtent y).
	^ sceneScreenPosition + self windowOrigin
]

{ #category : 'initialization' }
WDELevelEditorContentView >> createAxisNode [
	axisNode := WDELevelEditorMeshes uniqueInstance axisMesh asSceneNode.
	scene add: axisNode
]

{ #category : 'initialization' }
WDELevelEditorContentView >> createGridNode [
	| gridMaterial |
	gridMaterial := WDELevelEditorMeshes uniqueInstance gridMaterial copy colorFactor: Color gray lighter.
	gridNode := (WDELevelEditorMeshes uniqueInstance gridMesh copyWithMaterial: gridMaterial) asSceneNode.
	scene add: gridNode
]

{ #category : 'actions' }
WDELevelEditorContentView >> createLevelFileDialog [
	^ FileDialogWindow basicNew
		initialize;
		validExtensions: self level validExtensions;
		selectPath: self session gameSettings defaultMapsLocation;
		yourself
]

{ #category : 'initialization' }
WDELevelEditorContentView >> createScene [
	scene := WDScene new.
	self createSceneNodes
]

{ #category : 'initialization' }
WDELevelEditorContentView >> createSceneNodes [
	camera := WDCamera new
		isPerspective: false;
		viewMode: WDWireframeViewMode;
		yourself.
	cameraNode := camera asSceneNode.
	sceneView 
		scene: scene;
		camera: cameraNode.
	cameraNode
		orientation: Quaternion lookAtBottom;
		position: (Vector3 x: 0 y: 1 z: self cameraFocalPointDistance).
	scene add: cameraNode.
	editorViewType := #top.
	cameraLight := WDDirectionalLightSource new
		intensity: (Vector3 withAll: 0.3);
		yourself.
	cameraNode add: cameraLight asSceneNode.
	self
		createSubGridNode;
		createGridNode;
		createAxisNode.
	self updateCameraAndGrid
]

{ #category : 'initialization' }
WDELevelEditorContentView >> createSubGridNode [
	| gridMaterial |
	gridMaterial := WDELevelEditorMeshes uniqueInstance gridMaterial copy
		colorFactor: Color darkGray darker.
	subGridNode := (WDELevelEditorMeshes uniqueInstance subGridMesh copyWithMaterial: gridMaterial) asSceneNode.
	scene add: subGridNode.
]

{ #category : 'editor modes' }
WDELevelEditorContentView >> deactivatePlacementMode [
	self activeEditionMode isPlacementMode ifTrue: [ 
		self activateObjectMode
	].
]

{ #category : 'camera' }
WDELevelEditorContentView >> depthAtCameraDistance: distance [
	^ (distance - camera nearDistance) / (camera farDistance - camera nearDistance)
]

{ #category : 'as yet unclassified' }
WDELevelEditorContentView >> dragToolScreenOverlay: overlay [
	sceneView overlay: overlay
]

{ #category : 'as yet unclassified' }
WDELevelEditorContentView >> elementInPositionWithRayPicking: aPoint mode: modelingEditionMode [
	^ (self rayPickElement: (self rayForScreenPosition: aPoint) mode: modelingEditionMode)
]

{ #category : 'as yet unclassified' }
WDELevelEditorContentView >> elementsInPositionWithRayPicking: aPoint mode: modelingEditionMode [
	^ (self rayPickElements: (self rayForScreenPosition: aPoint) mode: modelingEditionMode) collect: [ :each | each value ]
]

{ #category : 'as yet unclassified' }
WDELevelEditorContentView >> elementsInScreenRectangle: screenRectangle [
	| originPosition cornerPosition normalizedScreenRectangleMin normalizedScreenRectangleMax selectionFrustum |
	originPosition := (self normalizeGlobalScreenPosition: screenRectangle origin) asVector2.
	cornerPosition := (self normalizeGlobalScreenPosition: screenRectangle corner) asVector2.
	normalizedScreenRectangleMin := ((originPosition min: cornerPosition) min: Vector2 ones) max: Vector2 zeros.
	normalizedScreenRectangleMax := ((originPosition max: cornerPosition) min: Vector2 ones) max: Vector2 zeros.
	
	selectionFrustum := ((self cameraFrustum splitAtLeftLambda: normalizedScreenRectangleMin x rightLambda: normalizedScreenRectangleMax x)
			splitAtBottomLambda: normalizedScreenRectangleMin y topLambda: normalizedScreenRectangleMax y)
			transformedWith: cameraNode globalTransform.
	^ self level elementsInFrustum: selectionFrustum
]

{ #category : 'actions' }
WDELevelEditorContentView >> exportAsGltf [
	| dialog result |
	dialog := self createLevelFileDialog.
	dialog
		title: 'Select the location to save the level';
		fileNameText: 'level.gltf';
		answerSaveFile.

	result := dialog openModal answer.
	result ifNil: [ ^ self ].
	self model exportToGltf: result asFileReference
]

{ #category : 'camera views' }
WDELevelEditorContentView >> freePerspectiveView [
	gridOrientation := Quaternion lookAtBottom.
	editorViewType := #free.
	self updateCameraAndGrid.
]

{ #category : 'camera views' }
WDELevelEditorContentView >> frontView [
	camera isPerspective: false.
	gridOrientation := Quaternion lookAtFront.
	editorViewType := #front.
	self rotateCameraToAngles: (Vector3 zeros).
]

{ #category : 'accessing' }
WDELevelEditorContentView >> gridSize [
	^ self model ifNil: [1.0 ] ifNotNil: [:m | m gridSize]
]

{ #category : 'testing' }
WDELevelEditorContentView >> hasFreeEditorViewType [
	^ editorViewType == #free
]

{ #category : 'as yet unclassified' }
WDELevelEditorContentView >> highlightElement: anElement [
	anElement ifNil: [
		highlightBoxNode ifNotNil: [ 
			highlightBoxNode removeFromScene
		].
	] ifNotNil: [
		"highlightBoxNode
			visible: true;
			color: WDELevelEditorTheme current highlightColor;
			transform: (anElement selectableBoundingBox withExpandedHalfExtent: 0.025) reversibleTransformToConvertUnitBoxToMe."
	].

	sceneView refresh.
]

{ #category : 'as yet unclassified' }
WDELevelEditorContentView >> highlightManipulator: aManipulator [
	highlightedManipulator ifNotNil: [ highlightedManipulator highlighted: false ].
	highlightedManipulator := aManipulator.
	highlightedManipulator ifNotNil: [ highlightedManipulator highlighted: true ].
]

{ #category : 'actions' }
WDELevelEditorContentView >> importFromGltf [
	| dialog result fileRef model |
	dialog := FileDialogWindow basicNew
		initialize;
		validExtensions: #(gltf glb);
		selectPath: self session gameSettings defaultMapsLocation;
		title: 'Select the gltf to import level';
		fileNameText: 'level.gltf';
		answerFileName.

	result := dialog openModal answer.
	result ifNil: [ ^ self ].
	
	fileRef := result asFileReference.
	fileRef extension = 'glb' ifTrue: [
		model := WDSRWGLTF2BinaryReadWriter readFromFileReference: fileRef.
	] ifFalse: [
		fileRef extension = 'gltf' ifFalse: [ self error: 'Unsupported non-gltf model for importing a level.'].
		model := WDSRWGLTF2ReadWriter readFromFileReference: fileRef.
	].

	self model importFromModelAsset: model
]

{ #category : 'initialization' }
WDELevelEditorContentView >> initialize [
	cameraAngle := Vector3 zeros.
	gridOrientation := Quaternion identity.
	viewScale := 20.0.
	super initialize.

]

{ #category : 'initialization' }
WDELevelEditorContentView >> initializePresenters [
	sceneView := self instantiate: WDSpScenePresenter.
	sceneView eventHandler
		whenKeyDownDo: [ :event | self onSceneKeyDown: event ];
		whenKeyUpDo: [ :event | self onSceneKeyUp: event ];
		whenDoubleClickDo: [ :event | self onSceneDoubleClick: event ];
		whenMouseDownDo: [ :event | self onSceneMouseDown: event ];
		whenMouseUpDo: [ :event | self onSceneMouseUp: event ];
		whenMouseMoveDo: [ :event | self onSceneMouseMove: event ];
		whenMouseWheelDo: [ :event | self onSceneMouseWheel: event ]
]

{ #category : 'testing' }
WDELevelEditorContentView >> isPerspective [
	^ camera isPerspective
]

{ #category : 'camera views' }
WDELevelEditorContentView >> leftView [
	camera isPerspective: false.
	gridOrientation := Quaternion lookAtLeft.
	editorViewType := #left.
	self rotateCameraToAngles: (Vector3 y: Float halfPi).
]

{ #category : 'initialization' }
WDELevelEditorContentView >> level [
	^ self model ifNotNil: [ :m | m level ]
]

{ #category : 'initialization' }
WDELevelEditorContentView >> levelChanged [
	self levelSceneChanged
]

{ #category : 'accessing' }
WDELevelEditorContentView >> levelEditorSession [
	^ self model
]

{ #category : 'initialization' }
WDELevelEditorContentView >> levelElementTemplateSelected: template [
	(template notNil and: [template canBePlacedInLevel]) ifTrue: [
		self activatePlacementMode
	] ifFalse: [
		self deactivatePlacementMode
	]

]

{ #category : 'initialization' }
WDELevelEditorContentView >> levelSceneChanged [
	self createScene.
	self level ifNotNil: [ :level |
		levelPresentationHandle := level modelingTree presentInScene: scene.
		levelPresentationHandle whenPresentationIsInvalidatedDo: [ self refresh ].
	].
]

{ #category : 'manipulators' }
WDELevelEditorContentView >> manipulatorInPositionWithRayPicking: aPoint [
	^ self rayPickManipulator: (self rayForScreenPosition: aPoint)
]

{ #category : 'manipulators' }
WDELevelEditorContentView >> manipulatorInScreenPosition: aPoint [
	^ self manipulatorInPositionWithRayPicking: aPoint
]

{ #category : 'initialization' }
WDELevelEditorContentView >> modelChanged [
	self model ifNotNil: [ :session |
		session
			whenActiveLevelElementTemplateChangedDo: [ :template | self levelElementTemplateSelected: template ];
			whenGridSizeChangedDo: [ self updateCameraAndGrid ];
			whenLevelChangedDoNow: [ self levelChanged ];
			whenStartingToPlaceDuplicatedItemsDo: [ :duplicatedItems :oldSelection |
				self startPlacingDuplicatedElements: duplicatedItems oldSelection: oldSelection
			];
			whenActiveEditionElementsChangedDo: [ :newActiveEditionElements | self applyNewActiveEditionElements: newActiveEditionElements ];
			whenSelectionChangedDo: [ :newSelection | self applyNewSelection: newSelection ].
	].
]

{ #category : 'camera' }
WDELevelEditorContentView >> normalizeGlobalScreenPosition: aPoint [
	^ self normalizeScreenPosition: aPoint - self windowOrigin
]

{ #category : 'camera' }
WDELevelEditorContentView >> normalizeScreenPosition: aPoint [
	| nx ny screenExtent |
	screenExtent := sceneView adapter extent.
	nx := aPoint x / screenExtent x asFloat.
	ny := 1.0 - (aPoint y / screenExtent y).
	^ nx @ ny
]

{ #category : 'camera' }
WDELevelEditorContentView >> normalizedToLocal: aPosition depth: aDepth [
	^ self cameraFrustum normalizedPoint: aPosition linearDepth: aDepth
]

{ #category : 'event' }
WDELevelEditorContentView >> onSceneDoubleClick: event [
	self activeToolModeOrEditionMode onDoubleClick: event
]

{ #category : 'event' }
WDELevelEditorContentView >> onSceneDrag: event delta: delta [
	self activeToolModeOrEditionMode onMouseDrag: event delta: delta
]

{ #category : 'event' }
WDELevelEditorContentView >> onSceneDragEnd: event [
	self activeToolModeOrEditionMode onMouseDragEnd: event

]

{ #category : 'event' }
WDELevelEditorContentView >> onSceneDragStart: event [
	self activeToolModeOrEditionMode onMouseDragStart: event

]

{ #category : 'event' }
WDELevelEditorContentView >> onSceneKeyDown: event [
	self activeToolModeOrEditionMode onKeyDown: event
]

{ #category : 'event' }
WDELevelEditorContentView >> onSceneKeyUp: event [
	self activeToolModeOrEditionMode onKeyUp: event
]

{ #category : 'event' }
WDELevelEditorContentView >> onSceneMouseDown: event [
	lastDownEvent := event.
	self activeToolModeOrEditionMode onMouseDown: event
]

{ #category : 'event' }
WDELevelEditorContentView >> onSceneMouseMove: event [
	sceneView takeKeyboardFocus.
	lastDragPosition ifNil: [
		(event isPrimaryButton or: [event isSecondaryButton or: [event isMiddleButton] ]) ifTrue: [
			lastDownEvent ifNil: [ lastDownEvent := event ].
			lastDragPosition := lastDownEvent position.
			self onSceneDragStart: lastDownEvent.
		].
	].

	lastDragPosition ifNotNil: [
		| delta |
		delta := event position - lastDragPosition.
		lastDragPosition := event position.
		self onSceneDrag: event delta: delta
	].

	self activeToolModeOrEditionMode onMouseMove: event
]

{ #category : 'event' }
WDELevelEditorContentView >> onSceneMouseUp: event [
	| wasDragging |
	wasDragging := false.
	lastDragPosition ifNotNil: [
		(event isPrimaryButton or: [event isSecondaryButton or: [event isMiddleButton] ]) ifFalse: [
			lastDragPosition := nil.
			self onSceneDragEnd: event.
			wasDragging := true
		].
	].
	self activeToolModeOrEditionMode onMouseUp: event.
	wasDragging ifTrue: [ ^ self ].
	
	lastDragPosition ifNil: [ 
		event redButtonChanged ifTrue: [ 
			self activeToolModeOrEditionMode onLeftClick: event.
		].
		event yellowButtonChanged ifTrue: [ 
			self activeToolModeOrEditionMode onRightClick: event.
		].
	].
]

{ #category : 'event' }
WDELevelEditorContentView >> onSceneMouseWheel: event [
	self activeToolModeOrEditionMode onMouseWheel: event
]

{ #category : 'as yet unclassified' }
WDELevelEditorContentView >> openShadingMenu [
	| menu |
	menu := SpMenuPresenter new.
	WDELevelEditor fillShadingMenu: menu viewBlock: [self].
	^ menu openWithSpecAtPointer
]

{ #category : 'camera views' }
WDELevelEditorContentView >> orthographicView [
	camera isPerspective: false.	
	self updateCameraAndGrid
]

{ #category : 'camera views' }
WDELevelEditorContentView >> perspectiveView [
	camera isPerspective: true.
	self updateCameraAndGrid
]

{ #category : 'camera' }
WDELevelEditorContentView >> placementFocalPointDistance [
	self session lastSelectionBox ifNotNil: [ :selectionBox |
		selectionBox isEmpty ifFalse: [ 
			| worldPlacementFocalPoint |
			worldPlacementFocalPoint := selectionBox center.
			^ self computeScreenDistanceForPoint: worldPlacementFocalPoint
		]
	].

	^ self cameraFocalPointDistance
]

{ #category : 'camera' }
WDELevelEditorContentView >> placementXYToWorld: screenPosition [
	^ self cameraXYToWorld: screenPosition distance: self placementFocalPointDistance
]

{ #category : 'manipulators' }
WDELevelEditorContentView >> rayCastForManipulator: ray [
	| bestResult |
	bestResult := nil.
	self activeManipulatorsDo: [ :each |
		(each rayCast: ray) ifNotNil: [ :result |
			(bestResult isNil or: [ result < bestResult ]) ifTrue: [ 
				bestResult := result
			]
		].
	].

	^ bestResult value
]

{ #category : 'manipulators' }
WDELevelEditorContentView >> rayForNormalizedPosition: aPoint [
	^ self worldRayAtWindowCoordinate: aPoint
]

{ #category : 'manipulators' }
WDELevelEditorContentView >> rayForScreenPosition: aPoint [
	^ self rayForNormalizedPosition: (self normalizeScreenPosition: aPoint - self windowOrigin)
]

{ #category : 'as yet unclassified' }
WDELevelEditorContentView >> rayPickElement: ray mode: modelingEditionMode [
	^ self model ifNil: [ nil ] ifNotNil: [ :m | m rayPickElement: ray mode: modelingEditionMode ]
]

{ #category : 'as yet unclassified' }
WDELevelEditorContentView >> rayPickElements: ray mode: modelingEditionMode [
	^ self model ifNil: [ #() ] ifNotNil: [ :m | m rayPickElements: ray mode: modelingEditionMode ]
]

{ #category : 'manipulators' }
WDELevelEditorContentView >> rayPickManipulator: ray [
	| distanceElement |
	distanceElement := self rayCastForManipulator: ray.
	^ distanceElement value ifNil: [ nil ]
]

{ #category : 'accessing' }
WDELevelEditorContentView >> refresh [
	self updateCamera.
	sceneView refresh
]

{ #category : 'camera views' }
WDELevelEditorContentView >> rightView [
	camera isPerspective: false.
	gridOrientation := Quaternion lookAtRight.
	editorViewType := #right.
	self rotateCameraToAngles: (Vector3 y: Float halfPi negated).
]

{ #category : 'camera' }
WDELevelEditorContentView >> rotateCameraInPlaceWithAngles: deltaAngles [
	cameraAngle := cameraAngle + deltaAngles.
	self updateCameraAndGrid.
]

{ #category : 'camera' }
WDELevelEditorContentView >> rotateCameraToAngles: newAngles [
	self rotateCameraToAngles: newAngles withFocalPoint: self cameraFocalPoint distance: self cameraFocalPointDistance
]

{ #category : 'camera' }
WDELevelEditorContentView >> rotateCameraToAngles: newAngles withFocalPoint: focalPoint distance: focalPointDistance [
	cameraAngle := newAngles.
	
	cameraNode position: (focalPoint + (self validCameraOrientation rotateVector: (Vector3 z: focalPointDistance))).
	self updateCameraAndGrid

]

{ #category : 'as yet unclassified' }
WDELevelEditorContentView >> rotateSelectedElements [
	^ self startActionDraggingOnCurrentSelectionWith: WDELevelEditorRotateToolMode
]

{ #category : 'as yet unclassified' }
WDELevelEditorContentView >> scaleSelectedElements [
	^ self startActionDraggingOnCurrentSelectionWith: WDELevelEditorScaleToolMode
]

{ #category : 'accessing' }
WDELevelEditorContentView >> scene [
	^ scene
]

{ #category : 'accessing' }
WDELevelEditorContentView >> sceneView [

	^ sceneView
]

{ #category : 'camera' }
WDELevelEditorContentView >> screenToLocal: aPosition depth: aDepth [
	^ self windowToLocal: aPosition - self windowOrigin depth: aDepth
]

{ #category : 'as yet unclassified' }
WDELevelEditorContentView >> selectedItemsBoundingBoxChanged [
	activeToolManipulator ifNotNil: [activeToolManipulator selectedItemsBoundingBoxChanged]
]

{ #category : 'accessing' }
WDELevelEditorContentView >> session [
	^ self model
]

{ #category : 'initialization' }
WDELevelEditorContentView >> setSelectedElements: elements [
	^ self levelEditorSession setSelectedElements: elements
]

{ #category : 'as yet unclassified' }
WDELevelEditorContentView >> startActionDraggingOnCurrentSelectionWith: toolModeClass [
	| currentSelection |
	currentSelection := self model selection.
	currentSelection selectedItems ifEmpty: [ ^ self ].
	
	self activeToolMode: ((toolModeClass for: self)
		elements: currentSelection selectedItems;
		yourself)
]

{ #category : 'as yet unclassified' }
WDELevelEditorContentView >> startPlacingDuplicatedElements: duplicatedElements oldSelection: oldSelection [
	self activeToolMode: ((WDELevelEditorDuplicatePlacementToolMode for: self)
		duplicatedElements: duplicatedElements;
		oldSelection: oldSelection;
		yourself)
]

{ #category : 'camera views' }
WDELevelEditorContentView >> togglePerspective [
	camera isPerspective: camera isPerspective not.
	self updateCameraAndGrid
]

{ #category : 'camera views' }
WDELevelEditorContentView >> topView [
	camera isPerspective: false.
	gridOrientation := Quaternion lookAtBottom.
	editorViewType := #top.
	self rotateCameraToAngles: (Vector3 x: Float halfPi negated).
]

{ #category : 'camera' }
WDELevelEditorContentView >> translateCameraBy: translation [
	cameraNode translateBy: translation.
	self updateCameraAndGrid.
]

{ #category : 'as yet unclassified' }
WDELevelEditorContentView >> translateSelectedElements [
	^ self startActionDraggingOnCurrentSelectionWith: WDELevelEditorTranslateToolMode
]

{ #category : 'editor modes' }
WDELevelEditorContentView >> updateActiveToolStatusBarIndicator [
	self model ifNotNil: [ :m | m activeToolModeOrEditionModeName: self activeToolModeOrEditionMode modeName ]
]

{ #category : 'camera' }
WDELevelEditorContentView >> updateCamera [
	| level |
	cameraNode orientation: self validCameraOrientation.
	camera focalDistance: self cameraFocalPointDistance.
	camera isPerspective ifTrue: [ 
		camera
			nearDistance: PerspectiveNearDistance;
			farDistance: PerspectiveFarDistance
	] ifFalse: [ 
		camera
			nearDistance: OrthographicNearDistance;
			farDistance: OrthographicFarDistance
	].

	level := self session level modelingTree.
	camera
		fogColor: level fogColor;
		fogStartDistance: level fogStartDistance;
		fogEndDistance: level fogEndDistance;
		fogDensity: level fogDensity;
		fogMode: level fogModeObject

]

{ #category : 'camera' }
WDELevelEditorContentView >> updateCameraAndGrid [
	self
		updateCamera;
		updateGrid;
		updateManipulatorsForCamera.
	sceneView refresh
]

{ #category : 'camera' }
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

{ #category : 'camera' }
WDELevelEditorContentView >> updateManipulatorsForCamera [
	self activeToolManipulator ifNotNil: [:manip | manip updateForViewCamera]
]

{ #category : 'camera' }
WDELevelEditorContentView >> validCameraOrientation [
	^ (Quaternion yRotation: cameraAngle y) * (Quaternion xRotation: cameraAngle x)
]

{ #category : 'camera' }
WDELevelEditorContentView >> validCameraTransform [
	^ TRSTransform3D identity
		rotation: self validCameraOrientation;
		translation: cameraNode position;
		yourself
]

{ #category : 'accessing' }
WDELevelEditorContentView >> viewScale [
	^ viewScale
]

{ #category : 'accessing' }
WDELevelEditorContentView >> viewScale: newViewScale [
	| oldFocalPoint |
	oldFocalPoint := self cameraFocalPoint.
	viewScale := newViewScale.
	self rotateCameraToAngles: cameraAngle withFocalPoint: oldFocalPoint distance: self cameraFocalPointDistance
]

{ #category : 'camera' }
WDELevelEditorContentView >> windowOrigin [
	^ sceneView adapter widget bounds origin
]

{ #category : 'camera' }
WDELevelEditorContentView >> windowToLocal: aPosition depth: aDepth [
	^ self normalizedToLocal: (self normalizeScreenPosition: aPosition) depth: aDepth
]

{ #category : 'manipulators' }
WDELevelEditorContentView >> worldRayAtWindowCoordinate: point [
	| ray frustum |
	frustum := self cameraFrustum.
	frustum leftBottomFar ifNil: [ ^ nil ].
	
	ray := frustum rayForNormalizedPoint: point.
	^ ray transformedWith: cameraNode transform
]

{ #category : 'camera' }
WDELevelEditorContentView >> xDragDirection [
	^ cameraNode orientation rotateVector: (Vector3 x: 1)
]

{ #category : 'camera' }
WDELevelEditorContentView >> xyDragDirection [
	^ self xDragDirection + self yDragDirection
]

{ #category : 'camera' }
WDELevelEditorContentView >> yDragDirection [
	^ cameraNode orientation rotateVector: (Vector3 y: 1)
]

{ #category : 'camera' }
WDELevelEditorContentView >> zDragDirection [
	^ cameraNode orientation rotateVector: (Vector3 z: -1)
]
