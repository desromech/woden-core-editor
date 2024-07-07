Class {
	#name : 'WDELevelElementTextureMappingEditor',
	#superclass : 'SpPresenterWithModel',
	#instVars : [
		'textureScaleX',
		'textureScaleY',
		'textureOffsetX',
		'textureOffsetY',
		'textureRotation'
	],
	#category : 'WodenEditor-UI-Spec',
	#package : 'WodenEditor-UI',
	#tag : 'Spec'
}

{ #category : 'specs' }
WDELevelElementTextureMappingEditor class >> defaultLayout [
	^ SpGridLayout new
		add: 'Texture Scale:' at: 1@1;
		add: #textureScaleX at: 2@1;
		add: #textureScaleY at: 3@1;
		add: 'Texture Offset:' at: 1@2;
		add: #textureOffsetX at: 2@2;
		add: #textureOffsetY at: 3@2;
		add: 'Texture Rotation:' at: 1@3;
		add: #textureRotation at: 2@3;
		yourself
		
]

{ #category : 'initialization' }
WDELevelElementTextureMappingEditor >> initializePresenters [
	textureScaleX := self newNumberInput beFloat; yourself.
	textureScaleY := self newNumberInput beFloat; yourself.
	textureOffsetX := self newNumberInput beFloat; yourself.
	textureOffsetY := self newNumberInput beFloat; yourself.
	textureRotation := self newNumberInput beFloat; yourself.

	textureScaleX whenNumberChangedDo: [ :newScale |
		self model do: [ :each | each textureScale: (each textureScale copy x: newScale) ]
	].
	textureScaleY whenNumberChangedDo: [ :newScale |
		self model do: [ :each | each textureScale: (each textureScale copy y: newScale) ]
	].
	textureOffsetX whenNumberChangedDo: [ :newOffset |
		self model do: [ :each | each textureOffset: (each textureOffset copy x: newOffset) ]
	].
	textureOffsetY whenNumberChangedDo: [ :newOffset |
		self model do: [ :each | each textureOffset: (each textureOffset copy y: newOffset) ]
	].
	textureRotation whenNumberChangedDo: [ :newRotation |
		self model do: [ :each | each textureRotation: newRotation degreesToRadians ]
	].
]

{ #category : 'initialization' }
WDELevelElementTextureMappingEditor >> modelChanged [
	| elements scaleX scaleY offsetX offsetY rotation |
	elements := self model.
	elements ifEmpty:  [ ^ self ].
	
	scaleX := elements first textureScale x.
	scaleY := elements first textureScale y.
	offsetX := elements first textureOffset x.
	offsetY := elements first textureOffset y.
	rotation := elements first textureRotation.
	elements allButFirstDo: [ :el |
		(el textureScale x closeTo: scaleX) ifFalse: [ scaleX := nil ].
		(el textureScale y closeTo: scaleY) ifFalse: [ scaleY := nil ].
		(el textureOffset x closeTo: offsetX) ifFalse: [ offsetX := nil ].
		(el textureOffset y closeTo: offsetY) ifFalse: [ offsetY := nil ].
		(el textureRotation closeTo: rotation) ifFalse: [ rotation := nil ].
	].

	scaleX ifNotNil: [ textureScaleX number: scaleX ].
	scaleY ifNotNil: [ textureScaleY number: scaleY ].
	offsetX ifNotNil: [ textureOffsetX number: offsetX ].
	offsetY ifNotNil: [ textureOffsetY number: offsetY ].
	rotation ifNotNil: [ textureRotation number: rotation radiansToDegrees ].
]

{ #category : 'accessing' }
WDELevelElementTextureMappingEditor >> textureOffsetX [

	^ textureOffsetX
]

{ #category : 'accessing' }
WDELevelElementTextureMappingEditor >> textureOffsetX: anObject [

	textureOffsetX := anObject
]

{ #category : 'accessing' }
WDELevelElementTextureMappingEditor >> textureOffsetY [

	^ textureOffsetY
]

{ #category : 'accessing' }
WDELevelElementTextureMappingEditor >> textureOffsetY: anObject [

	textureOffsetY := anObject
]

{ #category : 'accessing' }
WDELevelElementTextureMappingEditor >> textureRotation [

	^ textureRotation
]

{ #category : 'accessing' }
WDELevelElementTextureMappingEditor >> textureRotation: anObject [

	textureRotation := anObject
]

{ #category : 'accessing' }
WDELevelElementTextureMappingEditor >> textureScaleX [

	^ textureScaleX
]

{ #category : 'accessing' }
WDELevelElementTextureMappingEditor >> textureScaleX: anObject [

	textureScaleX := anObject
]

{ #category : 'accessing' }
WDELevelElementTextureMappingEditor >> textureScaleY [

	^ textureScaleY
]

{ #category : 'accessing' }
WDELevelElementTextureMappingEditor >> textureScaleY: anObject [

	textureScaleY := anObject
]
