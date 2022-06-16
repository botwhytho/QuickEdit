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
EditableItemOrCollection >> dropdownDown [
	| aptitude |
	aptitude := BrGlamorousWithDropdownAptitude
			stencil: [  "aSpotterModel announcer
					when: GtSpotterActOn
					do: [ :e | 
						(#(singleClick doubleClick keyPressed) includes: e eventType)
							ifTrue: [ aptitude hide ] ]."BlElement
					new
					aptitude: (BrGlamorousDropdownAptitude new
							handle: (BrButton new
									aptitude: BrGlamorousButtonWithIconAptitude - BrGlamorousButtonWithLabelTooltipAptitude
											- BrGlamorousButtonExteriorAptitude;
									icon: BrGlamorousVectorIcons downwards;
									yourself);
							content: (BlElement new
									constraintsDo: [ :c | 
										c horizontal exact: 600.
										c vertical exact: 400 ];
									yourself);
							yourself);
					background: BrGlamorousColors secondaryHeaderBackgroundColor;
					yourself ].
	^ aptitude
]

{ #category : #accessing }
EditableItemOrCollection >> dropdownUp [
	| aptitude |
	aptitude := BrGlamorousWithDropdownAptitude
			stencil: [  "aSpotterModel announcer
					when: GtSpotterActOn
					do: [ :e | 
						(#(singleClick doubleClick keyPressed) includes: e eventType)
							ifTrue: [ aptitude hide ] ]."BlElement
					new
					aptitude: (BrGlamorousDropdownAptitude new
							handle: (BrButton new
									aptitude: BrGlamorousButtonWithIconAptitude - BrGlamorousButtonWithLabelTooltipAptitude
											- BrGlamorousButtonExteriorAptitude;
									icon: BrGlamorousVectorIcons upwards;
									yourself);
							content: (BlElement new
									constraintsDo: [ :c | 
										c horizontal exact: 600.
										c vertical exact: 400 ];
									yourself);
							yourself);
					background: BrGlamorousColors secondaryHeaderBackgroundColor;
					yourself ].
	^ aptitude
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
