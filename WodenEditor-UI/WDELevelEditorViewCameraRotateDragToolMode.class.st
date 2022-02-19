Class {
	#name : #WDELevelEditorViewCameraRotateDragToolMode,
	#superclass : #WDELevelEditorViewDragToolMode,
	#category : #'WodenEditor-UI-ViewMode'
}

{ #category : #'as yet unclassified' }
WDELevelEditorViewCameraRotateDragToolMode >> doNotAffectManipulators [
	^ true
]

{ #category : #'as yet unclassified' }
WDELevelEditorViewCameraRotateDragToolMode >> modeName [
	^ 'Camera rotate'
]

{ #category : #event }
WDELevelEditorViewCameraRotateDragToolMode >> onMouseDrag: event delta: delta [
	^ view rotateCameraInPlaceWithAngles: ((Vector3 x: delta y negated y: delta x negated z: 0.0) * 0.01).

]
