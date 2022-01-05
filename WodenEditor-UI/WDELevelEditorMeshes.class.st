Class {
	#name : #WDELevelEditorMeshes,
	#superclass : #Object,
	#instVars : [
		'axisMesh',
		'gridMaterial',
		'gridMesh',
		'subGridMesh'
	],
	#classInstVars : [
		'uniqueInstance'
	],
	#category : #'WodenEditor-UI-Scene'
}

{ #category : #accessing }
WDELevelEditorMeshes class >> reset [
	<script>
	uniqueInstance := nil
]

{ #category : #accessing }
WDELevelEditorMeshes class >> uniqueInstance [
	uniqueInstance ifNil: [ uniqueInstance := self basicNew initialize ].
	^ uniqueInstance
]

{ #category : #accessing }
WDELevelEditorMeshes >> axisMesh [
	^ axisMesh ifNil: [
		| start end |
		start := -10000.0.
		end := start negated. 

		axisMesh := WDMeshBuilder new
			currentMaterial: self gridMaterial;
			beginLines;
			addColor: Color red;
			addP: (Vector3 x: start y: 0.0 z: 0.0);
			addColor: Color red;
			addP: (Vector3 x: end y: 0.0 z: 0.0);
			addColor: Color green;
			addP: (Vector3 x: 0.0 y: start z: 0.0);
			addColor: Color green;
			addP: (Vector3 x: 0.0 y: end z: 0.0);
			addColor: Color blue;
			addP: (Vector3 x: 0.0 y: 0.0 z: start);
			addColor: Color blue;
			addP: (Vector3 x: 0.0 y: 0.0 z: end);
			addLineI0: 0 i1: 1;
			addLineI0: 2 i1: 3;
			addLineI0: 4 i1: 5;
			mesh
	]
]

{ #category : #'as yet unclassified' }
WDELevelEditorMeshes >> baseGridSize [
	^ 10
]

{ #category : #accessing }
WDELevelEditorMeshes >> gridMaterial [
	^ gridMaterial ifNil: [ gridMaterial := WDUnlitMaterial new
		background: true;
		yourself ]
]

{ #category : #accessing }
WDELevelEditorMeshes >> gridMesh [
	^ gridMesh ifNil: [
		| start end |
		start := -10000.0.
		end := start negated. 

		gridMesh := WDMeshBuilder new
			currentMaterial: self gridMaterial;
			addLineGridWithWidth: 200 height: 200 subdivisions: 21;
			mesh
	]
]

{ #category : #accessing }
WDELevelEditorMeshes >> subGridMesh [
	^ subGridMesh ifNil: [
		| start end |
		start := -10000.0.
		end := start negated. 

		subGridMesh := WDMeshBuilder new
			currentMaterial: self gridMaterial;
			addLineGridWithWidth: 200 height: 200 subdivisions: 201;
			mesh
	]
]
