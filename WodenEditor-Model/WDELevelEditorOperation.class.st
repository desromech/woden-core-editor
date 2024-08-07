Class {
	#name : 'WDELevelEditorOperation',
	#superclass : 'Object',
	#instVars : [
		'doBlock',
		'undoBlock'
	],
	#category : 'WodenEditor-Model-Session',
	#package : 'WodenEditor-Model',
	#tag : 'Session'
}

{ #category : 'construction' }
WDELevelEditorOperation class >> doWith: doBlock undoWith: undoBlock [
	^ self new
		doBlock: doBlock;
		undoBlock: undoBlock;
		yourself
]

{ #category : 'accessing' }
WDELevelEditorOperation >> doBlock [

	^ doBlock
]

{ #category : 'accessing' }
WDELevelEditorOperation >> doBlock: anObject [

	doBlock := anObject
]

{ #category : 'do-its' }
WDELevelEditorOperation >> doIt [
	^ doBlock value
]

{ #category : 'accessing' }
WDELevelEditorOperation >> undoBlock [

	^ undoBlock
]

{ #category : 'accessing' }
WDELevelEditorOperation >> undoBlock: anObject [

	undoBlock := anObject
]

{ #category : 'do-its' }
WDELevelEditorOperation >> undoIt [
	^ undoBlock value
]
