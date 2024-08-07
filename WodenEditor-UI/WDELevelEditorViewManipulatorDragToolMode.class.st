Class {
	#name : 'WDELevelEditorViewManipulatorDragToolMode',
	#superclass : 'WDELevelEditorViewDragToolMode',
	#instVars : [
		'manipulator',
		'memento',
		'dragScreenDistance'
	],
	#category : 'WodenEditor-UI-ViewMode',
	#package : 'WodenEditor-UI',
	#tag : 'ViewMode'
}

{ #category : 'as yet unclassified' }
WDELevelEditorViewManipulatorDragToolMode >> doNotAffectManipulators [
	^ true
]

{ #category : 'initialization' }
WDELevelEditorViewManipulatorDragToolMode >> dragStartedWith: startEvent [
	super dragStartedWith: startEvent.
	memento := manipulator mementoForDragging.
	manipulator boundingBox isEmpty ifFalse: [
		dragScreenDistance := view computeScreenDistanceForPoint: manipulator boundingBox center
	]
]

{ #category : 'initialization' }
WDELevelEditorViewManipulatorDragToolMode >> initialize [
	super initialize.
	dragScreenDistance := 3.0.
]

{ #category : 'accessing' }
WDELevelEditorViewManipulatorDragToolMode >> manipulator [
	^ manipulator
]

{ #category : 'accessing' }
WDELevelEditorViewManipulatorDragToolMode >> manipulator: aManipulator [
	manipulator := aManipulator
]
