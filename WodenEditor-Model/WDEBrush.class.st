Class {
	#name : #WDEBrush,
	#superclass : #WDELevelElement,
	#instVars : [
		'faces'
	],
	#category : #'WodenEditor-Model-Level'
}

{ #category : #'as yet unclassified' }
WDEBrush class >> forBox: aBox [
	^ self withFaces: { 
		WDEBrushFace plane: (Plane nx: -1 ny: 0 nz: 0 distance: aBox min x).
		WDEBrushFace plane: (Plane nx: 1 ny: 0 nz: 0 distance: aBox max x).
		WDEBrushFace plane: (Plane nx: 0 ny: -1 nz: 0 distance: aBox min y).
		WDEBrushFace plane: (Plane nx: 0 ny: 1 nz: 0 distance: aBox max y).
		WDEBrushFace plane: (Plane nx: 0 ny: 0 nz: -1 distance: aBox min z).
		WDEBrushFace plane: (Plane nx: 0 ny: 0 nz: 1 distance: aBox max z).
	}
]

{ #category : #'as yet unclassified' }
WDEBrush class >> withFaces: aCollectionOfFaces [
	^ self new faces: aCollectionOfFaces; yourself
]

{ #category : #'as yet unclassified' }
WDEBrush >> editorTreeChildren [
	^ faces
]

{ #category : #'as yet unclassified' }
WDEBrush >> editorTreeDisplayName [
	^ 'Brush'
]

{ #category : #accessing }
WDEBrush >> faces [

	^ faces
]

{ #category : #accessing }
WDEBrush >> faces: anObject [

	faces := anObject
]

{ #category : #initialization }
WDEBrush >> initialize [
	super initialize.
	faces := #().
]
