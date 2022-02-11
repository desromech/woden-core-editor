Class {
	#name : #WDELevelEditorViewSculptingMode,
	#superclass : #WDELevelEditorViewEditionMode,
	#category : #'WodenEditor-UI-ViewMode'
}

{ #category : #'as yet unclassified' }
WDELevelEditorViewSculptingMode >> commitModeChanges [
	view model activeEditionElements do: [ :each | each commitSculptingChanges ]
]

{ #category : #'as yet unclassified' }
WDELevelEditorViewSculptingMode >> currentModelingEditionMode [
	^ WDSculptEditionMode
]

{ #category : #accessing }
WDELevelEditorViewSculptingMode >> modeName [
	^ 'Sculpt Mode'
]
