Class {
	#name : #WDELevelEditor3DBoxManipulator,
	#superclass : #WDELevelEditor3DManipulator,
	#instVars : [
		'material'
	],
	#category : #'WodenEditor-UI-Manipulators'
}

{ #category : #'as yet unclassified' }
WDELevelEditor3DBoxManipulator >> applyHighlightingEffect [
	material ifNotNil: [
		material colorFactor: self currentColor.
		view refresh
	]
]

{ #category : #private }
WDELevelEditor3DBoxManipulator >> applyTransform: transform [
	self boundingBox: (boundingBox transformedWith: transform)
]

{ #category : #private }
WDELevelEditor3DBoxManipulator >> applyTransformForTranslationDelta: translation [
	self boundingBox: (boundingBox translatedBy: translation)
]

{ #category : #accessing }
WDELevelEditor3DBoxManipulator >> boundingBox: newBoundingBox [
	boundingBox := newBoundingBox.
	self boundingBoxChanged
]

{ #category : #'as yet unclassified' }
WDELevelEditor3DBoxManipulator >> boundingBoxChanged [ 
	sceneNode ifNotNil: [
		sceneNode transform: self displayBoundingBox trsTransformToConvertUnitBoxToMe
	].
	 
	boundingBox isEmpty ifFalse: [
		self buildCornerManipulators
	]
]

{ #category : #'as yet unclassified' }
WDELevelEditor3DBoxManipulator >> buildCornerManipulators [
	| points |
	points := self computeManipulationPoints.
	children size = points size ifFalse: [
		self children: (points
			collect: [ :corner | WDELevelEditor3DBoxCornerHandle for: view]
			as: Array)
	].
	
	points doWithIndex: [ :point :index |
		(children at: index) position: point
	]
	
]

{ #category : #'as yet unclassified' }
WDELevelEditor3DBoxManipulator >> computeManipulationPoints [
	^ boundingBox manipulationPoints
]

{ #category : #scene }
WDELevelEditor3DBoxManipulator >> createSceneNode [
	self displayBoundingBox isEmpty ifTrue: [ ^ nil ].
	material := WDUnlitMaterial new
		xray: true;
		alphaMode: #BLEND;
		colorFactor: self currentColor;
		yourself.
	^ (WDELevelEditorMeshes uniqueInstance flatShadedTranslucentUnitCubeMesh copyWithMaterial: material) asSceneNode
		transform: self displayBoundingBox trsTransformToConvertUnitBoxToMe;
		yourself
]

{ #category : #'brick-properties' }
WDELevelEditor3DBoxManipulator >> currentColor [
	^ highlighted
		ifTrue: [ self editorTheme highlightedBoxManipulatorColor  ]
		ifFalse: [ self editorTheme boxManipulatorColor ]
]

{ #category : #'as yet unclassified' }
WDELevelEditor3DBoxManipulator >> currentDragToolClass [
	^ WDELevelEditorViewTranslateManipulatorDragToolMode
]

{ #category : #'as yet unclassified' }
WDELevelEditor3DBoxManipulator >> displayBoundingBox [
	^ boundingBox
]

{ #category : #memento }
WDELevelEditor3DBoxManipulator >> mementoForDragging [
	^ self positionStateMemento
]

{ #category : #memento }
WDELevelEditor3DBoxManipulator >> positionStateMemento [
	^ boundingBox
]

{ #category : #memento }
WDELevelEditor3DBoxManipulator >> restoreMementoForDragging: memento [
	^ self restorePositionStateMemento: memento
]

{ #category : #memento }
WDELevelEditor3DBoxManipulator >> restorePositionStateMemento: memento [
	boundingBox := memento
]

{ #category : #memento }
WDELevelEditor3DBoxManipulator >> restoreTransformStateMemento: memento [
	boundingBox := memento
]

{ #category : #memento }
WDELevelEditor3DBoxManipulator >> transformStateMemento [
	^ boundingBox
]
