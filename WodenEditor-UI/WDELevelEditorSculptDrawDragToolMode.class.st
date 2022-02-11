Class {
	#name : #WDELevelEditorSculptDrawDragToolMode,
	#superclass : #WDELevelEditorViewDragToolMode,
	#category : #'WodenEditor-UI-ViewMode'
}

{ #category : #accessing }
WDELevelEditorSculptDrawDragToolMode >> modeName [
	^ 'Sculpt Drawing'
]

{ #category : #event }
WDELevelEditorSculptDrawDragToolMode >> onMouseDrag: event delta: delta [
	| ray drawIntensity drawRadius |
	super onMouseDrag: event delta: delta.
	ray := view rayForScreenPosition: event position.
	drawIntensity := 0.01.
	drawRadius := 1.0.
	event shiftPressed ifTrue: [ drawIntensity := drawIntensity negated ].
	
	view model activeEditionElements do: [ :each |
		| localRay |
		localRay := ray inverseTransformedWith: each globalTransform.
		each sculptWithLocalRay: localRay drawIntensity: drawIntensity drawRadius: drawRadius
	]

]
