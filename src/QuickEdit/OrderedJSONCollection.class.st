Class {
	#name : #OrderedJSONCollection,
	#superclass : #OrderedCollection,
	#category : #'QuickEdit-Core'
}

{ #category : #'reflective operations' }
OrderedJSONCollection >> doesNotUnderstand: message [
	"Overwritten so that 'self [aNumber]th'  becomes 'self at: aNumber' for
	when nested collectopms are encountered.
	Likewise, 'self [aNumber]th: 1' becomes 'self at: aNumber put: 1'.
	"

	| key num |
	key := message selector.
	key isUnary
		ifTrue: [ ((key beginsWith: 'nth')
				and: [ num := Number readFrom: (key allButFirst: 3) ifFail: [ nil ].
					num isNumber ]) ifTrue: [ ^ self at: num ] ].
	(key isKeyword and: [ key numArgs = 1 ])
		ifTrue: [ ((key beginsWith: 'nth')
				and: [ num := Number readFrom: (key allButFirst: 3) allButLast ifFail: [ nil ].
					num isNumber ]) ifTrue: [ ^ self at: num put: message arguments first ] ].
	^ super doesNotUnderstand: message
]
