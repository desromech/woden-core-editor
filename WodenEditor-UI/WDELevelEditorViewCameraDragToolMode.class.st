Class {
	#name : 'WDELevelEditorViewCameraDragToolMode',
	#superclass : 'WDELevelEditorViewDragToolMode',
	#category : 'WodenEditor-UI-ViewMode',
	#package : 'WodenEditor-UI',
	#tag : 'ViewMode'
}

{ #category : 'as yet unclassified' }
WDELevelEditorViewCameraDragToolMode >> doNotAffectManipulators [
	^ true
]

{ #category : 'as yet unclassified' }
WDELevelEditorViewCameraDragToolMode >> modeName [
	^ 'Camera dragging'
]

{ #category : 'event' }
WDELevelEditorViewCameraDragToolMode >> onMouseDrag: event delta: delta [
	event controlKeyPressed ifTrue: [
		view freePerspectiveView.
		^ view rotateCameraInPlaceWithAngles: ((Vector3 x: delta y negated asFloat y: delta x negated z: 0.0) * 0.01).
	].
	event shiftPressed ifTrue: [
		^ view translateCameraBy: (view cameraXZDeltaToWorld: delta)
	].

	view translateCameraBy: (view cameraXYDeltaToWorld: delta)
]
