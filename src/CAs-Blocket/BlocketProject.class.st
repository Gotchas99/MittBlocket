Class {
	#name : #BlocketProject,
	#superclass : #Object,
	#instVars : [
		'name',
		'searches',
		'result',
		'lastRefresh'
	],
	#category : #'CAs-Blocket'
}

{ #category : #'as yet unclassified' }
BlocketProject class >> isVoyageRoot [
    ^ true
]

{ #category : #'as yet unclassified' }
BlocketProject class >> newBlandare [
	| p |
	p := self new.
	p name: 'Blandare'.
	p addSearch: 'http://www.blocket.se/goteborg?q=*duschblandare*&cg=2000&w=1&st=s&ca=15&l=0&md=th'.

	p addSearch: 'http://www.blocket.se/goteborg?q=*termostat*+*blandare*&cg=2000&w=1&st=s&ca=15&l=0&md=th'.
"	p addSearch: 'http://www.blocket.se/goteborg?q=*blandare*&cg=2000&w=1&st=s&ca=15&l=0&md=th'."
	p refresh.
	^p
]

{ #category : #'as yet unclassified' }
BlocketProject class >> voyageCollectionName [
 ^ 'Projects'
]

{ #category : #'as yet unclassified' }
BlocketProject >> <= aProject [
	^self name <= aProject name
]

{ #category : #'as yet unclassified' }
BlocketProject >> addItem: anItem [
	result addIfNotPresent: anItem
]

{ #category : #'as yet unclassified' }
BlocketProject >> addSearch: aString [
" a search is a Blocket-URL that gives a list of items"
	searches add: aString
]

{ #category : #'as yet unclassified' }
BlocketProject >> initialize [
	name := 'Nytt projekt'.
	result := SortedCollection new.
	searches := SortedCollection new.
]

{ #category : #accessing }
BlocketProject >> name [
	^name
]

{ #category : #accessing }
BlocketProject >> name: aString [
	^name := aString
]

{ #category : #printing }
BlocketProject >> printOn: aStream [
	aStream 
		nextPutAll: 'BlocketProject(';
		nextPutAll: self name;
		nextPutAll: ')'.   
]

{ #category : #printing }
BlocketProject >> printString [
	^self name contractTo: 45
]

{ #category : #'as yet unclassified' }
BlocketProject >> refresh [
	| items gone |
	gone := result reject: [ :item | BlocketRobot new checkIfItemExists: item ].
	gone
		do: [ :item | 
			item gone.
			item isStarred
				ifFalse: [ self removeItem: item ] ].
	searches
		do: [ :searchText | 
			items := BlocketRobot new getList: searchText.
			items do: [ :item | self addItem: item ] ].
	lastRefresh := DateAndTime now
]

{ #category : #'as yet unclassified' }
BlocketProject >> removeSearch: aString [
" a search is a Blocket-URL that gives a list of items"
	searches remove: aString
]

{ #category : #'as yet unclassified' }
BlocketProject >> result [
	^result
]

{ #category : #'as yet unclassified' }
BlocketProject >> searches [
	^searches
]
