Class {
	#name : 'WDELevelEditorPalettePresenter',
	#superclass : 'SpPresenterWithModel',
	#instVars : [
		'treeView'
	],
	#category : 'WodenEditor-UI-Spec',
	#package : 'WodenEditor-UI',
	#tag : 'Spec'
}

{ #category : 'specs' }
WDELevelEditorPalettePresenter class >> defaultLayout [
	^ SpBoxLayout newVertical
		add: #treeView;
		yourself
		
]

{ #category : 'initialization' }
WDELevelEditorPalettePresenter >> initializePresenters [
	treeView := self newTreeTable.
	treeView
		addColumn: (SpCompositeTableColumn new
			title: 'Name';
			addColumn: (SpStringTableColumn evaluated: [ :node | node name ]);
			addColumn: (SpImageTableColumn evaluated: [ :node | node thumbnailFor: self model ]);
			yourself
		);
		hideColumnHeaders;
		beResizable;
		children: [ :node | node children ];
		whenActivatedDo: [
			treeView selectedItem ifNotNil: [ :item | item activateInLevelSession: self model ]
		];
		whenSelectionChangedDo: [ :selection |
			self setSelectedPaletteElement: (selection selectedItem ifNotNil: [:i | i asPaletteElement])
		].

]

{ #category : 'initialization' }
WDELevelEditorPalettePresenter >> modelChanged [
	treeView roots: self fetchTopLevelPaletteCategories.
]

{ #category : 'initialization' }
WDELevelEditorPalettePresenter >> setSelectedPaletteElement: paletteElement [
	"By default do nothing."
]
