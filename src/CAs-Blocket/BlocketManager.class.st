Class {
	#name : #BlocketManager,
	#superclass : #Object,
	#instVars : [
		'projects'
	],
	#classVars : [
		'Current'
	],
	#category : #'CAs-Blocket'
}

{ #category : #'as yet unclassified' }
BlocketManager class >> current [
	Current ifNil: [ Current := self selectAll first].
	^Current
]

{ #category : #voyage }
BlocketManager class >> initDB [
	| repository |
	repository := VOMongoRepository database: 'blocket'.
	repository enableSingleton
]

{ #category : #voyage }
BlocketManager class >> initialize [
	super initialize.
	self initDB
]

{ #category : #voyage }
BlocketManager class >> isVoyageRoot [
    ^ true
]

{ #category : #voyage }
BlocketManager class >> mongoProjects [
	<mongoDescription>
	^ VOMongoToManyDescription new
		attributeName: 'projects';
		kindCollection: SortedCollection;
		convertNullToEmpty;
		beLazy;
		yourself
]

{ #category : #'as yet unclassified' }
BlocketManager class >> reset [
	self resetVoDescriptors.
	Current := nil
]

{ #category : #voyage }
BlocketManager class >> resetVoDescriptors [
	VOMongoRepository current flush
]

{ #category : #'as yet unclassified' }
BlocketManager class >> test [
	self new test
]

{ #category : #'as yet unclassified' }
BlocketManager class >> test2 [
"	^Current := self new test2"
]

{ #category : #voyage }
BlocketManager class >> voyageCollectionName [
 ^ 'Root'
]

{ #category : #'as yet unclassified' }
BlocketManager >> addProject: aProject [
	self projects add: aProject.
	self save

]

{ #category : #'as yet unclassified' }
BlocketManager >> initialize [
	projects := SortedCollection new
]

{ #category : #'as yet unclassified' }
BlocketManager >> isServiceAvailable [
	^ Mongo default isAvailable
]

{ #category : #'as yet unclassified' }
BlocketManager >> projects [
	projects ifNil: [projects := SortedCollection new].
	^projects
]

{ #category : #'as yet unclassified' }
BlocketManager >> refresh [
	projects := BlocketProject selectAll asSortedCollection
]

{ #category : #'as yet unclassified' }
BlocketManager >> removeProject: aProject [
	self projects remove: aProject.
	self save
]

{ #category : #'as yet unclassified' }
BlocketManager >> test [
	| b |
	b := BlocketMorph onRobot: (BlocketRobot new).
	b openInWorld
]

{ #category : #'as yet unclassified' }
BlocketManager >> test2 [
	| |
	self addProject: (BlocketProject newBlandare).
"	b := BlocketMorph on: self projects first.
	b openInWorld"
]
