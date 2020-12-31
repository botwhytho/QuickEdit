Extension { #name : #Collection }

{ #category : #'*QuickEdit' }
Collection >> gtItemsEditFor: aView [
	<gtView>
	| canBeSequenced hasAssociations view |
	canBeSequenced := [ :anItem | 
	((anItem respondsTo: #isSequenceable) and: [ anItem isSequenceable ])
		and: [ anItem isString not ] ].
	hasAssociations := [ :anItem | anItem respondsTo: #associations ].
	view := aView columnedTree
		title: 'Items Edit';
		priority: 52;
		items: [ (hasAssociations value: self)
				ifTrue: [ self associations ]
				ifFalse: [ self
						collectWithIndex: [ :anEntry :anIndex | 
							{anIndex.
							self} -> anEntry ] ] ];
		children: [ :each | 
			| item |
			item := each value.
			(hasAssociations value: item)
				ifTrue: [ item associations ]
				ifFalse: [ (canBeSequenced value: item)
						ifTrue: [ item
								collectWithIndex: [ :anEntry :anIndex | 
									{anIndex.
									item} -> anEntry ] ]
						ifFalse: [ #() ] ] ];
		column: 'Key'
			item: [ :each | 
			| aKey |
			aKey := each key isArray
				ifTrue: [ each key first ]
				ifFalse: [ each key ].
			aKey asRopedText foreground: Color gray ];
		column: 'Value'
			icon: [ :each | 
			| item |
			item := each value.
			((hasAssociations value: item) or: [ canBeSequenced value: item ])
				ifTrue: [ BlTextElement new text: '' asRopedText ]
				ifFalse: [ (QuickEdit isEditable: item)
						ifTrue: [ BrEditableLabel new
								look: BrGlamorousEditableLabelLook new glamorousRegularFontAndSize;
								text: item;
								when: BrEditorAcceptWish
									do: [ :aWish | 
									each key isArray
										ifTrue: [ each key second
												at: each key first
												put: (QuickEdit destringify: aWish text asString) ]
										ifFalse: [ each value: (QuickEdit destringify: aWish text asString) ] ] ]
						ifFalse: [ BlTextElement new text: item asRopedText ] ] ];
		send: #value;
		expandUpTo: 1.
	view columns second weight: 1.
	^ view
]
