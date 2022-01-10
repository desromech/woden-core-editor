Class {
	#name : #WDELevelEditorSelection,
	#superclass : #Object,
	#instVars : [
		'selectedItems'
	],
	#category : #'WodenEditor-Model-Session'
}

{ #category : #requirements }
WDELevelEditorSelection class >> empty [
	^ self new
]

{ #category : #requirements }
WDELevelEditorSelection class >> for: selectedItems [
	^ self new selectedItems: selectedItems
]

{ #category : #initialization }
WDELevelEditorSelection >> initialize [
	super initialize.
	selectedItems := #().
]

{ #category : #memento }
WDELevelEditorSelection >> materialStateMemento [
	^ selectedItems collect: [ :each | each materialStateMemento ]
]

{ #category : #memento }
WDELevelEditorSelection >> restoreMaterialStateMemento: memento [
	selectedItems doWithIndex: [ :each :index | each restoreMaterialStateMemento: (memento at: index) ]
]

{ #category : #memento }
WDELevelEditorSelection >> restoreTransformStateMemento: memento [
	selectedItems doWithIndex: [ :each :index | each restoreTransformStateMemento: (memento at: index) ]
]

{ #category : #accessing }
WDELevelEditorSelection >> selectedItems [

	^ selectedItems
]

{ #category : #accessing }
WDELevelEditorSelection >> selectedItems: anObject [

	selectedItems := anObject
]

{ #category : #memento }
WDELevelEditorSelection >> transformStateMemento [
	^ selectedItems collect: [ :each | each transformStateMemento ]
]
