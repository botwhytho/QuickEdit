Class {
	#name : #BrUndoableLabel,
	#superclass : #BrEditableLabel,
	#instVars : [
		'value',
		'object',
		'entityType',
		'entities'
	],
	#category : #'QuickEdit-Core'
}

{ #category : #accessing }
BrUndoableLabel class >> value: aValue object: anObject updateEntity: aSymbol [
	^ self new
		value: aValue;
		text: aValue value gtDisplayString;
		object: anObject;
		entityType: aSymbol
]

{ #category : #accessing }
BrUndoableLabel >> displayPrevious [
	(self editor history instVarNamed: #currentGroup) undoOn: self editor
]

{ #category : #accessing }
BrUndoableLabel >> entityType: aSymbol [
	entityType := aSymbol
]

{ #category : #accessing }
BrUndoableLabel >> initialize [
	super initialize.
	self
		aptitude: BrGlamorousEditableLabelAptitude new glamorousRegularFontAndSize;
		margin: (BlInsets all: 0);
		whenKey: BlKeyCombination primaryR
			labelDo: [ :aShortcutEvent | aShortcutEvent currentTarget switchToEditor ];
		whenKey: BlKeyCombination primaryZ labelDo: [ :aShortcutEvent | self undo ];
		whenKey: BlKeyCombination primaryC
			labelDo: [ :aShortcutEvent | Clipboard clipboardText: self text asString ].
	self editor history instVarNamed: #shouldGroup put: true.
	entities := {#slot -> #updateSlotValue.
			#collection -> #updateCollectionValue} asDictionary
]

{ #category : #accessing }
BrUndoableLabel >> object: anObject [
	object := anObject
]

{ #category : #accessing }
BrUndoableLabel >> undo [
	self displayPrevious.
	self updateValue
]

{ #category : #accessing }
BrUndoableLabel >> updateCollectionValue [
	(value respondsTo: #key)
		ifTrue: [ value value value: (QuickEdit destringify: self text asString) ]
		ifFalse: [ value collection
				at: value index
				put: (QuickEdit destringify: self text asString) ]
]

{ #category : #accessing }
BrUndoableLabel >> updateSlotValue [
	object
		instVarNamed: value label
		put: (QuickEdit destringify: self text asString)
]

{ #category : #accessing }
BrUndoableLabel >> updateValue [
	self perform: (entities at: entityType)
]

{ #category : #accessing }
BrUndoableLabel >> value: aValue [
	value := aValue
]
