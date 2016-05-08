Class {
	#name : #BlocketProjPage,
	#superclass : #BlocketPageRoot,
	#instVars : [
		'project'
	],
	#category : #'CAs-Blocket-Web'
}

{ #category : #actions }
BlocketProjPage >> dontShow: anItem [
	anItem dontShow
]

{ #category : #initialize }
BlocketProjPage >> initialize [
	super initialize.
]

{ #category : #accessing }
BlocketProjPage >> project:aBlocketProject [
	project:= aBlocketProject 
]

{ #category : #rendering }
BlocketProjPage >> renderContentOn: html [
	| p |
	html
		tbsContainer: [ 
			html heading: project printString.
			"html div
				class: #pageHeader;
				with: project printString."
			html
				tbsForm: [ 
					"html
		paragraph: [ 
			html anchor
				callback: [ self back ];
				with: 'Tillbaka'.
			html anchor
				callback: [ self showSearch ];
				with: 'Visa sökningar'.
			html div
				style: 'float:right';
				with: [ 
							html anchor
								callback: [ self updateSearch ];
								with: 'Uppdatera' ] ]."
					self renderNavOn: html.
					html break;break.
					"html div
						class: #pageHeader;
						with: 'Resultat'."
					p := project result reject: [ :i | i isDontShow ].
					html unorderedList
						class: #results;
						with: [ p reverse do: [ :i | self renderItem: i on: html ] ] ] ].
	html jQuery ajax
		callback: [  ];
		interval: 30000	"auto-refresh"
]

{ #category : #rendering }
BlocketProjPage >> renderItem: i on: html [
	^ html listItem
		class: 'item-box';
		with: [ 
					html div
						class: 'thumb-div';
						with: [ 
									html div
										class: #new;
										with: i newMark.
									html div
										class: #gone;
										with: i goneMark.
									i thumb
										ifNotNil: [ 
											html anchor
												callback: [ self showItem: i ];
												with: [ 
															html image
																class: #thumb;
																url: i thumb ] ].
									i isStarred
										ifTrue: [ 
											html image
												class: 'star-icon';
												url: (BlocketFileLibrary urlOf: #stargold48Png) ] ].
					html div
						class: 'title-box';
						with: [ 
									html div
										class: #title;
										with: [ 
													html anchor
														callback: [ self showItem: i ];
														class: #title;
														with: i title ].
									html div
										class: #datum;
										with: i area .
									html div
										class: #datum;
										with: i dateTimeString.
									html div
										class: #pris;
										with: i price ].
					html div
						class: 'dont-show';
						with: [ 
									html anchor
										callback: [ self dontShow: i ];
										with: [ 
													html image
														class: 'delete-icon';
														url: (BlocketFileLibrary urlOf: #deletePng) ] ].
					html break.
					html break	"html anchor
						callback: [ self showItem: i ];
						with: [ html span class: 'link-spanner' ] " ]
]

{ #category : #actions }
BlocketProjPage >> renderNavOn: html [
	html tbsButton
		beDefault;
		callback: [ self answer ];
		with: 'Stäng'.
	html space.
	html tbsButton
		beDefault;
		callback: [ self showSearch ];
		with: 'Visa sökningar'.
	html space.
	html tbsButton
		beSuccess;
		callback: [ self updateSearch ];
		with: 'Uppdatera'.
	html space
]

{ #category : #actions }
BlocketProjPage >> showItem: aBlockItem [
	self call: (BlocketItemPage new item: aBlockItem)
]

{ #category : #actions }
BlocketProjPage >> showSearch [
	self call: (BlocketSearchPage new project: project)
]

{ #category : #actions }
BlocketProjPage >> updateSearch [
	project refresh
]
