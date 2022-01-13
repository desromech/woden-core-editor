Extension { #name : #WDELevelEditorSelection }

{ #category : #'*WodenEditor-UI' }
WDELevelEditorSelection >> buildContextMenuFor: levelSession [
	| presenter |
	presenter := SpMenuPresenter new.
	self buildContextMenuFor: levelSession on: presenter.
	^ presenter

]

{ #category : #'*WodenEditor-UI' }
WDELevelEditorSelection >> buildContextMenuFor: levelSession on: menuPresenter [
	selectedItems ifEmpty: [
		^ levelSession buildUnselectedElementContextMenuOn: menuPresenter
	].
	selectedItems size = 1 ifTrue: [ 
		selectedItems first buildContextMenuForEditorSession: levelSession on: menuPresenter
	].

	menuPresenter
		addItem: [ :item |
			item
				name: 'Delete';
				action: [ self deleteSelectedItemsInSession: levelSession ]
		];
		addItem: [ :item |
			item
				name: 'Duplicate';
				action: [ self duplicateSelectedItemsInSession: levelSession ]
		].

	(selectedItems anySatisfy: [ :each | each canBeUsedForVolumeSubtractionInEditor]) ifTrue: [ 
		menuPresenter
			addItem: [ :item |
				item
					name: 'Subtract volumes';
					action: [ self subtractSelectedItemsInSession: levelSession ]
			].
	].
]
