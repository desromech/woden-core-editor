"
I am an entity in a quake style level.
"
Class {
	#name : #WDEEntity,
	#superclass : #WDModelingGroup,
	#instVars : [
		'className',
		'properties'
	],
	#category : #'WodenEditor-Model-Level'
}

{ #category : #serialization }
WDEEntity class >> jsonObjectTypeName [
	^ self name withoutPrefix: 'WDE'
]

{ #category : #testing }
WDEEntity >> canBeDuplicatedAndPlaced [
	^ self isWorldEntity not
]

{ #category : #accessing }
WDEEntity >> className [
	^ className
]

{ #category : #accessing }
WDEEntity >> className: anObject [

	className := anObject
]

{ #category : #serialization }
WDEEntity >> encodeJsonKeyValuesWithContext: serializationContext [
	^ (super encodeJsonKeyValuesWithContext: serializationContext) , {
		#className . className .
		#properties . properties.
	}
]

{ #category : #initialization }
WDEEntity >> initialize [
	super initialize.
	properties := Dictionary new.
]

{ #category : #testing }
WDEEntity >> isSceneSelectableObject [
	^ self isWorldEntity not
]

{ #category : #testing }
WDEEntity >> isWorldEntity [
	^ #(worldspawn world) includes: className
]

{ #category : #serialization }
WDEEntity >> loadFromJson: jsonData withContext: level [
	super loadFromJson: jsonData withContext: level.
	className := jsonData at: #className ifAbsent: [ '' ].
	properties := properties at: #properties ifAbsent: [ Dictionary new ].

]

{ #category : #accessing }
WDEEntity >> objectTypeName [
	^ 'Entity'
]
