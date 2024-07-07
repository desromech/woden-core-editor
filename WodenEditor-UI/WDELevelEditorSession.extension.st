Extension { #name : 'WDELevelEditorSession' }

{ #category : '*WodenEditor-UI' }
WDELevelEditorSession >> buildUnselectedElementContextMenuOn: menuPresenter [
]

{ #category : '*WodenEditor-UI' }
WDELevelEditorSession >> openEditor [
	^ (WDELevelEditor on: self) open
]
