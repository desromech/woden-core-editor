Class {
	#name : #WDELevelEditor3DSelectionManipulator,
	#superclass : #WDELevelEditor3DBoxManipulator,
	#instVars : [
		'selectedElements',
		'displayBoundingBox'
	],
	#category : #'WodenEditor-UI-Manipulators'
}

{ #category : #'element manipulation' }
WDELevelEditor3DSelectionManipulator >> applyTransform: transform [
	selectedElements do: [ :each |
		each transformWith: transform
	].
	self computeBoundingBoxes.
]

{ #category : #'element manipulation' }
WDELevelEditor3DSelectionManipulator >> applyTransformForTranslationDelta: translation [
	selectedElements do: [ :each |
		each translateBy: translation
	].
	self computeBoundingBoxes.
]

{ #category : #accessing }
WDELevelEditor3DSelectionManipulator >> computeBoundingBoxes [
	boundingBox := AABox empty.
	displayBoundingBox := AABox empty.
	selectedElements do: [ :each |
		boundingBox insertBox: each globalBoundingBox.
		displayBoundingBox insertBox: each selectableGlobalBoundingBox.
	].
	displayBoundingBox isEmpty ifFalse: [ displayBoundingBox := displayBoundingBox withExpandedHalfExtent: 0.025 ].
	
	self boundingBoxChanged.
]

{ #category : #accessing }
WDELevelEditor3DSelectionManipulator >> displayBoundingBox [
	^ displayBoundingBox
]

{ #category : #memento }
WDELevelEditor3DSelectionManipulator >> positionStateMemento [
	^ { super positionStateMemento . selectedElements collect: [ :each | each positionStateMemento ]}
]

{ #category : #memento }
WDELevelEditor3DSelectionManipulator >> restoreMementoForDragging: memento [
	^ self restorePositionStateMemento: memento
]

{ #category : #memento }
WDELevelEditor3DSelectionManipulator >> restorePositionStateMemento: memento [
	| elementsMemento |
	super restorePositionStateMemento: memento first.
	elementsMemento := memento second.
	self assert: elementsMemento size = selectedElements size.
	selectedElements doWithIndex: [ :each :index |
		each restorePositionStateMemento: (elementsMemento at: index)
	].
]

{ #category : #memento }
WDELevelEditor3DSelectionManipulator >> restoreTransformStateMemento: memento [
	| superMemento myMemento elementsMemento |
	superMemento := super restoreTransformStateMemento: memento first.
	myMemento := memento second.
	elementsMemento := memento second.
	self assert: elementsMemento size = selectedElements size.
	selectedElements doWithIndex: [ :each :index |
		each restoreTransformStateMemento: (elementsMemento at: index)
	].		
]

{ #category : #accessing }
WDELevelEditor3DSelectionManipulator >> selectedElements [

	^ selectedElements
]

{ #category : #accessing }
WDELevelEditor3DSelectionManipulator >> selectedElements: anObject [
	selectedElements := anObject.
	self computeBoundingBoxes
]

{ #category : #'as yet unclassified' }
WDELevelEditor3DSelectionManipulator >> selectedItemsBoundingBoxChanged [
	self computeBoundingBoxes
]

{ #category : #memento }
WDELevelEditor3DSelectionManipulator >> transformStateMemento [
	^ {
		super transformStateMemento.
		selectedElements collect: [ :each | each transformStateMemento ]
	}
]
