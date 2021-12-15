Extension { #name : #WDELevelEditorSession }

{ #category : #'*WodenEditor-UI' }
WDELevelEditorSession >> openEditor [
	^ (WDELevelEditor on: self) openWithSpec
]
