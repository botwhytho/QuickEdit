Extension { #name : #Object }

{ #category : #'*QuickEdit' }
Object >> gtEditFor: aView [
	<gtView>
	| view |
	view := self gtRawFor: aView.
	view
		actionUpdateButtonTooltip: 'Update item list';
		priority: view priority + 1;
		title: 'Edit'.
	view column: 'Edit'
		icon: [ :aNode | 
			(QuickEdit isEditable: aNode rawValue)
				ifTrue: [ QuickEdit buildObjectSlotUpdater: aNode object: self ]
				ifFalse: [ BlTextElement new text: aNode rawValue gtDisplayString asRopedText ] ].
	view columns third weight: 1.
	^ view
]
