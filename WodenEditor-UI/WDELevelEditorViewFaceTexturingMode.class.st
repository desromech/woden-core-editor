Class {
	#name : #WDELevelEditorViewFaceTexturingMode,
	#superclass : #WDELevelEditorViewEditionMode,
	#category : #'WodenEditor-UI-ViewMode'
}

{ #category : #'as yet unclassified' }
WDELevelEditorViewFaceTexturingMode >> currentModelingEditionMode [
	^ WDFaceTexturingMode
]

{ #category : #accessing }
WDELevelEditorViewFaceTexturingMode >> modeName [
	^ 'Texturing Mode'
]

{ #category : #'as yet unclassified' }
WDELevelEditorViewFaceTexturingMode >> supportsElementSelection [
	^ true
]
