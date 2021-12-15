Class {
	#name : #WDELevelElementPropertyEditor,
	#superclass : #SpPresenterWithModel,
	#instVars : [
		'treeView',
		'propertiesNotebook'
	],
	#category : #'WodenEditor-UI-Spec'
}

{ #category : #specs }
WDELevelElementPropertyEditor class >> defaultSpec [
	^ SpBoxLayout newVertical
		add: #propertiesNotebook;
		yourself
]

{ #category : #initialization }
WDELevelElementPropertyEditor >> initializePresenters [
	propertiesNotebook := self newNotebook.
]
