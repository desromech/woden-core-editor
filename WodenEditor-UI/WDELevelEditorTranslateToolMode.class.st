Class {
	#name : #WDELevelEditorTranslateToolMode,
	#superclass : #WDELevelEditorSelectionTransformToolMode,
	#instVars : [
		'positionStateMementos'
	],
	#category : #'WodenEditor-UI-ViewMode'
}

{ #category : #'as yet unclassified' }
WDELevelEditorTranslateToolMode >> applyTransformToElements [
	| translation |
	currentPosition ifNil: [ ^ self ].
	
	translation := self levelEditorSession snapToSubGrid: (view cameraXYDeltaToWorld: currentPosition - startPosition distance: screenDistance).
	selectedAxis ifNotNil: [ 
		translation := translation * selectedAxis
	].

	self restoreMementos.
	elements do: [ :each | each translateBy: translation ].
	view selectedItemsBoundingBoxChanged; refresh.
]

{ #category : #accessing }
WDELevelEditorTranslateToolMode >> modeName [
	^ 'Translate elements'
]

{ #category : #'as yet unclassified' }
WDELevelEditorTranslateToolMode >> restoreMementos [
	elements doWithIndex: [ :element :index |
		element restorePositionStateMemento: (positionStateMementos at: index)
	]
]

{ #category : #accessing }
WDELevelEditorTranslateToolMode >> storeMementos [
	positionStateMementos := elements collect: [ :each | each positionStateMemento ].
]
