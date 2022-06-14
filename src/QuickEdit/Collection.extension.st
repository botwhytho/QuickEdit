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
		        column: 'Key' text: [ :each | 
			        ([each value key] onDNU: #key do: [each index]) asRopedText foreground: Color gray ];
		        column: 'Value'
		        icon: [ :each | QuickEdit buildCollectionValueColumn: each ];
		        send: #value;
		        expandUpTo: 1.
	view columns second weight: 1.
	^ view
]
