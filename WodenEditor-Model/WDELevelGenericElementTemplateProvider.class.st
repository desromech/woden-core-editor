Class {
	#name : 'WDELevelGenericElementTemplateProvider',
	#superclass : 'WDELevelElementTemplateProvider',
	#category : 'WodenEditor-Model-Palette',
	#package : 'WodenEditor-Model',
	#tag : 'Palette'
}

{ #category : 'as yet unclassified' }
WDELevelGenericElementTemplateProvider >> basicEntities [
	^ self makeCategoryNamed: 'Basic Entities' withElements: {
		'Point Entity' . WDEEntity new.
	}
]

{ #category : 'as yet unclassified' }
WDELevelGenericElementTemplateProvider >> bspGeometryCategory [
	^ self makeCategoryNamed: 'CSG (BSP style)' withElements: {
		'Box' . (WDMBSPBrush forBox: AABox unit).
		'Combiner' . (WDMBSPCombiner with: (WDMBSPBrush forBox: AABox unit)).
	}
]

{ #category : 'as yet unclassified' }
WDELevelGenericElementTemplateProvider >> lightsCategory [
	^ self makeCategoryNamed: 'Light Sources' withElements: {
		'Point Light' . WDModelingPointLightSource new.
		'Spot Light' . WDModelingSpotLightSource new.
		'Directional Light' . WDModelingDirectionalLightSource new.
	}
]

{ #category : 'as yet unclassified' }
WDELevelGenericElementTemplateProvider >> makeCategoryNamed: categoryName withElements: elements [
	| category |
	category :=  WDEPaletteCategory new
		name: categoryName.
		
	elements pairsDo: [ :templateName :prototype |
		category addTemplate: (
		WDELevelElementPrototypeTemplate new
			name: templateName;
			prototype: prototype;
			yourself
		)
	].
	^ category
]

{ #category : 'as yet unclassified' }
WDELevelGenericElementTemplateProvider >> terrainGeometryCategory [
	^ self makeCategoryNamed: 'Terrain Geometry' withElements: {
		'Terrain 32 1x1' . WDMTerrain patchSize: 32 gridExtent: 1@1.
		'Terrain 32 2x2' . WDMTerrain patchSize: 32 gridExtent: 2@2.
		'Terrain 32 3x3' . WDMTerrain patchSize: 32 gridExtent: 3@3.
		'Terrain 32 4x4' . WDMTerrain patchSize: 32 gridExtent: 4@4.
	}
]

{ #category : 'as yet unclassified' }
WDELevelGenericElementTemplateProvider >> topLevelPaletteCategories [
	^ {
		self lightsCategory.
		self bspGeometryCategory.
		self terrainGeometryCategory.
	}
]
