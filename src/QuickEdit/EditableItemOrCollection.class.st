Class {
	#name : #EditableItemOrCollection,
	#superclass : #Object,
	#instVars : [
		'collection',
		'parent',
		'value',
		'index'
	],
	#category : #'QuickEdit-Core'
}

{ #category : #accessing }
EditableItemOrCollection >> collection [

	^ collection
]

{ #category : #accessing }
EditableItemOrCollection >> collection: aCollection [
	collection := aCollection
]

{ #category : #accessing }
EditableItemOrCollection >> index [

	^ index
]

{ #category : #accessing }
EditableItemOrCollection >> index: anObject [

	index := anObject
]

{ #category : #accessing }
EditableItemOrCollection >> parent [

	^ parent
]

{ #category : #accessing }
EditableItemOrCollection >> parent: anObject [

	parent := anObject
]

{ #category : #accessing }
EditableItemOrCollection >> value [
	^ value
]

{ #category : #accessing }
EditableItemOrCollection >> value: anObject [

	value := anObject
]
