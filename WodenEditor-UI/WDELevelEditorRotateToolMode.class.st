Class {
	#name : 'WDELevelEditorRotateToolMode',
	#superclass : 'WDELevelEditorSelectionTransformToolMode',
	#instVars : [
		'transformStateMementos'
	],
	#category : 'WodenEditor-UI-ViewMode',
	#package : 'WodenEditor-UI',
	#tag : 'ViewMode'
}

{ #category : 'as yet unclassified' }
WDELevelEditorRotateToolMode >> applyTransformToElements [
	| transform su sv axis angle |
	currentPosition ifNil: [ ^ self ].
	screenPivot ifNil: [ ^ self ].

	su := (startPosition - screenPivot) asWMComplex normalized.
	sv := (currentPosition - screenPivot) asWMComplex normalized.
	
	axis := view zDragDirection.
	angle := (sv * su inverse) arg.
	selectedAxis ifNotNil: [
		axis := selectedAxis
	].

	transform := TRSTransform3D rotation: (Quaternion axis: axis angle: angle) around: pivot.
	self restoreMementos.
	elements do: [ :each | each transformWith: transform ].
	view selectedItemsBoundingBoxChanged; refresh.
]

{ #category : 'accessing' }
WDELevelEditorRotateToolMode >> modeName [
	^ 'Rotate elements'
]

{ #category : 'as yet unclassified' }
WDELevelEditorRotateToolMode >> restoreMementos [
	elements doWithIndex: [ :element :index |
		element restoreTransformStateMemento: (transformStateMementos at: index)
	]
]

{ #category : 'accessing' }
WDELevelEditorRotateToolMode >> storeMementos [
	transformStateMementos := elements collect: [ :each | each transformStateMemento ].
]
