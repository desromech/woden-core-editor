Class {
	#name : #WDELevelGenericElementTemplateProvider,
	#superclass : #WDELevelElementTemplateProvider,
	#category : #'WodenEditor-Model-Palette'
}

{ #category : #'as yet unclassified' }
WDELevelGenericElementTemplateProvider >> bspGeometryCategory [
	^ self makeCategoryNamed: 'BSP Geometry' withElements: {
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
		'Terrain' . WDETerrain new.
	}
]

{ #category : #'as yet unclassified' }
WDELevelGenericElementTemplateProvider >> topLevelPaletteCategories [
	^ {
		self bspGeometryCategory.
		self terrainGeometryCategory.
	}
]
