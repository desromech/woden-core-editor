Class {
	#name : #WDEMaterialPaletteElement,
	#superclass : #WDEPaletteElement,
	#instVars : [
		'material',
		'thumbnail'
	],
	#category : #'WodenEditor-Model-Palette'
}

{ #category : #'single color materials' }
WDEMaterialPaletteElement class >> dielectricBaseColor: albedo roughness: roughness [
	^ self new 
		material: (WDMetallicRoughnessMaterial new
			baseColorFactor: albedo;
			roughnessFactor: roughness;
			metallicFactor: 0.0;
			yourself);
		yourself
]

{ #category : #'single color materials' }
WDEMaterialPaletteElement class >> metallicBaseColor: albedo roughness: roughness [
	^ self new 
		material: (WDMetallicRoughnessMaterial new
			baseColorFactor: albedo;
			roughnessFactor: roughness;
			metallicFactor: 1.0;
			yourself);
		yourself
]

{ #category : #'single color materials' }
WDEMaterialPaletteElement class >> path: path [
	^ self new 
		material: (WDModelingMaterialInfo new path: path);
		yourself
]

{ #category : #'as yet unclassified' }
WDEMaterialPaletteElement >> activateInLevelSession: levelSession [
	| oldSelection memento |
	oldSelection := levelSession selection.
	oldSelection selectedItems ifEmpty: [ ^ self ].
	
	memento := oldSelection materialStateMemento.
	levelSession doWith: [
		levelSession selection selectedItems do: [ :each |
			each setMaterialRecursively: material
		].
	] undoWith: [
		oldSelection restoreMaterialStateMemento: memento.
	].


]

{ #category : #accessing }
WDEMaterialPaletteElement >> material [

	^ material
]

{ #category : #accessing }
WDEMaterialPaletteElement >> material: anObject [
	material := anObject asWDModelingMaterialInfo
]

{ #category : #accessing }
WDEMaterialPaletteElement >> thumbnailFor: levelEditorSession [
	^ thumbnail ifNil: [ thumbnail := material ifNotNil: [ material thumbnailFor: levelEditorSession ] ]
]
