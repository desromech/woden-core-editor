Extension { #name : #WDMaterial }

{ #category : #'*WodenEditor-Model' }
WDMaterial >> asWDModelingMaterialInfo [
	^ WDModelingMaterialInfo new definition: self
]
