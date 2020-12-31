Class {
	#name : #QuickEdit,
	#superclass : #Object,
	#category : #'QuickEdit-Core'
}

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
		look: BrGlamorousEditableLabelLook new glamorousRegularFontAndSize;
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
		look: BrGlamorousButtonWithIconLook new;
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
