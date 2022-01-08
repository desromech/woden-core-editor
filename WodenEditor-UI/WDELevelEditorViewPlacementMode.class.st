Class {
	#name : #WDELevelEditorViewPlacementMode,
	#superclass : #WDELevelEditorViewEditionMode,
	#category : #'WodenEditor-UI-ViewMode'
}

{ #category : #actions }
WDELevelEditorViewPlacementMode >> cancelAction [
	view activateObjectMode
]

{ #category : #testing }
WDELevelEditorViewPlacementMode >> isPlacementMode [
	^ true
]

{ #category : #accessing }
WDELevelEditorViewPlacementMode >> modeName [
	^ 'Placement Mode'
]

{ #category : #'as yet unclassified' }
WDELevelEditorViewPlacementMode >> supportsManipulators [
	^ true
]
