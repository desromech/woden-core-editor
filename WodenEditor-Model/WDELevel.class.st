"
I provide an abstract interface for connecting the level editor with an actual game specific level model.
"
Class {
	#name : 'WDELevel',
	#superclass : 'Object',
	#instVars : [
		'gameSettings',
		'modelingTree'
	],
	#category : 'WodenEditor-Model-Level',
	#package : 'WodenEditor-Model',
	#tag : 'Level'
}

{ #category : 'serialization' }
WDELevel class >> loadFromJson: jsonData [
	^ self new loadFromJson: jsonData
]

{ #category : 'as yet unclassified' }
WDELevel class >> loadFromJsonString: jsonString [
	^ self loadFromJson: (STONJSON fromString: jsonString)
]

{ #category : 'as yet unclassified' }
WDELevel >> activeGroup [
	^ self modelingTree
]

{ #category : 'as yet unclassified' }
WDELevel >> activeGroupForInstantiating: aPrototype [
	^ self activeGroup
	
]

{ #category : 'as yet unclassified' }
WDELevel >> elementsInFrustum: frustum [
	^ modelingTree findVolumeElementsThatIntersectFrustum: frustum
]

{ #category : 'accessing' }
WDELevel >> exportToGltf: aFileReference [
	| builder rootNode json |
	builder := WDSRWGLTF2Builder new.
	rootNode := modelingTree exportToGltfWith: builder.
	(builder newScene: 'Level') nodes: { rootNode }.
	json := builder buildJson.
	aFileReference writeStreamDo: [ :out | out truncate; nextPutAll: json ]
]

{ #category : 'accessing' }
WDELevel >> gameSettings [

	^ gameSettings
]

{ #category : 'accessing' }
WDELevel >> gameSettings: anObject [
	gameSettings := anObject.
	modelingTree ifNotNil: [
		modelingTree
			materialResolver: gameSettings;
			modelResolver: gameSettings;
			assetResolver: gameSettings
	]
	
]

{ #category : 'initialization' }
WDELevel >> initialize [
	super initialize.
	modelingTree := WDModelingTree new.
	modelingTree
		materialResolver: gameSettings;
		modelResolver: gameSettings;
		assetResolver: gameSettings.
]

{ #category : 'accessing' }
WDELevel >> level [
	^ self
]

{ #category : 'serialization' }
WDELevel >> loadFromJson: jsonData [
	modelingTree := WDModelingTree new.
	modelingTree loadFromJson: jsonData
]

{ #category : 'accessing' }
WDELevel >> modelingTree [
	^ modelingTree
]

{ #category : 'instance creation' }
WDELevel >> newEditorSession [
	^ WDELevelEditorSession new
		gameSettings: (gameSettings ifNil: [WDEGameSettings default]);
		level: self;
		yourself
]

{ #category : 'as yet unclassified' }
WDELevel >> rayPickElement: ray mode: modelingEditionMode [
	| picker |
	picker := WDMFirstRayPicker ray: ray editionMode: modelingEditionMode.
	modelingTree rayPickElements: picker.
	^ picker result
]

{ #category : 'as yet unclassified' }
WDELevel >> rayPickElements: ray mode: modelingEditionMode [
	| picker |
	picker := WDMRayPicker ray: ray editionMode: modelingEditionMode.
	modelingTree rayPickElements: picker.
	^ picker sortedDistancesWithResults
]

{ #category : 'fileout' }
WDELevel >> saveTo: aFileReference [
	| encodedLevel |
	encodedLevel := modelingTree encodeAsJSONString.
	aFileReference writeStreamDo: [ :out | out truncate; nextPutAll: encodedLevel ].
]

{ #category : 'as yet unclassified' }
WDELevel >> validExtensions [
	self subclassResponsibility
]

{ #category : 'hooks' }
WDELevel >> whenAddedOrRemovedElementDo: aBlock [
	modelingTree whenAddedOrRemovedElementDo: aBlock
]
