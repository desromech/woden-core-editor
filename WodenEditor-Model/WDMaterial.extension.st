Extension { #name : #WDMaterial }

{ #category : #'*WodenEditor-Model' }
WDMaterial >> asWDEMaterialInfo [
	^ WDEMaterialInfo new definition: self
]
