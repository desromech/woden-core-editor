Class {
	#name : 'WDELevelEditorViewMode',
	#superclass : 'Object',
	#instVars : [
		'view',
		'shortcutList'
	],
	#category : 'WodenEditor-UI-ViewMode',
	#package : 'WodenEditor-UI',
	#tag : 'ViewMode'
}

{ #category : 'instance creation' }
WDELevelEditorViewMode class >> for: aView [
	^ self new view: aView; yourself
]

{ #category : 'as yet unclassified' }
WDELevelEditorViewMode >> commitModeChanges [
]

{ #category : 'as yet unclassified' }
WDELevelEditorViewMode >> doNotAffectManipulators [
	^ false
]

{ #category : 'testing' }
WDELevelEditorViewMode >> isPlacementMode [
	^ false
]

{ #category : 'accessing' }
WDELevelEditorViewMode >> levelEditorSession [
	^ view levelEditorSession
]

{ #category : 'as yet unclassified' }
WDELevelEditorViewMode >> manipulatorForActiveEditionElements: selection [
	^ nil
]

{ #category : 'as yet unclassified' }
WDELevelEditorViewMode >> manipulatorForSelection: selection [
	^ nil
]

{ #category : 'accessing' }
WDELevelEditorViewMode >> modeName [
	self subclassResponsibility
]

{ #category : 'accessing' }
WDELevelEditorViewMode >> model [
	^ view model
]

{ #category : 'event' }
WDELevelEditorViewMode >> onDoubleClick: event [
]

{ #category : 'event' }
WDELevelEditorViewMode >> onKeyDown: event [
	| eventCombination |
	eventCombination := event asKeyCombination.
	self shortcutList pairsDo: [ :shortcut :action |
		(shortcut matchesCompletely: eventCombination) ifTrue: [
			^ action value
		]
	]
]

{ #category : 'event' }
WDELevelEditorViewMode >> onKeyUp: event [
]

{ #category : 'event' }
WDELevelEditorViewMode >> onLeftClick: event [
]

{ #category : 'event' }
WDELevelEditorViewMode >> onMiddleClick: event [
]

{ #category : 'event' }
WDELevelEditorViewMode >> onMouseDown: event [
]

{ #category : 'event' }
WDELevelEditorViewMode >> onMouseDrag: event delta: delta [
]

{ #category : 'event' }
WDELevelEditorViewMode >> onMouseDragEnd: event [
]

{ #category : 'event' }
WDELevelEditorViewMode >> onMouseDragStart: event [
]

{ #category : 'event' }
WDELevelEditorViewMode >> onMouseMove: event [
]

{ #category : 'event' }
WDELevelEditorViewMode >> onMouseUp: event [
]

{ #category : 'event' }
WDELevelEditorViewMode >> onMouseWheel: event [
]

{ #category : 'event' }
WDELevelEditorViewMode >> onRightClick: event [
]

{ #category : 'accessing' }
WDELevelEditorViewMode >> scene [
	^ view scene
]

{ #category : 'accessing' }
WDELevelEditorViewMode >> shortcutList [
	^ shortcutList ifNil: [ shortcutList := self shortcuts ]
]

{ #category : 'as yet unclassified' }
WDELevelEditorViewMode >> shortcuts [
	^ #()
]

{ #category : 'accessing' }
WDELevelEditorViewMode >> view [

	^ view
]

{ #category : 'accessing' }
WDELevelEditorViewMode >> view: anObject [

	view := anObject
]
