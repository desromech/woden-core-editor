Class {
	#name : #WDELevelEditorSession,
	#superclass : #Object,
	#instVars : [
		'gameSettings',
		'level',
		'selection',
		'statusMessage',
		'gridSize',
		'activeToolModeOrEditionModeName'
	],
	#category : #'WodenEditor-Model-Session'
}

{ #category : #action }
WDELevelEditorSession >> actionOpenFile [
]

{ #category : #action }
WDELevelEditorSession >> actionSaveFile [
]

{ #category : #accessing }
WDELevelEditorSession >> activeToolModeOrEditionModeName [
	^ activeToolModeOrEditionModeName ifNil: [ activeToolModeOrEditionModeName := '' ]
]

{ #category : #accessing }
WDELevelEditorSession >> activeToolModeOrEditionModeName: anObject [
	activeToolModeOrEditionModeName := anObject.
	self updateStatusMessage
]

{ #category : #selection }
WDELevelEditorSession >> addElementsToSelection: elements [
	| newSelectedItems oldSelectedItemSet |
	newSelectedItems := self selection selectedItems asOrderedCollection.
	oldSelectedItemSet := newSelectedItems asSet.
	elements do: [ :each |
		(oldSelectedItemSet includes: each) ifFalse: [
			newSelectedItems add: each
		]
	].
	self selection: (WDELevelEditorSelection for: newSelectedItems asArray)
]

{ #category : #action }
WDELevelEditorSession >> decreaseGridSize [
	self gridSize: self gridSize / self gridSizeIncrementFactor
]

{ #category : #action }
WDELevelEditorSession >> deleteSelectedItems [
]

{ #category : #action }
WDELevelEditorSession >> duplicateSelectedItems [
]

{ #category : #accessing }
WDELevelEditorSession >> gameSettings [
	^ gameSettings
]

{ #category : #accessing }
WDELevelEditorSession >> gameSettings: anObject [

	gameSettings := anObject.
	level value ifNotNil: [ :lv | lv gameSettings: gameSettings ]
]

{ #category : #accessing }
WDELevelEditorSession >> gridSize [
	^ gridSize value
]

{ #category : #accessing }
WDELevelEditorSession >> gridSize: newValue [
	gridSize value: ((newValue roundTo: self gridSizeGranularity) max: self gridSizeGranularity)
]

{ #category : #accessing }
WDELevelEditorSession >> gridSizeGranularity [
	^ 0.001
]

{ #category : #action }
WDELevelEditorSession >> gridSizeIncrementFactor [
	^ 10
]

{ #category : #action }
WDELevelEditorSession >> increaseGridSize [
	self gridSize: self gridSize * self gridSizeIncrementFactor
]

{ #category : #initialization }
WDELevelEditorSession >> initialize [
	super initialize.
	gameSettings := WDEGameSettings default.
	level := nil asValueHolder.
	statusMessage := '' asValueHolder.
	selection := WDELevelEditorSelection empty asValueHolder.
	gridSize := 10.0 asValueHolder.
]

{ #category : #accessing }
WDELevelEditorSession >> level [
	^ level value
]

{ #category : #accessing }
WDELevelEditorSession >> level: aLevel [
	aLevel gameSettings: gameSettings.
	level value: aLevel.
]

{ #category : #'as yet unclassified' }
WDELevelEditorSession >> levelScene [
	^ self level ifNotNil: [ :l | l scene ]
]

{ #category : #action }
WDELevelEditorSession >> playLevel [
]

{ #category : #'as yet unclassified' }
WDELevelEditorSession >> rayCastAllAlong: ray [
	^ self level ifNil: [ #() ] ifNotNil: [ :l | l rayCastAllAlong: ray ]
]

{ #category : #action }
WDELevelEditorSession >> redo [
]

{ #category : #accessing }
WDELevelEditorSession >> selection [
	^ selection value
	
]

{ #category : #accessing }
WDELevelEditorSession >> selection: newSelection [
	selection value: newSelection.

]

{ #category : #selection }
WDELevelEditorSession >> setSelectedElements: elements [
	self selection: (WDELevelEditorSelection for: elements asArray)
]

{ #category : #'as yet unclassified' }
WDELevelEditorSession >> snapToSubGrid: vector [
	^ vector roundWithQuantum: self subGridSize
]

{ #category : #accessing }
WDELevelEditorSession >> statusMessage [
	^ statusMessage value
]

{ #category : #accessing }
WDELevelEditorSession >> statusMessage: newMessage [
	statusMessage value: newMessage
]

{ #category : #'as yet unclassified' }
WDELevelEditorSession >> subGridSize [
	^ self gridSize * 0.1
]

{ #category : #action }
WDELevelEditorSession >> subtractSelectedItems [
]

{ #category : #selection }
WDELevelEditorSession >> toggleElementsFromSelection: elements [
	| newSelectedItems oldSelectedItemSet oldSelectedItems toggleElementSet |
	newSelectedItems := OrderedCollection new.
	oldSelectedItems := self selection selectedItems.
	oldSelectedItemSet := newSelectedItems asSet.
	toggleElementSet := elements asSet.

	oldSelectedItems do: [ :each |
		(toggleElementSet includes: each) ifFalse: [
			newSelectedItems add: each
		]
	].

	elements do: [ :each |
		(oldSelectedItemSet includes: each) ifFalse: [
			newSelectedItems add: each
		]
	].
	self selection: (WDELevelEditorSelection for: newSelectedItems asArray)
]

{ #category : #action }
WDELevelEditorSession >> undo [
]

{ #category : #accessing }
WDELevelEditorSession >> updateStatusMessage [
	self statusMessage: self activeToolModeOrEditionModeName
]

{ #category : #enumerating }
WDELevelEditorSession >> whenGridSizeChangedDo: aBlock [
	gridSize whenChangedDo: aBlock
]

{ #category : #enumerating }
WDELevelEditorSession >> whenLevelChangedDo: aBlock [
	level whenChangedDo: aBlock
]

{ #category : #enumerating }
WDELevelEditorSession >> whenLevelChangedDoNow: aBlock [
	aBlock cull: self level.
	self whenLevelChangedDo: aBlock
]

{ #category : #enumerating }
WDELevelEditorSession >> whenSelectionChangedDo: aBlock [
]

{ #category : #enumerating }
WDELevelEditorSession >> whenStatusMessageChangedDo: aBlock [
]
