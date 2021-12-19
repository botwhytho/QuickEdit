Extension { #name : #NeoJSONObject }

{ #category : #'*QuickEdit' }
NeoJSONObject class >> fromStringUseArrays: string [

	^ self fromString: string
]

{ #category : #'*QuickEdit' }
NeoJSONObject class >> fromStringUseOrderedCollections: string [

	^ (NeoJSONReader on: string readStream)
		  mapClass: NeoJSONObject;
		  listClass: OrderedCollection;
		  propertyNamesAsSymbols: true;
		  next
]
