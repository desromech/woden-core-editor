Class {
	#name : 'WDELevelEditor3DBoxPlacementManipulator',
	#superclass : 'WDELevelEditor3DBoxManipulator',
	#category : 'WodenEditor-UI-Manipulators',
	#package : 'WodenEditor-UI',
	#tag : 'Manipulators'
}

{ #category : 'actions' }
WDELevelEditor3DBoxPlacementManipulator >> activateAction [
	| session |
	session := view levelEditorSession.
	(boundingBox isEmpty not and: [ boundingBox width > 0 and: [ boundingBox height > 0 and: [ boundingBox depth > 0 ] ] ]) ifTrue: [
		session activeLevelElementTemplate ifNotNil: [ :elementTemplate |
			elementTemplate instantiateInLevel: session level placingInBox: boundingBox session: session
		].
	].

	view
		activeToolManipulator: nil;
		activateObjectMode;
		refresh
]

{ #category : 'brick-properties' }
WDELevelEditor3DBoxPlacementManipulator >> currentColor [
	^ highlighted
		ifTrue: [ self editorTheme highlightedBoxPlacementManipulatorColor ]
		ifFalse: [ self editorTheme boxPlacementManipulatorColor ]
]
