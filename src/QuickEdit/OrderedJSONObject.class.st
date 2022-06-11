Class {
	#name : #OrderedJSONObject,
	#superclass : #OrderedDictionary,
	#category : #'QuickEdit-Core'
}

{ #category : #convenience }
OrderedJSONObject class >> fromString: string [
	"Parse string as JSON, so that maps become instances of me"

	^ (NeoJSONReader on: string readStream)
		mapClass: OrderedJSONObject;
		listClass: OrderedJSONCollection;
		propertyNamesAsSymbols: true;
		next
]

{ #category : #accessing }
OrderedJSONObject >> at: key [
	"I return nil for missing keys.
	My superclass would signal a KeyNotFound."
	
	^ self at: key ifAbsent: [ nil ]
]

{ #category : #accessing }
OrderedJSONObject >> atPath: keyCollection [
	"Use each key in keyCollection recursively, stop when nil is encountered"
	
	| value |
	value := self.
	keyCollection do: [ :each |
		value := value at: each.
		value ifNil: [ ^ nil ] ].
	^ value 
]

{ #category : #accessing }
OrderedJSONObject >> atPath: keyCollection put: newValue [
	"Use each key in keyCollection recursively, create new levels when needed"
	
	| target |
	keyCollection ifEmpty: [ ^ self ].
	target := self.
	keyCollection allButLastDo: [ :each |
		(target at: each)
			ifNil: [ target := target at: each put: target species new ]
			ifNotNil: [ :subValue | target := subValue ] ].
	^ target at: keyCollection last put: newValue
]

{ #category : #'reflective operations' }
OrderedJSONObject >> doesNotUnderstand: message [
	"Overwritten so that 'self foo' becomes 'self at: #foo'
	and 'self foo: 1' becomes 'self at: #foo put: 1' except that self is returned"

	| key |
	key := message selector.
	key isUnary ifTrue: [ ^ self at: key ].
	^ (key isKeyword and: [ key numArgs = 1 ])
		ifTrue: [ self
				at: key allButLast asSymbol put: message arguments first;
				yourself ]
		ifFalse: [ super doesNotUnderstand: message ]
]

{ #category : #accessing }
OrderedJSONObject >> name [
	"Overwritten to make this accessor available as key"
	
	^ self at: #name
]

{ #category : #printing }
OrderedJSONObject >> printOn: stream [
	"I use my JSON representation when printing myself"

	[ (NeoJSONWriter on: stream)
		prettyPrint: true;
		nextPut: self ]
		on: Error
		do: [ :exception | 
			stream
				nextPutAll: ' Error printing JSON: ';
				nextPutAll: exception printString ]
]

{ #category : #evaluating }
OrderedJSONObject >> value [
	"Overwritten to make this accessor available as key"
	
	^ self at: #value
]
