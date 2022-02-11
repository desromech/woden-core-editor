Class {
	#name : #WDELevelEditor3DObjectTopologyManipulator,
	#superclass : #WDELevelEditor3DManipulator,
	#instVars : [
		'transform'
	],
	#category : #'WodenEditor-UI-Manipulators'
}

{ #category : #scene }
WDELevelEditor3DObjectTopologyManipulator >> createSceneNode [
	^ WDSceneNode new
		transform: transform;
		yourself
]

{ #category : #accessing }
WDELevelEditor3DObjectTopologyManipulator >> rayCast: ray [
	| localRay bestResult |
	self visible ifFalse: [ ^ nil ].

	bestResult := nil.
	localRay := ray inverseTransformedWith: transform.
	children do: [ :each |
		(each rayCast: localRay) ifNotNil: [:childResult |
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

{ #category : #accessing }
WDELevelEditor3DObjectTopologyManipulator >> transform [

	^ transform
]

{ #category : #accessing }
WDELevelEditor3DObjectTopologyManipulator >> transform: anObject [

	transform := anObject
]
