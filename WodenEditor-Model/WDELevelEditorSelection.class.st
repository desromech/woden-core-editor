Class {
	#name : #WDELevelEditorSelection,
	#superclass : #Object,
	#instVars : [
		'selectedItems'
	],
	#category : #'WodenEditor-Model-Session'
}

{ #category : #requirements }
WDELevelEditorSelection class >> empty [
	^ self new
]

{ #category : #requirements }
WDELevelEditorSelection class >> for: selectedItems [
	^ self new selectedItems: selectedItems
]

{ #category : #actions }
WDELevelEditorSelection >> deleteSelectedItemsInSession: levelSession [
	| oldParents |
	oldParents := selectedItems collect: [ :each | each parent ].
	self assert: (oldParents allSatisfy: [ :each | each isNotNil ]).
	levelSession
		doWith: [
			levelSession selection: self class empty.
			selectedItems do: [ :each | each removeFromParent ]
		]
		undoWith: [
			selectedItems doWithIndex: [:removedItem :parentIndex |
				| oldParent |
				oldParent := oldParents at: parentIndex.
				oldParent addChild: removedItem
			].
			levelSession selection: self
		]
]

{ #category : #actions }
WDELevelEditorSelection >> duplicateSelectedItemsInSession: levelSession [
	| duplicatedItems placeableElements |
	selectedItems ifEmpty: [ ^ self ].

	placeableElements := selectedItems select: [ :each | each canBeDuplicatedAndPlaced ].
	placeableElements ifEmpty: [ ^ self ].
	
	duplicatedItems := placeableElements collect: [ :each |
		| copy |
		copy := each copy setupForNewInstance; yourself.
		each parent add: copy.
		copy
	].

	levelSession startPlacingDuplicatedItems: duplicatedItems
]

{ #category : #actions }
WDELevelEditorSelection >> groupInEntitySelectedItemsInSession: levelSession [
	| originalParent entity entityParent oldSelection |
	selectedItems ifEmpty: [ ^ self ].
	originalParent := selectedItems first parent.
	entityParent := levelSession level activeGroupForInstantiating: WDEEntity new .
	(selectedItems allSatisfy: [ :each | each parent == originalParent ]) ifFalse: [ ^ self ].
	oldSelection := self.

	levelSession doWith: [
		entity := WDEEntity new lockedGroup: true; yourself.
		selectedItems do: [ :each |
			each removeFromParent.
			entity add: each
		].
		entityParent add: entity.
		levelSession selection: (WDELevelEditorSelection for: {entity})
	] undoWith: [ 
		entity removeFromParent.
		entity := nil.
		selectedItems do: [ :each |
			originalParent add: each
		].
		levelSession selection: oldSelection
	]
]

{ #category : #actions }
WDELevelEditorSelection >> groupSelectedItemsInSession: levelSession [
	| group groupParent oldSelection |
	selectedItems ifEmpty: [ ^ self ].
	groupParent := selectedItems first parent.
	(selectedItems allSatisfy: [ :each | each parent == groupParent ]) ifFalse: [ ^ self ].
	oldSelection := self.

	levelSession doWith: [
		group := WDModelingGroup new lockedGroup: true; yourself.
		selectedItems do: [ :each |
			each removeFromParent.
			group add: each
		].
		groupParent add: group.
		levelSession selection: (WDELevelEditorSelection for: {group})
	] undoWith: [ 
		group removeFromParent.
		group := nil.
		selectedItems do: [ :each |
			groupParent add: each
		].
		levelSession selection: oldSelection
	]
]

{ #category : #initialization }
WDELevelEditorSelection >> initialize [
	super initialize.
	selectedItems := #().
]

{ #category : #memento }
WDELevelEditorSelection >> materialStateMemento [
	^ selectedItems collect: [ :each | each materialStateMemento ]
]

{ #category : #'as yet unclassified' }
WDELevelEditorSelection >> notifySelectedStatus: status [
	selectedItems do: [ :each | each selected: status ]
]

{ #category : #'as yet unclassified' }
WDELevelEditorSelection >> propertyPages [
	selectedItems size = 1 ifTrue: [ ^ selectedItems first propertyPages ].
	^ #()
]

{ #category : #memento }
WDELevelEditorSelection >> restoreMaterialStateMemento: memento [
	selectedItems doWithIndex: [ :each :index | each restoreMaterialStateMemento: (memento at: index) ]
]

{ #category : #memento }
WDELevelEditorSelection >> restoreTransformStateMemento: memento [
	selectedItems doWithIndex: [ :each :index | each restoreTransformStateMemento: (memento at: index) ]
]

{ #category : #accessing }
WDELevelEditorSelection >> selectedItems [

	^ selectedItems
]

{ #category : #accessing }
WDELevelEditorSelection >> selectedItems: anObject [

	selectedItems := anObject
]

{ #category : #actions }
WDELevelEditorSelection >> subtractSelectedItemsInSession: levelSession [
	| affectedElements subtractingItems remainingElements affectedElementSet actuallyAffectedElementsSet newElements affectedOriginals originalsWithParents |
	selectedItems ifEmpty: [ ^ self ].
	
	subtractingItems := selectedItems select: [ :each | each canBeSubtracted ].
	subtractingItems ifEmpty: [ ^ self ].

	affectedElements := subtractingItems first modelingTreeRoot findVolumeElementsThatIntersectElements: subtractingItems.
	affectedElements ifEmpty: [ ^ self ].
	
	originalsWithParents := affectedElements collect: [:each | {each parent . each} ] as: Array.
	remainingElements := originalsWithParents.
	affectedElementSet := affectedElements as: IdentitySet.
	actuallyAffectedElementsSet := IdentitySet new.
	subtractingItems do: [ :subtractor |
		| newRemainingElements |
		newRemainingElements := OrderedCollection new.
		remainingElements do: [ :parentWithEach |
			| subtractionResult parent each |
			parent := parentWithEach first. 
			each := parentWithEach second.
			subtractionResult := each subtract: subtractor.
			newRemainingElements addAll: (subtractionResult collect: [:r | {parent . r} ]).
			((affectedElementSet includes: each) and: [ (actuallyAffectedElementsSet includes: each) not ]) ifTrue: [
				(subtractionResult size = 1 and: [ subtractionResult first == each ]) ifFalse: [
					actuallyAffectedElementsSet add: each.
				]
			]
		].
		remainingElements := newRemainingElements
	].

	affectedOriginals := originalsWithParents select: [ :parentAndElement | (actuallyAffectedElementsSet includes: parentAndElement second) ].
	newElements := remainingElements reject: [ :parentAndElement | (affectedElementSet includes: parentAndElement second) ].

	levelSession
		doWith: [ 
			affectedOriginals do: [ :each | each second removeFromParent ].
			newElements do: [ :each | each first add: each second ].
			levelSession selection: self.
		] undoWith: [ 
			newElements do: [ :each | each second removeFromParent ].
			affectedOriginals do: [ :each | each first add: each second ].
			levelSession selection: self.
		]

]

{ #category : #memento }
WDELevelEditorSelection >> transformStateMemento [
	^ selectedItems collect: [ :each | each transformStateMemento ]
]
