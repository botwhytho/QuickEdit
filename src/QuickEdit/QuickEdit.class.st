Class {
	#name : #QuickEdit,
	#superclass : #Object,
	#category : #'QuickEdit-Core'
}

{ #category : #utilities }
QuickEdit class >> buildChildren: anItem [
	| item |
	item := anItem value.
	(item respondsTo: #associations)
		ifTrue: [ ^ item associations ]
		ifFalse: [ (QuickEdit canBeSequenced: item)
				ifTrue: [ ^ item
						collectWithIndex: [ :anEntry :anIndex | 
							{anIndex.
							item} -> anEntry ] ]
				ifFalse: [ ^ #() ] ]
]

{ #category : #'building ui' }
QuickEdit class >> buildCollectionValueColumn: each [
	| item |
	item := each value.
	((item respondsTo: #associations)
		or: [ QuickEdit canBeSequenced: item ])
		ifTrue: [ ^ BlTextElement new text: '' asRopedText ]
		ifFalse: [ (QuickEdit isEditable: item)
				ifTrue: [ ^ QuickEdit buildCollectionValueUpdater: each ]
				ifFalse: [ ^ BlTextElement new text: item asRopedText ] ]
]

{ #category : #'building ui' }
QuickEdit class >> buildCollectionValueUpdater: each [
	| aContainer anUndoButton aValueEditor displayPreviousValue item updateUnderlyingValue |
	item := each value.
	displayPreviousValue := [ (aValueEditor editor history
		instVarNamed: #currentGroup) undoOn: aValueEditor editor.
	anUndoButton visibility: BlVisibility gone ].
	updateUnderlyingValue := [ each key isArray
		ifTrue: [ each key second
				at: each key first
				put: (QuickEdit destringify: aValueEditor text asString) ]
		ifFalse: [ each value: (QuickEdit destringify: aValueEditor text asString) ] ].
	aContainer := BrHorizontalPane new
		hMatchParent;
		alignCenterLeft;
		vFitContent.
	aValueEditor := BrEditableLabel new
		aptitude: BrGlamorousEditableLabelAptitude new glamorousRegularFontAndSize;
		text: item gtDisplayString;
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
QuickEdit class >> buildItems: aCollection [
	^ (aCollection respondsTo: #associations)
		ifTrue: [ aCollection associations ]
		ifFalse: [ aCollection
				collectWithIndex: [ :anEntry :anIndex | 
					{anIndex.
					aCollection} -> anEntry ] ]
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
