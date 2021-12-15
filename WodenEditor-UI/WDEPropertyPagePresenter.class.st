Class {
	#name : #WDEPropertyPagePresenter,
	#superclass : #SpPresenterWithModel,
	#instVars : [
		'treeView'
	],
	#category : #'WodenEditor-UI-Spec'
}

{ #category : #specs }
WDEPropertyPagePresenter class >> defaultSpec [
	^ SpBoxLayout newVertical
		beNotHomogeneous;
		yourself
]
