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
