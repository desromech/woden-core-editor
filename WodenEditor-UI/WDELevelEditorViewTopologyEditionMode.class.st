Class {
	#name : #WDELevelEditorViewTopologyEditionMode,
	#superclass : #WDELevelEditorViewEditionMode,
	#category : #'WodenEditor-UI-ViewMode'
}

{ #category : #'as yet unclassified' }
WDELevelEditorViewTopologyEditionMode >> commitModeChanges [
	view model activeEditionElements do: [ :each | each commitTopologyChanges ]
]

{ #category : #'as yet unclassified' }
WDELevelEditorViewTopologyEditionMode >> currentModelingEditionMode [
	^ WDTopologyEditionMode
]

{ #category : #'as yet unclassified' }
WDELevelEditorViewTopologyEditionMode >> manipulatorForActiveEditionElements: activeEditionElements [
	| objectManipulators |
	objectManipulators := OrderedCollection new.
	activeEditionElements do: [:each | 
		| controlPoints |
		controlPoints := each topologyControlPoints.
		controlPoints ifNotEmpty: [
			objectManipulators add: ((WDELevelEditor3DObjectTopologyManipulator for: view)
				transform: each globalTransform;
				children: (controlPoints collect: [:eachControlPoint | 					(WDELevelEditor3DControlPointManipulator for: view)
				controlPoint: eachControlPoint])
				yourself)
		]
	].

	objectManipulators isEmpty ifTrue: [ ^ nil ].
	objectManipulators size = 1 ifTrue: [ ^ objectManipulators first ].

	^ (WDELevelEditor3DObjectTopologyManipulator for: view)
		children: objectManipulators;
		yourself
]

{ #category : #accessing }
WDELevelEditorViewTopologyEditionMode >> modeName [
	^ 'Topology Edition Mode'
]

{ #category : #'as yet unclassified' }
WDELevelEditorViewTopologyEditionMode >> supportsManipulators [
	^ true
]
