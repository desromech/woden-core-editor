Class {
	#name : #WDEGameSettings,
	#superclass : #Object,
	#traits : 'TWDMModelingMaterialInfoResolver',
	#classTraits : 'TWDMModelingMaterialInfoResolver classTrait',
	#category : #'WodenEditor-Model-GameSettings'
}

{ #category : #testing }
WDEGameSettings class >> allSettings [
	^ self withAllSubclasses
		reject: [ :each | each isAbstract  ]
		thenCollect: [ :each | each new ]
]

{ #category : #accessing }
WDEGameSettings class >> default [
	^ WDEWodenGameFrameworkSettings new
]

{ #category : #testing }
WDEGameSettings class >> isAbstract [
	^ self == WDEGameSettings
]

{ #category : #'path finding' }
WDEGameSettings >> assetsFolders [
	^ #()
]

{ #category : #'path finding' }
WDEGameSettings >> editorMaterials [
	| materials |
	materials := OrderedCollection new.
	
	self specialMaterialsFolders do: [ :materialFolderAndParent |
		| materialFolder assetsFolder |
		materialFolder := materialFolderAndParent first.
		assetsFolder := materialFolderAndParent second.
		materialFolder allChildren select: [ :each | #(wdmat) includes: each extension ]
			thenDo: [ :each | materials add: (each relativeTo: materialFolder) fullName -> (each relativeTo: assetsFolder) fullName ]
	].
	materials sort: [ :a :b | a key < b key ].
	
	^ materials
]

{ #category : #'path finding' }
WDEGameSettings >> emptyLevel [
	self subclassResponsibility
]

{ #category : #'path finding' }
WDEGameSettings >> gameMaterials [
	| materials |
	materials := OrderedCollection new.
	
	self materialsFolders do: [ :materialFolderAndParent |
		| materialFolder assetsFolder |
		materialFolder := materialFolderAndParent first.
		assetsFolder := materialFolderAndParent second.
		materialFolder allChildren select: [ :each | #(wdmat) includes: each extension ]
			thenDo: [ :each | materials add: (each relativeTo: materialFolder) fullName -> (each relativeTo: assetsFolder) fullName ]
	].
	materials sort: [ :a :b | a key < b key ].
	
	^ materials
]

{ #category : #'path finding' }
WDEGameSettings >> loadFromFileReference: aFileReference [
	self subclassResponsibility
]

{ #category : #'path finding' }
WDEGameSettings >> loadValidMaterialForInfo: aMaterialInfo [
	| resolvedPath |
	aMaterialInfo path ifNil: [ ^ nil ].
	resolvedPath := self resolveAssetFileReference: aMaterialInfo path asFileReference.
	
	resolvedPath exists ifFalse: [ ^ nil ].
	^ WDMaterial loadFromFileReference: resolvedPath
]

{ #category : #'path finding' }
WDEGameSettings >> materialsFolders [
	^ self assetsFolders collect: [ :each | {each / 'materials' . each} ]
]

{ #category : #accessing }
WDEGameSettings >> name [
	self subclassResponsibility
]

{ #category : #'path finding' }
WDEGameSettings >> playLevelWithFileName: fileName [
	self inform: 'TODO: playMapWithFileName ' , fileName
]

{ #category : #'path finding' }
WDEGameSettings >> resolveAssetFileReference: aFileReference [
	| resolveBlock |
	resolveBlock := [ :each |
		| resolved |
		resolved := each resolve: each.
		resolved exists ifTrue: [ ^ resolved ]
	].

	self assetsFolders do: resolveBlock.
	self specialAssetsFolders do: resolveBlock.
	^ aFileReference
]

{ #category : #'path finding' }
WDEGameSettings >> specialAssetsFolders [
	^ #()
]

{ #category : #'path finding' }
WDEGameSettings >> specialMaterialsFolders [
	^ self specialAssetsFolders collect: [ :each | {each / 'materials' . each} ]
]

{ #category : #palette }
WDEGameSettings >> topLevelElementTemplateCategories [
	^ #()
]

{ #category : #palette }
WDEGameSettings >> topLevelLightSourcePaletteCategories [
	^ #()
]

{ #category : #'path finding' }
WDEGameSettings >> topMaterialPaletteCategories [
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

	^ {category . editorCategory}
]

{ #category : #'path finding' }
WDEGameSettings >> validExtensions [
	^ self subclassResponsibility
]
