Class {
	#name : #WDELevelEditor3DSelectionManipulator,
	#superclass : #WDELevelEditor3DBoxManipulator,
	#instVars : [
		'selectedElements'
	],
	#category : #'WodenEditor-UI-Manipulators'
}

{ #category : #accessing }
WDELevelEditor3DSelectionManipulator >> selectedElements [

	^ selectedElements
]

{ #category : #accessing }
WDELevelEditor3DSelectionManipulator >> selectedElements: anObject [

	selectedElements := anObject
]
