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
	| firstParent |
	selectedItems ifEmpty: [
		^ levelSession buildUnselectedElementContextMenuOn: menuPresenter
	].
	selectedItems size = 1 ifTrue: [ 
		"selectedItems first buildContextMenuForEditorSession: levelSession on: menuPresenter"
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
		];
		addItem: [ :item |
			item
				name: 'Inspect elements';
				action: [ selectedItems size = 1 ifTrue: [selectedItems first inspect] ifFalse: [ selectedItems inspect ]]
		].
	
	firstParent := selectedItems first parent.
	(firstParent isNotNil and: [ selectedItems allSatisfy: [ :each | each parent == firstParent ] ]) ifTrue: [ 
		menuPresenter 
			addItem: [ :item |
				item
					name: 'Make Entity';
					action: [ self groupInEntitySelectedItemsInSession: levelSession ]
			];
			addItem: [ :item |
				item
					name: 'Make Group';
					action: [ self groupSelectedItemsInSession: levelSession ]
			]
	].

	(selectedItems anySatisfy: [ :each | each canBeSubtracted]) ifTrue: [ 
		menuPresenter
			addItem: [ :item |
				item
					name: 'Subtract volumes';
					action: [ self subtractSelectedItemsInSession: levelSession ]
			].
	].

	(selectedItems anySatisfy: [ :each | each isGroup ]) ifTrue: [ 
		menuPresenter
			addItem: [ :item |
				item
					name: 'Ungroup';
					action: [ self ungroupSelectedItemsInSession: levelSession ]
			].
	].
]
