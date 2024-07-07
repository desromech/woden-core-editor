Class {
	#name : 'WDEGameSettings',
	#superclass : 'Object',
	#traits : 'TWDMModelingMaterialInfoResolver',
	#classTraits : 'TWDMModelingMaterialInfoResolver classTrait',
	#instVars : [
		'modelAssetCache',
		'propAssetCache'
	],
	#category : 'WodenEditor-Model-GameSettings',
	#package : 'WodenEditor-Model',
	#tag : 'GameSettings'
}

{ #category : 'testing' }
WDEGameSettings class >> allSettings [
	^ self withAllSubclasses
		reject: [ :each | each isAbstract  ]
		thenCollect: [ :each | each new ]
]

{ #category : 'accessing' }
WDEGameSettings class >> default [
	^ WDEWodenGameFrameworkSettings new
]

{ #category : 'testing' }
WDEGameSettings class >> isAbstract [
	^ self == WDEGameSettings
]

{ #category : 'path finding' }
WDEGameSettings >> assetsFolders [
	^ #()
]

{ #category : 'path finding' }
WDEGameSettings >> defaultMapsLocation [
	^ FileLocator imageDirectory
]

{ #category : 'path finding' }
WDEGameSettings >> editorMaterials [
	^ self findAssetsWithExtensions: self materialExtensions on: self specialMaterialsFolders
]

{ #category : 'path finding' }
WDEGameSettings >> emptyLevel [
	self subclassResponsibility
]

{ #category : 'path finding' }
WDEGameSettings >> findAssetsWithExtensions: aListOfExtensions on: folders [
	| assets |
	assets := OrderedCollection new.
	
	folders do: [ :assetFolderAndParent |
		| assetFolder assetsBaseFolder |
		assetFolder := assetFolderAndParent first.
		assetsBaseFolder := assetFolderAndParent second.
		assetFolder exists ifTrue: [
			assetFolder allChildren select: [ :each | aListOfExtensions includes: each extension ]
			thenDo: [ :each | assets add: (each relativeTo: assetFolder) fullName -> (each relativeTo: assetsBaseFolder) fullName ]
		]
	].
	assets sort: [ :a :b | a key < b key ].
	
	^ assets
]

{ #category : 'path finding' }
WDEGameSettings >> gameHDRIs [
	^ self findAssetsWithExtensions: self hdriExtensions on: self hdriFolders
]

{ #category : 'path finding' }
WDEGameSettings >> gameMaterials [
	^ self findAssetsWithExtensions: self materialExtensions on: self materialsFolders
]

{ #category : 'path finding' }
WDEGameSettings >> gameModels [
	^ self findAssetsWithExtensions: self modelExtensions on: self modelsFolders
]

{ #category : 'path finding' }
WDEGameSettings >> gameProps [
	^ self findAssetsWithExtensions: self propExtensions on: self propsFolders
]

{ #category : 'path finding' }
WDEGameSettings >> hdriExtensions [
	^	#(hdr)
]

{ #category : 'path finding' }
WDEGameSettings >> hdriFolders [
	^ self assetsFolders collect: [ :each | {each / 'hdri' . each} ]
]

{ #category : 'initialization' }
WDEGameSettings >> initialize [
	super initialize.
	modelAssetCache := WeakValueDictionary new.
	propAssetCache := WeakValueDictionary new.
]

{ #category : 'path finding' }
WDEGameSettings >> loadFromFileReference: aFileReference [
	self subclassResponsibility
]

{ #category : 'path finding' }
WDEGameSettings >> loadModelWithPath: path [
	| solvedPath |
	solvedPath := self resolveAssetPath: path.
	solvedPath exists ifFalse: [ ^ nil ].
	
	^ modelAssetCache at: solvedPath asAbsolute fullName ifAbsentPut: [
		[ 
			WDModelAssetReadWriter readFileNamed: solvedPath
		] on: Error do: [ nil ]
	]
]

{ #category : 'path finding' }
WDEGameSettings >> loadPropModelWithPath: path [
	| solvedPath |
	solvedPath := self resolveAssetPath: path.
	solvedPath exists ifFalse: [ ^ nil ].
	
	^ propAssetCache at: solvedPath asAbsolute fullName ifAbsentPut: [
		| propData |
		propData := STONJSON fromString: solvedPath contents.
		(propData at: 'model' ifAbsent: [ nil ])
			ifNotNil: [ :modelPath | self loadModelWithPath: modelPath ]
	]
]

{ #category : 'path finding' }
WDEGameSettings >> loadValidMaterialForInfo: aMaterialInfo [
	| resolvedPath |
	aMaterialInfo path ifNil: [ ^ nil ].
	resolvedPath := self resolveAssetPath: aMaterialInfo path asFileReference.
	
	resolvedPath exists ifFalse: [ ^ nil ].
	^ WDMaterial loadFromFileReference: resolvedPath
]

{ #category : 'path finding' }
WDEGameSettings >> materialExtensions [
	^	#(wdmat)
]

{ #category : 'path finding' }
WDEGameSettings >> materialsFolders [
	^ self assetsFolders collect: [ :each | {each / 'materials' . each} ]
]

{ #category : 'path finding' }
WDEGameSettings >> modelCategories [
	| category |
	category := WDEPaletteCategory new
			name: 'Models'.
	self gameModels do: [ :each |
		| subcategory |
		subcategory := category getOrCreateSubcategoryWithPath: each key asFileReference path segments allButLast.
		subcategory addTemplate: (WDELevelElementPrototypeTemplate new
			name: each key asFileReference basenameWithoutExtension;
			prototype: (WDModelingModelReference new
				path: each value;
				yourself);
			yourself)
	].

	^ {category} select: [ :each | each isNotEmpty ]
]

{ #category : 'path finding' }
WDEGameSettings >> modelExtensions [
	^	#(obj ply gltf glb)
]

{ #category : 'path finding' }
WDEGameSettings >> modelsFolders [
	^ self assetsFolders collect: [ :each | {each / 'models' . each} ]
]

{ #category : 'accessing' }
WDEGameSettings >> name [
	self subclassResponsibility
]

{ #category : 'path finding' }
WDEGameSettings >> playLevelInVRWithFileName: fileName [
	self inform: 'TODO: playLevelInVRWithFileName: ' , fileName
]

{ #category : 'path finding' }
WDEGameSettings >> playLevelWithFileName: fileName [
	self inform: 'TODO: playLevelWithFileName: ' , fileName
]

{ #category : 'path finding' }
WDEGameSettings >> propCategories [
	| category |
	category := WDEPaletteCategory new
			name: 'Props'.
	self gameProps do: [ :each |
		| subcategory |
		subcategory := category getOrCreateSubcategoryWithPath: each key asFileReference path segments allButLast.
		subcategory addTemplate: (WDELevelElementPrototypeTemplate new
			name: each key asFileReference basenameWithoutExtension;
			prototype: (WDModelingPropReference new
				path: each value;
				yourself);
			yourself)
	].

	^ {category} select: [ :each | each isNotEmpty ]
]

{ #category : 'path finding' }
WDEGameSettings >> propExtensions [
	^	#(wdprop)
]

{ #category : 'path finding' }
WDEGameSettings >> propsFolders [
	^ self assetsFolders collect: [ :each | {each / 'props' . each} ]
]

{ #category : 'path finding' }
WDEGameSettings >> resolveAssetPath: path [
	| fileReference resolveBlock |
	fileReference := path asFileReference.
	resolveBlock := [ :each |
		| resolved |
		resolved := each resolve: fileReference.
		resolved exists ifTrue: [ ^ resolved ]
	].

	self assetsFolders do: resolveBlock.
	self specialAssetsFolders do: resolveBlock.
	^ fileReference
]

{ #category : 'path finding' }
WDEGameSettings >> specialAssetsFolders [
	^ #()
]

{ #category : 'path finding' }
WDEGameSettings >> specialMaterialsFolders [
	^ self specialAssetsFolders collect: [ :each | {each / 'materials' . each} ]
]

{ #category : 'palette' }
WDEGameSettings >> topLevelElementTemplateCategories [
	^ self modelCategories , self propCategories
]

{ #category : 'path finding' }
WDEGameSettings >> topLevelHDRIPaletteCategories [
	| category |
	category := WDEPaletteCategory new
			name: 'Game HDRI'.
	self gameHDRIs do: [ :each |
		| subcategory |
		subcategory := category getOrCreateSubcategoryWithPath: each key asFileReference path segments allButLast.
		subcategory addTemplate: ((WDEHDRIPaletteElement path: each value)
			name: each key asFileReference basenameWithoutExtension;
			yourself)
	].

	^ {category} select: [ :each | each isNotEmpty ]
]

{ #category : 'palette' }
WDEGameSettings >> topLevelLightSourcePaletteCategories [
	^ #()
]

{ #category : 'path finding' }
WDEGameSettings >> topLevelMaterialPaletteCategories [
	| category editorCategory |
	category := WDEPaletteCategory new
			name: 'Game Materials'.
	self gameMaterials do: [ :each |
		| subcategory |
		subcategory := category getOrCreateSubcategoryWithPath: each key asFileReference path segments allButLast.
		subcategory addTemplate: ((WDEMaterialPaletteElement path: each value)
			name: each key asFileReference basenameWithoutExtension;
			yourself)
	].

	editorCategory := WDEPaletteCategory new
			name: 'Editor Materials'.

	self editorMaterials do: [ :each |
		| subcategory |
		subcategory := editorCategory getOrCreateSubcategoryWithPath: each key asFileReference path segments allButLast.
		subcategory addTemplate: ((WDEMaterialPaletteElement path: each value)
			name: each key asFileReference basenameWithoutExtension;
			yourself)
	].

	^ {category . editorCategory} select: [ :each | each isNotEmpty ]
]

{ #category : 'path finding' }
WDEGameSettings >> validExtensions [
	^ self subclassResponsibility
]
