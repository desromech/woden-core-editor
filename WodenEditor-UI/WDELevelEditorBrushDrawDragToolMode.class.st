Class {
	#name : 'WDELevelEditorBrushDrawDragToolMode',
	#superclass : 'WDELevelEditorViewDragToolMode',
	#instVars : [
		'sceneNode'
	],
	#category : 'WodenEditor-UI-ViewMode',
	#package : 'WodenEditor-UI',
	#tag : 'ViewMode'
}

{ #category : 'as yet unclassified' }
WDELevelEditorBrushDrawDragToolMode >> applyBoxToSceneNode: box [
	sceneNode ifNil: [ self createSceneNode ].
	sceneNode
		transform: box trsTransformToConvertUnitBoxToMe.
	view refresh.
]

{ #category : 'as yet unclassified' }
WDELevelEditorBrushDrawDragToolMode >> computeBoxWithScreenEndPoint: screenEndPoint [
	| dragMinDistance startPosition endPosition dragMaxDistance box |
	dragMinDistance := view placementFocalPointDistance - 0.5.
	dragMaxDistance := dragMinDistance + 1.0.
	startPosition := view cameraXYToWorld: dragStartPosition distance: dragMinDistance.
	endPosition := view cameraXYToWorld: screenEndPoint distance: dragMaxDistance.
	box := AABox min: (startPosition min: endPosition) max: (startPosition max: endPosition).

	box min: (self levelEditorSession snapToSubGrid: box min).
	box max: (self levelEditorSession snapToSubGrid: box max).
	^ box
]

{ #category : 'as yet unclassified' }
WDELevelEditorBrushDrawDragToolMode >> createSceneNode [
	sceneNode := WDELevelEditorMeshes uniqueInstance flatShadedTranslucentUnitCubeMesh asSceneNode.
	self scene add: sceneNode
]

{ #category : 'as yet unclassified' }
WDELevelEditorBrushDrawDragToolMode >> finishDraggingWith: event [
	| box |
	super finishDraggingWith: event.
	sceneNode ifNotNil: [ sceneNode removeFromScene ].
	box := self computeBoxWithScreenEndPoint: dragEndPosition.
	(box isEmpty not and: [ box width > 0 and: [ box height > 0 and: [ box depth > 0 ] ] ]) ifTrue: [ 
		view activeToolManipulator: ((WDELevelEditor3DBoxPlacementManipulator for: view)
			boundingBox: box;
			yourself)
	] ifFalse: [
		view activeToolManipulator: nil
	].

]

{ #category : 'accessing' }
WDELevelEditorBrushDrawDragToolMode >> modeName [
	^ 'Brush drawing'
]

{ #category : 'as yet unclassified' }
WDELevelEditorBrushDrawDragToolMode >> onMouseDrag: event delta: delta [
	| box |
	super onMouseDrag: event delta: delta.
	box := self computeBoxWithScreenEndPoint: event position.
	self applyBoxToSceneNode: box.

]
