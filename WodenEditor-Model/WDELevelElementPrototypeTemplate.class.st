Class {
	#name : #WDELevelElementPrototypeTemplate,
	#superclass : #WDELevelElementTemplate,
	#instVars : [
		'prototype'
	],
	#category : #'WodenEditor-Model-Palette'
}

{ #category : #'as yet unclassified' }
WDELevelElementPrototypeTemplate >> instantiateInLevel: level placingInBox: placementBox session: session [
	| oldSelection element |
	oldSelection := session selection.
	session
		doWith: [
			element := prototype instantiateForPlacingIn: (level activeGroupForInstantiating: prototype) box: placementBox.
			session selection: (WDELevelEditorSelection for: {element}).
		]
		undoWith: [
			session selection: oldSelection.
			element removeFromParent.
		].
	^ true
]

{ #category : #'as yet unclassified' }
WDELevelElementPrototypeTemplate >> instantiateInLevel: level placingInPoint: placementPoint session: session [
	| oldSelection element |
	oldSelection := session selection.
	session
		doWith: [
			element := prototype instantiateForPlacingIn: (level activeGroupForInstantiating: prototype) point: placementPoint.
			session selection: (WDELevelEditorSelection for: {element}).
		]
		undoWith: [
			session selection: oldSelection.
			element removeFromParent.
		].
	^ true
]

{ #category : #testing }
WDELevelElementPrototypeTemplate >> isPointElementTemplate [
	^ prototype isPointPlacedElement
]

{ #category : #accessing }
WDELevelElementPrototypeTemplate >> prototype [
	^ prototype
]

{ #category : #accessing }
WDELevelElementPrototypeTemplate >> prototype: anObject [
	prototype := anObject
]
