Class {
	#name : 'WDELevelEditorSession',
	#superclass : 'Object',
	#instVars : [
		'gameSettings',
		'level',
		'selection',
		'statusMessage',
		'gridSize',
		'activeToolModeOrEditionModeName',
		'activeLevelElementTemplate',
		'undoOperationHistory',
		'redoOperationHistory',
		'whenStartingToPlaceDuplicatedItems',
		'levelFileReference',
		'activeEditionElements',
		'lastSelectionBox'
	],
	#category : 'WodenEditor-Model-Session',
	#package : 'WodenEditor-Model',
	#tag : 'Session'
}

{ #category : 'accessing' }
WDELevelEditorSession >> activeEditionElements [
	^ activeEditionElements
]

{ #category : 'accessing' }
WDELevelEditorSession >> activeEditionElements: aValue [
	activeEditionElements value: aValue
]

{ #category : 'accessing' }
WDELevelEditorSession >> activeLevelElementTemplate [
	^ activeLevelElementTemplate value
]

{ #category : 'accessing' }
WDELevelEditorSession >> activeLevelElementTemplate: aTemplate [
	activeLevelElementTemplate value: aTemplate
]

{ #category : 'accessing' }
WDELevelEditorSession >> activeToolModeOrEditionModeName [
	^ activeToolModeOrEditionModeName ifNil: [ activeToolModeOrEditionModeName := '' ]
]

{ #category : 'accessing' }
WDELevelEditorSession >> activeToolModeOrEditionModeName: anObject [
	activeToolModeOrEditionModeName := anObject.
	self updateStatusMessage
]

{ #category : 'selection' }
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

{ #category : 'as yet unclassified' }
WDELevelEditorSession >> buildSelectionContextMenu [
	^ self selection buildContextMenuFor: self
]

{ #category : 'action' }
WDELevelEditorSession >> decreaseGridSize [
	self gridSize: self gridSize / self gridSizeIncrementFactor
]

{ #category : 'action' }
WDELevelEditorSession >> deleteSelectedItems [
	self selection deleteSelectedItemsInSession: self
]

{ #category : 'undo - redo' }
WDELevelEditorSession >> doWith: doBlock undoWith: undoBlock [
	| operation |
	operation := WDELevelEditorOperation doWith: doBlock undoWith: undoBlock.
	operation doIt.
	undoOperationHistory add: operation.
	redoOperationHistory removeAll.
]

{ #category : 'action' }
WDELevelEditorSession >> duplicateSelectedItems [
	self selection duplicateSelectedItemsInSession: self
]

{ #category : 'accessing' }
WDELevelEditorSession >> exportToGltf: aFileReference [
	self level ifNil: [ ^ self ].
	self level exportToGltf: aFileReference.
]

{ #category : 'accessing' }
WDELevelEditorSession >> gameSettings [
	^ gameSettings
]

{ #category : 'accessing' }
WDELevelEditorSession >> gameSettings: anObject [

	gameSettings := anObject.
	level value ifNotNil: [ :lv | lv gameSettings: gameSettings ]
]

{ #category : 'accessing' }
WDELevelEditorSession >> gridSize [
	^ gridSize value
]

{ #category : 'accessing' }
WDELevelEditorSession >> gridSize: newValue [
	gridSize value: ((newValue roundTo: self gridSizeGranularity) max: self gridSizeGranularity)
]

{ #category : 'accessing' }
WDELevelEditorSession >> gridSizeGranularity [
	^ 0.001
]

{ #category : 'action' }
WDELevelEditorSession >> gridSizeIncrementFactor [
	^ 10
]

{ #category : 'as yet unclassified' }
WDELevelEditorSession >> importFromModelAsset: model [
	| sceneToImport |
	sceneToImport := model scenes first.
	sceneToImport normalLayer children do: [ :child |
		self importRootNode: child
	].
]

{ #category : 'as yet unclassified' }
WDELevelEditorSession >> importRootNode: aSceneNode [
	self halt
]

{ #category : 'action' }
WDELevelEditorSession >> increaseGridSize [
	self gridSize: self gridSize * self gridSizeIncrementFactor
]

{ #category : 'initialization' }
WDELevelEditorSession >> initialize [
	super initialize.
	gameSettings := WDEGameSettings default.
	level := nil asValueHolder.
	levelFileReference := nil asValueHolder.
	activeLevelElementTemplate := nil asValueHolder.
	statusMessage := '' asValueHolder.
	activeEditionElements := #() asValueHolder.
	selection := WDELevelEditorSelection empty asValueHolder.
	gridSize := 10.0 asValueHolder.
	whenStartingToPlaceDuplicatedItems := [].
	undoOperationHistory := OrderedCollection new.
	redoOperationHistory := OrderedCollection new.
]

{ #category : 'accessing' }
WDELevelEditorSession >> lastSelectionBox [
	^ lastSelectionBox
]

{ #category : 'accessing' }
WDELevelEditorSession >> level [
	^ level value
]

{ #category : 'accessing' }
WDELevelEditorSession >> level: aLevel [
	aLevel gameSettings: gameSettings.
	level value: aLevel.
]

{ #category : 'accessing' }
WDELevelEditorSession >> levelFileReference [
	^ levelFileReference value
]

{ #category : 'accessing' }
WDELevelEditorSession >> levelFileReference: aFileReference [
	levelFileReference value: aFileReference
]

{ #category : 'as yet unclassified' }
WDELevelEditorSession >> openFrom: aFileReference [
	| loadedLevel |
	aFileReference exists ifFalse: [ ^ self ].
	loadedLevel := gameSettings loadFromFileReference: aFileReference.
	self
		level: loadedLevel;
		levelFileReference: aFileReference
]

{ #category : 'accessing' }
WDELevelEditorSession >> playLevel [
	| tempFileName |
	self level ifNil: [ ^ self ].
	tempFileName := (FileSystem disk workingDirectory / 'test-level.tmp') fullName.
	self level saveTo: tempFileName asFileReference.
	self gameSettings playLevelWithFileName: tempFileName
]

{ #category : 'accessing' }
WDELevelEditorSession >> playLevelInVR [
	| tempFileName |
	self level ifNil: [ ^ self ].
	tempFileName := (FileSystem disk workingDirectory / 'test-level.tmp') fullName.
	self level saveTo: tempFileName asFileReference.
	self gameSettings playLevelInVRWithFileName: tempFileName
]

{ #category : 'as yet unclassified' }
WDELevelEditorSession >> rayPickElement: ray mode: modelingEditionMode [
	^ self level ifNil: [ #() ] ifNotNil: [ :l | l rayPickElement: ray mode: modelingEditionMode ]
]

{ #category : 'as yet unclassified' }
WDELevelEditorSession >> rayPickElements: ray mode: modelingEditionMode [
	^ self level ifNil: [ #() ] ifNotNil: [ :l | l rayPickElements: ray mode: modelingEditionMode ]
]

{ #category : 'undo - redo' }
WDELevelEditorSession >> redo [
	| operation |
	redoOperationHistory ifEmpty: [ ^ self ].
	operation := redoOperationHistory first.
	redoOperationHistory removeFirst.
	operation doIt.
	undoOperationHistory addLast: operation.
]

{ #category : 'accessing' }
WDELevelEditorSession >> saveTo: aFileReference [
	self level ifNil: [ ^ self ].
	self level saveTo: aFileReference.
	self levelFileReference: aFileReference.
]

{ #category : 'accessing' }
WDELevelEditorSession >> selectedItemsThatSupportModelingEditionMode: aMode [
	^ self selection selectedItems select: [ :each | each supportsModelingEditionMode: aMode ]
]

{ #category : 'accessing' }
WDELevelEditorSession >> selection [
	^ selection value
	
]

{ #category : 'accessing' }
WDELevelEditorSession >> selection: newSelection [
	selection value ifNotNil: [ :s | s notifySelectedStatus: false ].
	selection value: newSelection.
	newSelection ifNotNil: [ 
		| selectionBoundingBox |
		selectionBoundingBox := newSelection boundingBox.
		selectionBoundingBox isEmpty ifFalse: [
			lastSelectionBox := selectionBoundingBox 
		]
	].
	selection value ifNotNil: [ :s | s notifySelectedStatus: true ].

]

{ #category : 'selection' }
WDELevelEditorSession >> setSelectedElements: elements [
	self selection: (WDELevelEditorSelection for: elements asArray)
]

{ #category : 'as yet unclassified' }
WDELevelEditorSession >> snapToSubGrid: vector [
	^ vector roundWithQuantum: self subGridSize
]

{ #category : 'as yet unclassified' }
WDELevelEditorSession >> startPlacingDuplicatedItems: duplicatedItems [
	whenStartingToPlaceDuplicatedItems cull: duplicatedItems cull: self selection
]

{ #category : 'accessing' }
WDELevelEditorSession >> statusMessage [
	^ statusMessage value
]

{ #category : 'accessing' }
WDELevelEditorSession >> statusMessage: newMessage [
	statusMessage value: newMessage
]

{ #category : 'as yet unclassified' }
WDELevelEditorSession >> subGridSize [
	^ self gridSize * 0.1
]

{ #category : 'action' }
WDELevelEditorSession >> subtractSelectedItems [
	self selection subtractSelectedItemsInSession: self
]

{ #category : 'selection' }
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

{ #category : 'palette' }
WDELevelEditorSession >> topLevelElementTemplateCategories [
	^ WDELevelElementTemplateProvider allTopLevelPaletteCategories , self gameSettings topLevelElementTemplateCategories
]

{ #category : 'palette' }
WDELevelEditorSession >> topLevelHDRIPaletteCategories [
	^ WDEHDRIPaletteProvider allTopLevelPaletteCategories , gameSettings topLevelHDRIPaletteCategories
]

{ #category : 'palette' }
WDELevelEditorSession >> topLevelLightSourcePaletteCategories [
	^ WDELightSourcePaletteProvider allTopLevelPaletteCategories , gameSettings topLevelLightSourcePaletteCategories
]

{ #category : 'palette' }
WDELevelEditorSession >> topLevelMaterialPaletteCategories [
	^ WDEMaterialPaletteProvider allTopLevelPaletteCategories , gameSettings topLevelMaterialPaletteCategories
]

{ #category : 'undo - redo' }
WDELevelEditorSession >> undo [
	| operation |
	undoOperationHistory ifEmpty: [ ^ self ].
	operation := undoOperationHistory last.
	undoOperationHistory removeLast.
	operation undoIt.
	redoOperationHistory addFirst: operation.
]

{ #category : 'accessing' }
WDELevelEditorSession >> updateStatusMessage [
	self statusMessage: self activeToolModeOrEditionModeName
]

{ #category : 'events' }
WDELevelEditorSession >> whenActiveEditionElementsChangedDo: aBlock [
	activeEditionElements whenChangedDo: aBlock
]

{ #category : 'events' }
WDELevelEditorSession >> whenActiveLevelElementTemplateChangedDo: aBlock [
	activeLevelElementTemplate whenChangedDo: aBlock
]

{ #category : 'events' }
WDELevelEditorSession >> whenGridSizeChangedDo: aBlock [
	gridSize whenChangedDo: aBlock
]

{ #category : 'events' }
WDELevelEditorSession >> whenLevelChangedDo: aBlock [
	level whenChangedDo: aBlock
]

{ #category : 'events' }
WDELevelEditorSession >> whenLevelChangedDoNow: aBlock [
	aBlock cull: self level.
	self whenLevelChangedDo: aBlock
]

{ #category : 'events' }
WDELevelEditorSession >> whenSelectionChangedDo: aBlock [
	selection whenChangedDo: aBlock
]

{ #category : 'events' }
WDELevelEditorSession >> whenStartingToPlaceDuplicatedItemsDo: aBlock [
	whenStartingToPlaceDuplicatedItems := aBlock
]

{ #category : 'events' }
WDELevelEditorSession >> whenStatusMessageChangedDo: aBlock [
]
