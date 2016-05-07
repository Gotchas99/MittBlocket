Class {
	#name : #BlocketRobot,
	#superclass : #WRHttpRobot,
	#classVars : [
		'MonthMap'
	],
	#category : #'CAs-Blocket'
}

{ #category : #'as yet unclassified' }
BlocketRobot class >> initialize [
	MonthMap := Dictionary new.
	MonthMap at: 'jan' put: 1.
	MonthMap at: 'feb' put: 2.
	MonthMap at: 'mar' put: 3.
	MonthMap at: 'apr' put: 4.
	MonthMap at: 'maj' put: 5.
	MonthMap at: 'jun' put: 6.
	MonthMap at: 'jul' put: 7.
	MonthMap at: 'aug' put: 8.
	MonthMap at: 'sept' put: 9.
	MonthMap at: 'okt' put: 10.
	MonthMap at: 'nov' put: 11.
	MonthMap at: 'dec' put: 12
]

{ #category : #actions }
BlocketRobot >> checkIfItemExists: aBlocketItem [
	| main |
	[ self newGet: aBlocketItem url ]
		on: Error
		do: [ :e | 
			self halt.
			self traceCr: 'checkIfItemExist:Error'
			e signal ].
	self checkOk.
	self parseBody.
	(dom innerContents includesSubstring: 'Hittade inte annonsen')
		ifTrue: [ ^ false ].
	main := dom tagWithClass: 'view'.
	main ifNil: [ ^ false ].
	^ true
]

{ #category : #actions }
BlocketRobot >> getItemFromUrl: url [
	| main |
	[ self newGet: url ]
		on: Error
		do: [ :e | ^ nil ].
	self checkOk.	
	self parseBody.
	(dom innerContents includesSubstring: 'Hittade inte annonsen')
		ifTrue: [ ^ #notFound ].
	main := dom tagWithClass: 'view'.
	main ifNil: [ ^ nil ].
	^ self parseItem: main
]

{ #category : #actions }
BlocketRobot >> getList: aURL [
	| rows |
	self newGet: aURL.
	self checkOk.
	self parseBody.
	rows := self parseRows: (dom tagsWithClass: 'item_row').
	^ rows
]

{ #category : #testcode }
BlocketRobot >> getTest [
	| main rows sidorHtml |
	self newGet: 'http://www.blocket.se/goteborg-angransande-lan'.
	self checkOk.
	
	"Parse page"
	self parseBody.
"self halt."
	main := dom tagWithId: 'blocket'.
	sidorHtml := main tagWithId: 'all_pages'.
	main := main tagWithClass: 'list_mode_thumb'.
	rows := self parseRows: (dom tagsWithClass: 'item_row') .
	^rows
	"
	(request url urlString includesSubString: 'WeAreClosed') ifTrue: [self error: 'Closed'].
	form := dom tagWithId: 'loginForm'.
		""Send a post to actually login""
	request openPostTo: form action.
	fields := Dictionary new.

	""Build request""
	request addHeader: 'Content-Type' value: 'application/x-www-form-urlencoded'.
	request entityString: (self argString: fields).

	(request responseBody includesSubString: 'You did something wrong') ifTrue: [self error: 'Something went wrong'].
"
]

{ #category : #parsing }
BlocketRobot >> parseArea: html [
	| pull area |
	pull := html tagWithClass:'pull-left'.
	area := pull children last innerContents.
	area := area copyReplaceAll: ',&nbsp;' with: ''.
	^ area
]

{ #category : #parsing }
BlocketRobot >> parseDate: aString [
	| d split m date |
	aString = 'Igår' ifTrue: [ ^DateAndTime yesterday ].
	aString = 'Idag' ifTrue: [ ^DateAndTime today ].
	split := aString findTokens: ' '.
	d := (split at: 1) asInteger.
	m := MonthMap at: (split at: 2).
	date := Date year: (DateAndTime today year) month: m day: d.
	date > (DateAndTime today) ifTrue: [
		date := Date year: (DateAndTime today year)-1 month: m day: d.
		].
	^date
]

{ #category : #parsing }
BlocketRobot >> parseDesc: html [
	| txt |
	txt := ''.
	html children
		do: [ :i | 
			i tag = 'br'
				ifTrue: [ txt := txt , String cr ].
			i isCDATA
				ifTrue: [ txt := txt , i innerContents trimmed ] ].	"first innerContents withBlanksTrimmed."	"		tag := html tagWithClass: 'list_price'.
		(tag = 'a')  ifTrue: [tag := tag children first].
		^tag children first innerContents withBlanksTrimmed"
	^ txt
]

{ #category : #parsing }
BlocketRobot >> parseItem: html [
	| flds t carousel images imgs |
	flds := Dictionary new.
	t := (html tagOfClass: HtmlH1Node) innerContents trimmed.
	flds at: #title put: t.
	t := self parseDesc: (html tagWithClass: 'body').
	flds at: #desc put: t.
	(html tagWithId: 'price_container')
		ifNotNil: [ :details | 
			t := (details tagWithId: 'vi_price') innerContents trimmed.
			flds at: #price put: t.
			t := details tagWithClass: 'text_secondary'.
			t ifNotNil: [ flds at: #oldPrice put: t innerContents trimmed ] ].
	images := OrderedCollection new.
	carousel := html tagWithClass: 'carousel-inner'.
	imgs := carousel tagsOfClass: HtmlIMGNode.
	images := imgs collect: [ :img | img attributes at: 'data-src' ].
	flds at: #images put: images.
	^ flds
]

{ #category : #parsing }
BlocketRobot >> parseRows: listHtml [
	| r rows title cat dt mediaBody  |
	rows := OrderedCollection new.
	listHtml
		do: [ :html | 
			r := BlocketItem new.	"html: html"
			r id: (html attributes at: 'id').
			mediaBody := html children second.
			dt := mediaBody children first children second attributes at: #datetime.
			r dateTime: dt asDateAndTime.
			r thumb: (self parseThumb: html).
			title := mediaBody tagWithClass: 'item_link'.
			r title: title innerContents trimmed.
			r url: title href.
			r priceCut: (mediaBody tagWithClass: 'blocket-icon-price-lowered') notNil.
			r priceCut
				ifTrue: [ r price: (mediaBody tagWithClass: 'list_price') children first innerContents trimmed ]
				ifFalse: [ r price: (mediaBody tagWithClass: 'list_price') innerContents trimmed ].
			cat := mediaBody children first children first children first.
			r category: cat innerContents trimmed.
			r area: (self parseArea: mediaBody).
			rows add: r ].
	^ rows
]

{ #category : #parsing }
BlocketRobot >> parseThumb: html [
	| imgCont img |
	imgCont := html tagWithClass: 'image_container'.
	img := imgCont tagOfClass: HtmlIMGNode.
	img ifNil: [ ^ nil ].
	^ img attributes at: 'longdesc' ifAbsent: img src
]
