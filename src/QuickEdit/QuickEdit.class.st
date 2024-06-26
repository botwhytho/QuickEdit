Class {
	#name : #QuickEdit,
	#superclass : #Object,
	#category : #'QuickEdit-Core'
}

{ #category : #utilities }
QuickEdit class >> buildChildren: anItem [
	| item itemValue |
	item := [ anItem value key.
		anItem value value ] onDNU: #key do: [ anItem value ].
	itemValue := [ item associations ] onDNU: #associations do: [ item ].
	(QuickEdit canBeSequenced: itemValue) ifFalse: [ ^ #() ].
	^ itemValue asOrderedCollection
		collectWithIndex: [ :each :index | 
			EditableItemOrCollection new
				parent: anItem parent;
				collection: item;
				value: each;
				index: index ]
]

{ #category : #'building ui' }
QuickEdit class >> buildCollectionValueColumn: each [
	| item itemValue |
	item := each value.
	itemValue := [ item key. item value ] onDNU: #key do: [ item ].
	(QuickEdit canBeSequenced: ([itemValue associations] onDNU: #associations do: [itemValue]))
		ifTrue: [ ^ BlTextElement new text: '' asRopedText ]
		ifFalse: [ (QuickEdit isEditable: itemValue)
				ifTrue: [ ^ QuickEdit buildCollectionValueUpdater2: each ]
				ifFalse: [ ^ BlTextElement new text: itemValue asRopedText ] ]
]

{ #category : #'building ui' }
QuickEdit class >> buildCollectionValueUpdater2: each [
	| aContainer anAddAboveButton anAddBelowButton anUndoButton aValueEditor  item itemValue  |
	item := each value.
	itemValue := [ item key.
		item value ] onDNU: #key do: [ item ].
	aContainer := BrHorizontalPane new
			hMatchParent;
			alignCenterLeft;
			vFitContent.
	aValueEditor := BrUndoableLabel value: each object: each updateEntity: #collection.
	aValueEditor when: BrEditorAcceptWish
		do: [ :aWish | 
			anUndoButton visibility: BlVisibility visible.
			aValueEditor updateValue  ].
	anUndoButton := QuickEdit undoButton: aValueEditor.
	anAddAboveButton := BrButton new.
			anAddAboveButton icon: BrGlamorousVectorIcons upwards;
			aptitude: BrGlamorousButtonWithIconAptitude new"+ each dropdownUp";
			label: 'Add Above';
			margin: (BlInsets left: 5);
			action: [ | tmp tmpValue |
				tmp := ([ each collection associations ]
						onDNU: #associations
						do: [ each collection ]) asOrderedCollection.
				tmp
					add: ([ each value key.
						'fourtytwo' -> 42 ] onDNU: #key do: [ 42 ])
					beforeIndex: each index.
				tmpValue := (tmp first respondsTo: #key)
						ifTrue: [ tmp asOrderedDictionary ]
						ifFalse: [ tmp ].
				each parent = each collection
					ifTrue: [ each parent become: tmpValue ]
					ifFalse: [ each parent isDictionary
							ifTrue: [ each parent at: (each parent keyAtValue: each collection) put: tmpValue ]
							ifFalse: [ each parent at: (each parent indexOf: each collection) put: tmpValue ] ].
				anAddBelowButton phlow firstParentWithView phlow update ].	
	anAddBelowButton := BrButton new.
			anAddBelowButton icon: BrGlamorousVectorIcons downwards;
			aptitude: BrGlamorousButtonWithIconAptitude new "+ each dropdownDown";
			label: 'Add Below';
			margin: (BlInsets left: 5);
			action: [ | tmp tmpValue |
				tmp := ([ each collection associations ]
						onDNU: #associations
						do: [ each collection ]) asOrderedCollection.
				tmp
					add: ([ each value key.
						'fourtytwo' -> 42 ] onDNU: #key do: [ 42 ])
					afterIndex: each index.
				tmpValue := (tmp first respondsTo: #key)
						ifTrue: [ tmp asOrderedDictionary ]
						ifFalse: [ tmp ].
				each parent = each collection
					ifTrue: [ each parent become: tmpValue ]
					ifFalse: [ each parent isDictionary
							ifTrue: [ each parent at: (each parent keyAtValue: each collection) put: tmpValue ]
							ifFalse: [ each parent at: (each parent indexOf: each collection) put: tmpValue ] ].
				 anAddBelowButton phlow firstParentWithView phlow update ].
	aContainer
		addChildren: {aValueEditor.
				anAddBelowButton.
				anAddAboveButton.
				anUndoButton}.
	^ aContainer
]

{ #category : #'building ui' }
QuickEdit class >> buildCollectionValueUpdater: each [
	| aContainer anAddAboveButton anAddBelowButton anUndoButton aValueEditor displayPreviousValue item itemValue updateUnderlyingValue |
	item := each value.
	itemValue := [ item key.
		item value ] onDNU: #key do: [ item ].
	displayPreviousValue := [ (aValueEditor editor history
			instVarNamed: #currentGroup) undoOn: aValueEditor editor.
		anUndoButton visibility: BlVisibility gone ].
	updateUnderlyingValue := [ (item respondsTo: #key)
			ifTrue: [ item value: (QuickEdit destringify: aValueEditor text asString) ]
			ifFalse: [ each collection
					at: each index
					put: (QuickEdit destringify: aValueEditor text asString) ] ].
	aContainer := BrHorizontalPane new
			hMatchParent;
			alignCenterLeft;
			vFitContent.
	aValueEditor := BrEditableLabel new
			aptitude: BrGlamorousEditableLabelAptitude new glamorousRegularFontAndSize;
			text: itemValue gtDisplayString;
			margin: (BlInsets all: 0);
			whenKey: BlKeyCombination primaryR
				labelDo: [ :aShortcutEvent | aShortcutEvent currentTarget switchToEditor ];
			whenKey: BlKeyCombination primaryZ
				labelDo: [ :aShortcutEvent | 
					displayPreviousValue value.
					updateUnderlyingValue value ];
			whenKey: BlKeyCombination primaryC
				labelDo: [ :aShortcutEvent | Clipboard clipboardText: aValueEditor text asString ].
	aValueEditor editor history instVarNamed: #shouldGroup put: true.
	anUndoButton := BrButton new
			icon: BrGlamorousVectorIcons cancel;
			aptitude: BrGlamorousButtonWithIconAptitude new;
			label: 'Undo';
			margin: (BlInsets left: 5);
			visibility: BlVisibility gone;
			action: [ displayPreviousValue value.
				updateUnderlyingValue value ];
			yourself.
	anAddAboveButton := BrButton new.
			anAddAboveButton icon: BrGlamorousVectorIcons upwards;
			aptitude: BrGlamorousButtonWithIconAptitude new"+ each dropdownUp";
			label: 'Add Above';
			margin: (BlInsets left: 5);
			action: [ | tmp tmpValue |
				tmp := ([ each collection associations ]
						onDNU: #associations
						do: [ each collection ]) asOrderedCollection.
				tmp
					add: ([ each value key.
						'fourtytwo' -> 42 ] onDNU: #key do: [ 42 ])
					beforeIndex: each index.
				tmpValue := (tmp first respondsTo: #key)
						ifTrue: [ tmp asOrderedDictionary ]
						ifFalse: [ tmp ].
				each parent = each collection
					ifTrue: [ each parent become: tmpValue ]
					ifFalse: [ each parent isDictionary
							ifTrue: [ each parent at: (each parent keyAtValue: each collection) put: tmpValue ]
							ifFalse: [ each parent at: (each parent indexOf: each collection) put: tmpValue ] ].
				(GtPhlowUpdateView new elementContext: anAddAboveButton phlow) execute ];
			yourself.	
	anAddBelowButton := BrButton new.
			anAddBelowButton icon: BrGlamorousVectorIcons downwards;
			aptitude: BrGlamorousButtonWithIconAptitude new "+ each dropdownDown";
			label: 'Add Below';
			margin: (BlInsets left: 5);
			action: [ | tmp tmpValue |
				tmp := ([ each collection associations ]
						onDNU: #associations
						do: [ each collection ]) asOrderedCollection.
				tmp
					add: ([ each value key.
						'fourtytwo' -> 42 ] onDNU: #key do: [ 42 ])
					afterIndex: each index.
				tmpValue := (tmp first respondsTo: #key)
						ifTrue: [ tmp asOrderedDictionary ]
						ifFalse: [ tmp ].
				each parent = each collection
					ifTrue: [ each parent become: tmpValue ]
					ifFalse: [ each parent isDictionary
							ifTrue: [ each parent at: (each parent keyAtValue: each collection) put: tmpValue ]
							ifFalse: [ each parent at: (each parent indexOf: each collection) put: tmpValue ] ].
				(GtPhlowUpdateView new elementContext: anAddBelowButton phlow) execute ].
	aValueEditor
		when: BrEditorAcceptWish
		do: [ :aWish | 
			anUndoButton visibility: BlVisibility visible.
			updateUnderlyingValue value ].
	aContainer
		addChildren: {aValueEditor.
				anAddBelowButton.
				anAddAboveButton.
				anUndoButton}.
	^ aContainer
]

{ #category : #utilities }
QuickEdit class >> buildItems: aCollection [
	^ ([ aCollection associations ] onDNU: #associations do: [ aCollection ])
		asOrderedCollection
		collectWithIndex: [ :each :index | 
			EditableItemOrCollection new
				parent: aCollection;
				collection: aCollection;
				value: each;
				index: index ]
]

{ #category : #'building ui' }
QuickEdit class >> buildObjectSlotUpdater: aSlot object: anObject [
	| aContainer anUndoButton aValueEditor displayPreviousValue updateUnderlyingValue |
	displayPreviousValue := [ (aValueEditor editor history
		instVarNamed: #currentGroup) undoOn: aValueEditor editor.
	anUndoButton visibility: BlVisibility gone ].
	updateUnderlyingValue := [ anObject
		instVarNamed: aSlot label
		put: (QuickEdit destringify: aValueEditor text asString) ].
	aContainer := BrHorizontalPane new
		hMatchParent;
		alignCenterLeft;
		vFitContent.
	aValueEditor := BrEditableLabel new
		aptitude: BrGlamorousEditableLabelAptitude new glamorousRegularFontAndSize;
		text: aSlot rawValue gtDisplayString;
		margin: (BlInsets all: 0);
		whenKey: BlKeyCombination primaryR
			labelDo: [ :aShortcutEvent | aShortcutEvent currentTarget switchToEditor ];
		whenKey: BlKeyCombination primaryZ
			labelDo: [ :aShortcutEvent | 
			displayPreviousValue value.
			updateUnderlyingValue value ];
		whenKey: BlKeyCombination primaryC
			labelDo:
				[ :aShortcutEvent | Clipboard clipboardText: aValueEditor text asString ].
	aValueEditor editor history instVarNamed: #shouldGroup put: true.
	anUndoButton := BrButton new
		icon: BrGlamorousVectorIcons cancel;
		aptitude: BrGlamorousButtonWithIconAptitude new;
		label: 'Undo';
		margin: (BlInsets left: 5);
		visibility: BlVisibility gone;
		action: [ displayPreviousValue value.
			updateUnderlyingValue value ];
		yourself.
	aValueEditor
		when: BrEditorAcceptWish
		do: [ :aWish | 
			anUndoButton visibility: BlVisibility visible.
			updateUnderlyingValue value ].
	aContainer
		addChildren:
			{aValueEditor.
			anUndoButton}.
	^ aContainer
]

{ #category : #utilities }
QuickEdit class >> canBeSequenced: anItem [
	^ ((anItem respondsTo: #isSequenceable)
		and: [ anItem isSequenceable ]) and: [ anItem isString not ]
]

{ #category : #parsing }
QuickEdit class >> destringify: aValue [
	"BrEditableLabel holds roped text. This tries to convert back to a valid JSON atomic data type (using nil instead of null because Pharo)"

	| atomicFromString |
	atomicFromString := #(true false nil)
		detect: [ :each | each asString = aValue ]
		ifNone: [ Number readFrom: aValue ifFail: [ aValue ] ].
	"`Number readFrom:` trims any text after a string beginning with what looks like a Float or Interger, so undoing that below."
	^ atomicFromString asString = aValue
		ifTrue: [ atomicFromString ]
		ifFalse: [ aValue ]
]

{ #category : #utilities }
QuickEdit class >> isEditable: aValue [
	^ #(#isBoolean #isNil #isNumber #isString)
		anySatisfy: [ :aSelector | aValue perform: aSelector ]
]

{ #category : #accessing }
QuickEdit class >> undoButton: anUndoableButton [
	^ BrButton new
		icon: BrGlamorousVectorIcons cancel;
		aptitude: BrGlamorousButtonWithIconAptitude new;
		label: 'Undo';
		margin: (BlInsets left: 5);
		visibility: BlVisibility gone;
		action: [ anUndoableButton undo ];
		yourself
]
