Extension { #name : #WDModelingTree }

{ #category : #'*WodenEditor-UI' }
WDModelingTree >> openLevelEditor [
	^ WDEModelingTreeLevel new modelingTree: self; openEditor
]
