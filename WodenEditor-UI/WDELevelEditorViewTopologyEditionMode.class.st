Class {
	#name : #WDELevelEditorViewTopologyEditionMode,
	#superclass : #WDELevelEditorViewEditionMode,
	#category : #'WodenEditor-UI-ViewMode'
}

{ #category : #'as yet unclassified' }
WDELevelEditorViewTopologyEditionMode >> currentModelingEditionMode [
	^ WDTopologyEditionMode
]

{ #category : #accessing }
WDELevelEditorViewTopologyEditionMode >> modeName [
	^ 'Topology Edition Mode'
]
