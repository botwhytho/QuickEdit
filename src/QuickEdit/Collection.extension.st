Extension { #name : #Collection }

{ #category : #'*QuickEdit' }
Collection >> gtItemsEditFor: aView [
	<gtView>
	| view |
	view := aView columnedTree
		actionUpdateButtonTooltip: 'Update item list';
		priority: 52;
		title: 'Items Edit';
		items: [ QuickEdit buildItems: self ];
		children: [ :each | QuickEdit buildChildren: each ];
		column: 'Key'
			item: [ :each | 
			(each key isArray
				ifTrue: [ each key first ]
				ifFalse: [ each key ]) asRopedText foreground: Color gray ];
		column: 'Value'
			icon: [ :each | QuickEdit buildCollectionValueColumn: each ];
		send: #value;
		expandUpTo: 1.
	view columns second weight: 1.
	^ view
]
