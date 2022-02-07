Class {
	#name : #WDELevelEditorScaleToolMode,
	#superclass : #WDELevelEditorSelectionTransformToolMode,
	#instVars : [
		'transformStateMementos'
	],
	#category : #'WodenEditor-UI-ViewMode'
}

{ #category : #'as yet unclassified' }
WDELevelEditorScaleToolMode >> applyTransformToElements [
	| transform worldStartPosition worldEndPosition scaleFactor scaleFactorVector |
	currentPosition ifNil: [ ^ self ].
	
	worldStartPosition := view cameraXYToWorld: startPosition distance: screenDistance.
	worldEndPosition := view cameraXYToWorld: currentPosition distance: screenDistance.
	
	scaleFactor := (worldEndPosition - pivot) length / ((worldStartPosition - pivot) length max: 0.0001).
	scaleFactorVector := Vector3 withAll: scaleFactor.
	selectedAxis ifNotNil: [
		scaleFactorVector := scaleFactor * selectedAxis + (Vector3 ones - selectedAxis)
	].
	
	transform := TRSTransform3D scale: scaleFactorVector around: pivot.
	self restoreMementos.
	elements do: [ :each | each transformWith: transform ].
	view selectedItemsBoundingBoxChanged; refresh.
]

{ #category : #accessing }
WDELevelEditorScaleToolMode >> modeName [
	^ 'Scale elements'
]

{ #category : #'as yet unclassified' }
WDELevelEditorScaleToolMode >> restoreMementos [
	elements doWithIndex: [ :element :index |
		element restoreTransformStateMemento: (transformStateMementos at: index)
	]
]

{ #category : #'as yet unclassified' }
WDELevelEditorScaleToolMode >> storeMementos [
	transformStateMementos := elements collect: [ :each | each transformStateMemento ].
]
