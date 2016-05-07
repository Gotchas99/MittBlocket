Class {
	#name : #BlocketMain,
	#superclass : #BlocketPageRoot,
	#category : #'CAs-Blocket-Web'
}

{ #category : #'as yet unclassified' }
BlocketMain class >> canBeRoot [
	^true.
]

{ #category : #'as yet unclassified' }
BlocketMain class >> handlerName [
	^ 'blocket'
]

{ #category : #'as yet unclassified' }
BlocketMain class >> initFileLibrary [
	<script>
	BlocketFileLibrary addAllFilesIn: 'C:\Pharo4.0\webRes'
]

{ #category : #'as yet unclassified' }
BlocketMain class >> initialize [
	| app |
	app := WAAdmin register: self asApplicationAt: self handlerName.
	app
		addLibrary: BlocketFileLibrary;
		addLibrary: JQDeploymentLibrary;
		addLibrary: TBSDeploymentLibrary.
	^ app
]

{ #category : #'as yet unclassified' }
BlocketMain >> addProject [
	| s p |
	s := self request: 'Projektnamn'.
	s isEmptyOrNil
		ifFalse: [ 
			(p := BlocketProject new) name: s.
			BlocketManager current
				addProject: p;
				save ]
]

{ #category : #'as yet unclassified' }
BlocketMain >> initialize [
	super initialize.
]

{ #category : #'as yet unclassified' }
BlocketMain >> removeProject: aProject [
	(self confirm: 'Är du säker på att du vill ta bort?')
		ifTrue: [ 
			BlocketManager current
				removeProject: aProject;
				save ]
]

{ #category : #'as yet unclassified' }
BlocketMain >> renderContentOn: html [
	BlocketManager current isServiceAvailable
		ifTrue: [ BlocketManager current refresh ]
		ifFalse: [ html heading: 'Database is offline. Please fix <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<' ].
	html heading: 'Blocket projekt'.
	html anchor
		callback: [ self addProject ];
		with: 'Nytt projekt'.
	html
		break;
		break;
		heading: 'Projektlista';
		break.
	BlocketManager current projects
		do: [ :p | 
			html anchor
				callback: [ self showProject: p ];
				with: p printString.
			html text: '   -   '.
			html anchor
				callback: [ self removeProject: p ];
				with: 'Ta bort'.
			html break ].
	html break
]

{ #category : #'as yet unclassified' }
BlocketMain >> showProject: aBlocketProject [ 
	self call:(BlocketProjPage new project:aBlocketProject )
]
