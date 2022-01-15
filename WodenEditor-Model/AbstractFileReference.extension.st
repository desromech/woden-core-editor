Extension { #name : #AbstractFileReference }

{ #category : #'*WodenEditor-Model' }
AbstractFileReference >> asWDEMaterialInfo [
	^ WDEMaterialInfo new fileReference: self
]
