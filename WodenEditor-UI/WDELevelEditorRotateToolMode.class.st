Class {
	#name : #WDELevelEditorRotateToolMode,
	#superclass : #WDELevelEditorSelectionTransformToolMode,
	#instVars : [
		'transformStateMementos'
	],
	#category : #'WodenEditor-UI-ViewMode'
}

{ #category : #'as yet unclassified' }
WDELevelEditorRotateToolMode >> applyTransformToElements [
	| transform worldStartPosition worldEndPosition u v axis angle |
	currentPosition ifNil: [ ^ self ].
	
	worldStartPosition := view cameraXYToWorld: startPosition distance: screenDistance.
	worldEndPosition := view cameraXYToWorld: currentPosition distance: screenDistance.
	
	u := (worldStartPosition - pivot) normalized.
	v := (worldEndPosition - pivot) normalized.
	
	axis := (u cross: v) normalized.
	angle := (u dot: v) arcCos.
	selectedAxis ifNotNil: [
		axis := selectedAxis
	].
	
	transform := TRSTransform3D rotation: (Quaternion axis: axis angle: angle).
	self restoreMementos.
	elements do: [ :each | each transformWith: transform ].
	view selectedItemsBoundingBoxChanged; refresh.
]

{ #category : #accessing }
WDELevelEditorRotateToolMode >> modeName [
	^ 'Rotate elements'
]

{ #category : #'as yet unclassified' }
WDELevelEditorRotateToolMode >> restoreMementos [
	elements doWithIndex: [ :element :index |
		element restoreTransformStateMemento: (transformStateMementos at: index)
	]
]

{ #category : #accessing }
WDELevelEditorRotateToolMode >> storeMementos [
	transformStateMementos := elements collect: [ :each | each transformStateMemento ].
]
