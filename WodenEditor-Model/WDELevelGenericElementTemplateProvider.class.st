Class {
	#name : #WDELevelGenericElementTemplateProvider,
	#superclass : #WDELevelElementTemplateProvider,
	#category : #'WodenEditor-Model-Palette'
}

{ #category : #'as yet unclassified' }
WDELevelGenericElementTemplateProvider >> bspGeometryCategory [
	^ self makeCategoryNamed: 'CSG (BSP style)' withElements: {
		'Box' . (WDEBrush forBox: AABox unit).
	}
]

{ #category : #'as yet unclassified' }
WDELevelGenericElementTemplateProvider >> makeCategoryNamed: categoryName withElements: elements [
	| category |
	category :=  WDEPaletteCategory new
		name: categoryName.
		
	elements pairsDo: [ :templateName :prototype |
		category addTemplate: (
		WDELevelElementEntityTemplate new
			name: templateName;
			prototype: prototype;
			yourself
		)
	].
	^ category
]

{ #category : #'as yet unclassified' }
WDELevelGenericElementTemplateProvider >> terrainGeometryCategory [
	^ self makeCategoryNamed: 'Terrain Geometry' withElements: {
		'Terrain 32 1x1' . WDETerrain patchSize: 32 gridExtent: 1@1.
		'Terrain 32 2x2' . WDETerrain patchSize: 32 gridExtent: 2@2.
		'Terrain 32 3x3' . WDETerrain patchSize: 32 gridExtent: 3@3.
		'Terrain 32 4x4' . WDETerrain patchSize: 32 gridExtent: 4@4.
	}
]

{ #category : #'as yet unclassified' }
WDELevelGenericElementTemplateProvider >> topLevelPaletteCategories [
	^ {
		self bspGeometryCategory.
		self terrainGeometryCategory.
	}
]
