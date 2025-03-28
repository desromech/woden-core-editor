Class {
	#name : 'WDELevelEditor',
	#superclass : 'SpPresenterWithModel',
	#instVars : [
		'mainMenuBar',
		'mainToolbar',
		'mainStatusBar',
		'elementProperties',
		'levelTreeView',
		'elementTemplateList',
		'paletteNotebook',
		'contentView'
	],
	#category : 'WodenEditor-UI-Spec',
	#package : 'WodenEditor-UI',
	#tag : 'Spec'
}

{ #category : 'specs' }
WDELevelEditor class >> defaultLayout [

	^ SpBoxLayout newVertical
		  add: #mainMenuBar
		  withConstraints: [ :constraints | 
			  constraints height: self toolbarHeight ];
		  add: #mainToolbar
		  withConstraints: [ :constraints | 
			  constraints height: self toolbarHeight ];
		  add: (SpPanedLayout newHorizontal
				   positionOfSlider: 1 / 5;
				   add: (SpPanedLayout newVertical
						    positionOfSlider: 2 / 3;
						    add: #levelTreeView;
						    add: #elementTemplateList;
						    yourself);
				   add: (SpPanedLayout newHorizontal
						    positionOfSlider: 4 / 5;
						    add: #contentView;
						    add: (SpPanedLayout newVertical
								     positionOfSlider: 2 / 3;
								     add: #elementProperties;
								     add: #paletteNotebook;
								     yourself) yourself) yourself);
		  add: #mainStatusBar
		  withConstraints: [ :constraints | 
		  constraints height: self toolbarHeight ];
		  yourself
]

{ #category : 'as yet unclassified' }
WDELevelEditor class >> fillShadingMenu: menu viewBlock: viewBlock [
	^ menu addItem: [ :item |
			item
				name: 'Wireframe';
				action: [  viewBlock value activateWireFrame ]
		];
		addItem: [ :item |
			item
				name: 'Flat color';
				action: [  viewBlock value activateFlatColor ]
		];
		addItem: [ :item |
			item
				name: 'Flat textured';
				action: [  viewBlock value activateFlatTextured ]
		];
		addItem: [ :item |
			item
				name: 'Material validation';
				action: [  viewBlock value activateMaterialValidation ]
		];
		addItem: [ :item |
			item
				name: 'Shaded color';
				action: [  viewBlock value activateShadedColor ]
		];
		addItem: [ :item |
			item
				name: 'Full shaded';
				action: [  viewBlock value activateFullShaded ]
		];
		yourself
]

{ #category : 'world menu' }
WDELevelEditor class >> menuCommandOn: builder [
	<worldMenu>
	(builder item: #'Woden Level Editor')
		parent: #Tools;
		order: 0;
		action: [ self openEditorWorldMenuCommand  ].
]

{ #category : 'world menu' }
WDELevelEditor class >> openEditorWithGameSettings: gameSettings [
	gameSettings emptyLevel newEditorSession
		gameSettings: gameSettings;
		openEditor
]

{ #category : 'world menu' }
WDELevelEditor class >> openEditorWorldMenuCommand [
	| availableSettings |
	availableSettings := WDEGameSettings allSettings.
	
	availableSettings size > 1 ifTrue: [
		|gameMenu |
		gameMenu := SpMenuPresenter new.
		availableSettings do: [ :gameSetting |
			gameMenu
				addItem: [ :item |
					item
						name: gameSetting name;
						action: [ self openEditorWithGameSettings: gameSetting ]
				]
		].
	
		gameMenu openWithSpecAtPointer
	] ifFalse: [
		self openEditorWithGameSettings: availableSettings first.
	].

]

{ #category : 'as yet unclassified' }
WDELevelEditor >> actionPlayLevel [
	^ self model playLevel
]

{ #category : 'as yet unclassified' }
WDELevelEditor >> actionPlayLevelInVR [
	^ self model playLevelInVR
]

{ #category : 'menu' }
WDELevelEditor >> buildMainMenuBar [
	^ self newMenuBar
		addGroup: [ :group |
			group
				addItem: [ :item |
					item
						name: 'File';
						subMenu: self fileMenu
				];
				addItem: [ :item |
					item
						name: 'Edit';
						subMenu: self editMenu
				];
				addItem: [ :item |
					item
						name: 'Game';
						subMenu: self gameMenu
				];
				addItem: [ :item |
					item
						name: 'View';
						subMenu: self viewMenu
				];
				addItem: [ :item |
					item
						name: 'Help';
						subMenu: self helpMenu
				]
		];
		yourself
]

{ #category : 'initialization' }
WDELevelEditor >> buildMainToolbar [
	^ self newToolbar
		
		addItem: (SpToolbarButtonPresenter new
			label: 'Object';
			action: [ contentView activateObjectMode ];
			yourself);
		addItem: (SpToolbarButtonPresenter new
			label: 'Placement';
			action: [ contentView activatePlacementMode ];
			yourself);
		addItem: (SpToolbarButtonPresenter new
			label: 'Face Texturing';
			action: [ contentView activateFaceTexturingMode ];
			yourself);
		addItem: (SpToolbarButtonPresenter new
			label: 'Topology Edition';
			action: [ contentView activateTopologyEditionMode ];
			yourself);
		addItem: (SpToolbarButtonPresenter new
			label: 'Sculpting';
			action: [ contentView activateSculptingMode ];
			yourself);
		addItem: (SpToolbarButtonPresenter new
			icon: (self iconNamed: #glamorousGo);
			action: [ self actionPlayLevel ];
			yourself);
		addItem: (SpToolbarButtonPresenter new
			label: 'VR';
			icon: (self iconNamed: #glamorousGo);
			action: [ self actionPlayLevelInVR ];
			yourself);
		yourself
]

{ #category : 'menu' }
WDELevelEditor >> cameraMenu [
	^ self newMenu
		addGroup: [ :group |
			group
			addItem: [ :item |
				item
					name: 'Top';
					shortcut: (KeyboardKey named: #KP_7) asKeyCombination;
					action: [ self contentView topView ]
			];
			addItem: [ :item |
				item
					name: 'Bottom';
					shortcut: (KeyboardKey named: #KP_7) command mac | (KeyboardKey named: #KP_7) control unix | (KeyboardKey named: #KP_7) control win;
					action: [ self contentView bottomView ]
			];
			addItem: [ :item |
				item
					name: 'Front';
					shortcut: (KeyboardKey named: #KP_1) asKeyCombination;
					action: [ self contentView frontView ]
			];
			addItem: [ :item |
				item
					name: 'Back';
					shortcut: (KeyboardKey named: #KP_1) command mac | (KeyboardKey named: #KP_1) control unix | (KeyboardKey named: #KP_1) control win;
					action: [ self contentView backView ]
			];
			addItem: [ :item |
				item
					name: 'Left';
					shortcut: (KeyboardKey named: #KP_3) asKeyCombination;
					action: [ self contentView leftView ]
			];
			addItem: [ :item |
				item
					name: 'Right';
					shortcut: (KeyboardKey named: #KP_3) command mac | (KeyboardKey named: #KP_3) control unix | (KeyboardKey named: #KP_3) control win;
					action: [ self contentView rightView ]
			]
		];
		addGroup: [ :group |
			group
				addItem: [ :item |
				item
					name: 'Perspective';
					action: [ self contentView perspectiveView ]
			];
			addItem: [ :item |
				item
					name: 'Orthographic';
					action: [ self contentView orthographicView ]
			];
			addItem: [ :item |
				item
					name: 'Toggle Perspective/Orthographics';
					shortcut: (KeyboardKey named: #KP_5) asKeyCombination;
					action: [ self contentView togglePerspective ]
			]
		];
		yourself
]

{ #category : 'initialization' }
WDELevelEditor >> connectForNewLevel: level [
	levelTreeView roots: {level modelingTree}.
	level whenAddedOrRemovedElementDo: [ levelTreeView roots: {level modelingTree} ]
]

{ #category : 'accessing' }
WDELevelEditor >> contentView [
	^ contentView
]

{ #category : 'menu' }
WDELevelEditor >> editMenu [
	^ self newMenu
		addGroup: [ :group |
			group
				addItem: [ :item |
					item
						name: 'Undo';
						icon: (self iconNamed: #smallUndoIcon);
						shortcut: $z command mac | $z control unix | $z control win;
						action: [ self actionUndo ].
				];
				addItem: [ :item |
					item
						name: 'Redo';
						icon: (self iconNamed: #smallRedoIcon);
						shortcut: $z command shift mac | $z control shift unix | $z control shift win;
						action: [ self actionRedo ].
				]
		];
		addGroup: [ :group |
			group addItem: [ :item |
				item
					name: 'Cut';
					icon: (self iconNamed: #smallCutIcon);
					shortcut: $x command mac | $x control unix | $x control win;
					action: [ self actionCut ]
			].
			group addItem: [ :item |
				item
					name: 'Copy';
					icon: (self iconNamed: #smallCopyIcon);
					shortcut: $c command mac | $c control unix | $c control win;
					action: [ self actionCopy ]
			].
			group addItem: [ :item |
				item
					name: 'Duplicate';
					shortcut: $d command mac | $d control unix | $d control win;
					action: [ self actionDuplicate ]
			].
			group addItem: [ :item |
				item
					name: 'Paste';
					icon: (self iconNamed: #smallPasteIcon);
					shortcut: $v command mac | $v control unix | $v control win;
					action: [ self actionPaste ]
			].
			group addItem: [ :item |
				item
					name: 'Delete';
					icon: (self iconNamed: #smallDeleteIcon);
					shortcut: KeyboardKey delete asKeyCombination;
					action: [ self actionDelete ]
			].
		];
		yourself
]

{ #category : 'menu' }
WDELevelEditor >> fileMenu [
	^ self newMenu
		addGroup: [ :group |
			group
				addItem: [ :item |
					item
						name: 'Open File...';
						icon: (self iconNamed: #openIcon);
						shortcut: $o command mac | $o control unix | $o control win;
						action: [ contentView actionOpenFile ].
				];
				addItem: [ :item |
					item
						name: 'Save';
						icon: (self iconNamed: #smallSaveIcon);
						shortcut: $s command mac | $s control unix | $s control win;
						action: [ contentView actionSaveFile ].
				];
				addItem: [ :item |
					item
						name: 'Save As...';
						icon: (self iconNamed: #smallSaveAsIcon);
						action: [ contentView actionSaveFileAs ].
				]
		];
		addGroup: [ :group |
			group
				addItem: [ :item |
					item
						name: 'Import from gltf...';
						action: [ contentView importFromGltf ].
				];
				addItem: [ :item |
					item
						name: 'Export as gltf...';
						action: [ contentView exportAsGltf ].
				]
		];
		addGroup: [ :group |
			group
				addItem: [ :item |
					item
						name: 'Exit';
						action: [ self actionExit ].
				]
		];
		yourself
]

{ #category : 'menu' }
WDELevelEditor >> gameMenu [
	^ self newMenu
		addGroup: [ :group |
			group
				addItem: [ :item |
					item
						name: 'Play level';
						shortcut: $p command mac | $p control unix | $p control win;
						action: [self actionPlayLevel].
				];
				addItem: [ :item |
					item
						name: 'Play level in VR';
						action: [self actionPlayLevelInVR].
				]
		];
		yourself
]

{ #category : 'menu' }
WDELevelEditor >> helpMenu [
	^ self newMenu
		addGroup: [ :group |
			group
				addItem: [ :item |
					item
						name: 'About...';
						action: [ self actionAbout ].
				]
		];
		yourself
]

{ #category : 'initialization' }
WDELevelEditor >> initializePresenters [
	mainMenuBar := self buildMainMenuBar.
	mainToolbar := self buildMainToolbar.
	mainStatusBar := self newStatusBar.
	contentView := self instantiate: WDELevelEditorContentView.
	elementProperties := self instantiate: WDELevelElementPropertyEditor.
	levelTreeView := self newTreeTable.
	levelTreeView
		addColumn: (SpCompositeTableColumn new
			title: 'Element';
			addColumn: (SpStringTableColumn evaluated: [ :node | node treeDisplayName ]);
			yourself
		);
		addColumn: ((SpCheckBoxTableColumn title: 'Visible' evaluated: [ :node | node visible ])
			onActivation: [ :node | node visible: true ];
			onDeactivation: [ :node | node visible: false ];
			yourself
		);
		hideColumnHeaders;
		children: [ :node | node children ];
		beMultipleSelection;
		whenSelectionChangedDo: [ :selection |
			self model selection: (WDELevelEditorSelection for: selection selectedItems)
		];
		contextMenu: [ self treeViewMenu ].
	elementTemplateList := WDELevelEditorElementTemplatePalettePresenter on: self model.
	
	paletteNotebook := self newNotebook.
	paletteNotebook
		addPageTitle: 'Materials' provider: [ WDELevelEditorMaterialPalettePresenter on: self model];
		addPageTitle: 'Light Sources' provider: [ WDELevelEditorLightSourcePalettePresenter on: self model];
		addPageTitle: 'HDRI' provider: [ WDELevelEditorHDRIPalettePresenter on: self model].

	mainMenuBar addKeybindingsTo: self.
]

{ #category : 'initialization' }
WDELevelEditor >> initializeWindow: aWindowPresenter [
	super initializeWindow: aWindowPresenter.
	aWindowPresenter initialExtent: 1024@768
]

{ #category : 'initialization' }
WDELevelEditor >> modelChanged [
	contentView model: self model; modelChanged.
	elementProperties model: self model selection; modelChanged.
	self model
		whenStatusMessageChangedDo: [ :message | mainStatusBar popMessage; pushMessage: message ];
		whenSelectionChangedDo: [ :selection |
			levelTreeView selectedItems asSet = selection selectedItems asSet ifFalse: [
				levelTreeView unselectAll; selectItems: selection selectedItems
			].
		
			elementProperties model: selection
		];
		whenLevelChangedDoNow: [ :newLevel |
			self connectForNewLevel: newLevel
		].
]

{ #category : 'menu' }
WDELevelEditor >> shadingMenu [
	| menu |
	menu := self newMenu.
	self class fillShadingMenu: menu viewBlock: [self contentView].
	^ menu
		
]

{ #category : 'as yet unclassified' }
WDELevelEditor >> treeViewMenu [
	^ self model buildSelectionContextMenu
]

{ #category : 'menu' }
WDELevelEditor >> viewMenu [
	^ self newMenu
		addGroup: [ :group |
			group
				addItem: [ :item |
					item
						name: 'Shading mode';
						subMenu: self shadingMenu.
				];
				addItem: [ :item |
					item
						name: 'Camera';
						subMenu: self cameraMenu.
				]
		];
		yourself
]
