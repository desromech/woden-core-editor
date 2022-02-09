Class {
	#name : #WDELevelEditorDragRectangleOverlay,
	#superclass : #WDELevelEditorScreenOverlay,
	#instVars : [
		'color',
		'rectangle'
	],
	#category : #'WodenEditor-UI-Overlay'
}

{ #category : #drawing }
WDELevelEditorDragRectangleOverlay >> buildSceneGraphWith: builder [
	^ builder borderRectangle: rectangle color: color width: 1
]

{ #category : #accessing }
WDELevelEditorDragRectangleOverlay >> color [

	^ color
]

{ #category : #accessing }
WDELevelEditorDragRectangleOverlay >> color: anObject [

	color := anObject
]

{ #category : #drawing }
WDELevelEditorDragRectangleOverlay >> drawOn: aCanvas [
]

{ #category : #accessing }
WDELevelEditorDragRectangleOverlay >> rectangle [

	^ rectangle
]

{ #category : #accessing }
WDELevelEditorDragRectangleOverlay >> rectangle: anObject [

	rectangle := anObject
]
