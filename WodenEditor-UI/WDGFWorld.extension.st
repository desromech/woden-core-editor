Extension { #name : #WDGFWorld }

{ #category : #'*WodenEditor-UI' }
WDGFWorld >> openInEditor [
	WDEWodenGameFrameworkWorldLevel new
		world: self;
		openEditor
]
