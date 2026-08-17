"
```smalltalk

VVJShuffler new 
	jar: jar;
	shuffleUntilDiff: ccFiles.
```
"
Class {
	#name : 'VVJShuffler',
	#superclass : 'Object',
	#instVars : [
		'jar',
		'maxTimes',
		'firstModel'
	],
	#category : 'VVJValidator',
	#package : 'VVJValidator'
}

{ #category : 'accessing' }
VVJShuffler >> firstModel [
	^ firstModel
]

{ #category : 'accessing' }
VVJShuffler >> initialize [

	super initialize.
	maxTimes := 30
]

{ #category : 'accessing' }
VVJShuffler >> jar: aJarPath [

	jar := aJarPath
]

{ #category : 'accessing' }
VVJShuffler >> maxTimes [

	^ maxTimes
]

{ #category : 'accessing' }
VVJShuffler >> maxTimes: anObject [

	maxTimes := anObject
]

{ #category : 'accessing' }
VVJShuffler >> offending: aModel [

	^ VVJShufflerOffendingResult new
		shuffler: self;
		offending: aModel
]

{ #category : 'accessing' }
VVJShuffler >> ok [

	^ VVJShufflerOKResult new
		shuffler: self;
		yourself
]

{ #category : 'accessing' }
VVJShuffler >> shuffle: files until: aBlock [

	| shuffled loader model |
	maxTimes = 0 ifTrue: [ ^ self ok ].

	shuffled := files shuffled.

	'shuffle.log' asFileReference writeStreamDo: [ :str |
			shuffled do: [ :e |str nextPutAll: e; cr ] ].
		
	loader := VVJLoader new
		          jar: jar;
		          paths: shuffled;
					 options: #('-strict').

	[
		model := loader load.
		"Should stop?"
		(aBlock value: loader value: model) ifTrue: [
			^ self offending: model ] ]
		on: Error
		do: [ :ex | "when we have an error, we should return it. Nil = crash"
			^ self offending: nil ].

	"Ok, once more"
	maxTimes := maxTimes - 1.
	^ self shuffle: shuffled until: aBlock
]

{ #category : 'accessing' }
VVJShuffler >> shuffleUntilDiff: files [

	^ self shuffle: files until: [ :loader :model |
		| areEqual destination1 destination2|
		
		destination1 := 'offendingModel1.json' asFileReference.
		destination2 := 'offendingModel2.json' asFileReference.
		
		firstModel ifNil: [
				firstModel := model.
				destination1 ensureDelete 
				loader outputFilePath copyTo: destination1 ].
			
		areEqual := FamixSimpleDiff new
			compareModel: firstModel
			to: model.
			
		"we keep the offending models when we find someone"
		areEqual not ifTrue: [ 
			destination2 ensureDelete.
			loader outputFilePath moveTo: destination2.
		].
	
		areEqual not ]
]
