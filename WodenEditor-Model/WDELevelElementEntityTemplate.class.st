Class {
	#name : #WDELevelElementEntityTemplate,
	#superclass : #WDELevelElementTemplate,
	#instVars : [
		'prototype'
	],
	#category : #'WodenEditor-Model-Palette'
}

{ #category : #'as yet unclassified' }
WDELevelElementEntityTemplate >> instantiateInLevel: level placingInBox: placementBox session: session [
	| oldSelection element |
	oldSelection := session selection.
	session
		doWith: [
			element := prototype instantiateForPlacingInLevel: level box: placementBox.
			session selection: (WDELevelEditorSelection for: {element}).
		]
		undoWith: [
			session selection: oldSelection.
			element removeFromParent.
		].
	^ true
]

{ #category : #'as yet unclassified' }
WDELevelElementEntityTemplate >> instantiateInLevel: level placingInPoint: placementPoint session: session [
	| oldSelection element |
	oldSelection := session selection.
	session
		doWith: [
			element := prototype instantiateForPlacingInLevel: level point: placementPoint.
			session selection: (WDELevelEditorSelection for: {element}).
		]
		undoWith: [
			session selection: oldSelection.
			element removeFromParent.
		].
	^ true
]

{ #category : #testing }
WDELevelElementEntityTemplate >> isPointElementTemplate [
	^ false
]

{ #category : #accessing }
WDELevelElementEntityTemplate >> prototype [
	^ prototype
]

{ #category : #accessing }
WDELevelElementEntityTemplate >> prototype: anObject [
	prototype := anObject
]
