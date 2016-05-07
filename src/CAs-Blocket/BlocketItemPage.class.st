Class {
	#name : #BlocketItemPage,
	#superclass : #BlocketPageRoot,
	#instVars : [
		'item'
	],
	#category : #'CAs-Blocket-Web'
}

{ #category : #'as yet unclassified' }
BlocketItemPage >> dontShow [
	item
		dontShow;
		save.
	self answer
]

{ #category : #'as yet unclassified' }
BlocketItemPage >> initialize [
	super initialize.
]

{ #category : #'as yet unclassified' }
BlocketItemPage >> item: aBlocketItem [
	item := aBlocketItem.
	item
		viewed;
		save
]

{ #category : #'as yet unclassified' }
BlocketItemPage >> openWeb [
	self requestContext redirectTo: item url
]

{ #category : #'as yet unclassified' }
BlocketItemPage >> refresh [
	item refresh
]

{ #category : #'as yet unclassified' }
BlocketItemPage >> renderCarouselOn: html [
	| id |
	id := '#carousel-example-generic'.
	html div
		style: 'width: 500px; height: 500px;';
		with: [ 
					html tbsCarousel
						id: id;
						slide;
						with: [ 
									html
										tbsCarouselIndicators: [ 
											html listItem
												attributeAt: 'data-target' put: id;
												attributeAt: 'data-slide-to' put: 0;
												class: 'active'.
											html listItem
												attributeAt: 'data-target' put: id;
												attributeAt: 'data-slide-to' put: 1.
											html listItem
												attributeAt: 'data-target' put: id;
												attributeAt: 'data-slide-to' put: 2 ].
									html
										tbsCarouselInner: [ 
											html div
												class: 'item active';
												with: [ html image url: item images first ].
											html div
												class: 'item';
												with: [ html image url: item images second].
											html div
												class: 'item';
												with: [ html image url: item images third ] ].
									html tbsCarouselControlLeftFor: id.
									html tbsCarouselControlRightFor: id ] ].
	html script: '$(''.carousel'').carousel()'
]

{ #category : #'as yet unclassified' }
BlocketItemPage >> renderContentOn: html [
	html
		tbsContainer: [ 
			item isStarred
				ifTrue: [ html image url: (BlocketFileLibrary urlOf: #stargold48Png) ].
			html heading: item title.
			html
				tbsForm: [ 
					self renderNavOn: html.
					html
						break;
						break.	"self renderCarouselOn: html."
					item images
						ifNil: [ item thumb ifNotNil: [ html image url: item thumb ] ]
						ifNotNil: [ item images do: [ :i | html image url: i ] ].
					html break.
					html withLineBreaks: item desc ].
			html break ].
	html jQuery ajax
		callback: [  ];
		interval: 30000	"auto-refresh"
]

{ #category : #'as yet unclassified' }
BlocketItemPage >> renderDesc: aDesc [
	| tmp |
	tmp := aDesc.self halt.
	tmp:=tmp copyReplaceAll: Character cr asString with: '<br>'.
	^ tmp
]

{ #category : #'as yet unclassified' }
BlocketItemPage >> renderNavOn: html [
	html tbsButton
		beDefault;
		callback: [ self answer ];
		with: 'Stäng'.
	html space.	"html anchor
		callback: [ self answer ];
		with: 'Stäng'.
	html text: '   --   '."
	html tbsButton
		beDanger;
		callback: [ self dontShow ];
		with: 'Visa inte igen'.
	html space.	"html anchor
		callback: [ self dontShow ];
		with: 'Visa inte igen'."	"html text: '   --   '."
	html tbsButton
		beWarning;
		callback: [ self starred ];
		with: 'Stjärnmärkt'.
	html space.	"	html anchor
		callback: [ self starred ];
		with: 'Stjärnmärkt'.
	html text: '   --   '."
	html tbsButton
		beSuccess;
		callback: [ self refresh ];
		with: 'Uppdatera'.
	html space.	"html anchor
		callback: [ self refresh ];
		with: 'Uppdatera'.
	html text: '   --   '."
	html tbsButton
		beDefault;
		callback: [ self openWeb ];
		with: 'Öppna web'.
	html space	"html anchor
		callback: [ self openWeb ];
		with: 'Öppna web'."
]

{ #category : #'as yet unclassified' }
BlocketItemPage >> starred [
	item
		starred;
		save
]
