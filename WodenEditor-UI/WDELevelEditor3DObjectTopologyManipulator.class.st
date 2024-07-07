Class {
	#name : 'WDELevelEditor3DObjectTopologyManipulator',
	#superclass : 'WDELevelEditor3DManipulator',
	#instVars : [
		'transform'
	],
	#category : 'WodenEditor-UI-Manipulators',
	#package : 'WodenEditor-UI',
	#tag : 'Manipulators'
}

{ #category : 'scene' }
WDELevelEditor3DObjectTopologyManipulator >> createSceneNode [
	^ WDSceneNode new
]

{ #category : 'accessing' }
WDELevelEditor3DObjectTopologyManipulator >> rayCast: ray [
	| bestResult |
	self visible ifFalse: [ ^ nil ].

	bestResult := nil.
	children do: [ :each |
		(each rayCast: ray) ifNotNil: [:childResult |
			(bestResult isNil or: [childResult < bestResult]) ifTrue: [
				bestResult := childResult
			]
		]
	].
	bestResult value ifNotNil: [
		^ bestResult
	].
	^ nil
]

{ #category : 'accessing' }
WDELevelEditor3DObjectTopologyManipulator >> transform [

	^ transform
]

{ #category : 'accessing' }
WDELevelEditor3DObjectTopologyManipulator >> transform: anObject [

	transform := anObject
]
