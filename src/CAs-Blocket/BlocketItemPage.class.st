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
BlocketItemPage >> renderContentOn: html [
	html heading: item title.
	html anchor
		callback: [ self answer ];
		with: 'Stäng'.
	html text: '   --   '.
	html anchor
		callback: [ self dontShow ];
		with: 'Visa inte igen'.
	html text: '   --   '.
	html anchor
		callback: [ self starred ];
		with: 'Stjärnmärkt'.
	html text: '   --   '.
	html anchor
		callback: [ self refresh ];
		with: 'Uppdatera'.
	html text: '   --   '.
	html anchor
		callback: [ self openWeb ];
		with: 'Öppna web'.
	html break.
	item images
		ifNil: [ item thumb ifNotNil: [ html image url: item thumb ] ]
		ifNotNil: [ html image url: item images first ].
	html break.	
	html withLineBreaks: item desc.
	html break.
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
BlocketItemPage >> starred [
	item
		starred;
		save
]
