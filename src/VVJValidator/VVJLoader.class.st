"
```smalltalk
files := #(
		'/Users/guille/Downloads/cc31/apache/commons/collections/ArrayStack.java'
		'/Users/guille/Downloads/cc31/apache/commons/collections/MapUtils.java').
jar := FileLocator home / 'git/VerveineJ/app/build/libs/VerveineJ-Snapshot.jar'.

model := VVJLoader new
	jar: jar;
	paths: files;
	load.

e := model entityNamed: 'org.apache.commons.collections.ArrayStack.ArrayStack()'.
e incomingInvocations size
```
"
Class {
	#name : 'VVJLoader',
	#superclass : 'Object',
	#instVars : [
		'jar',
		'outputFilePath',
		'paths'
	],
	#category : 'VVJValidator',
	#package : 'VVJValidator'
}

{ #category : 'parsing' }
VVJLoader >> import [

	^ outputFilePath readStreamDo: [ :st | FamixJavaModel new importFromJSONStream: st ].
]

{ #category : 'parsing' }
VVJLoader >> initialize [

	super initialize.
	outputFilePath := (FileSystem workingDirectory / ('output-', UUID new asString)) , 'json'
]

{ #category : 'accessing' }
VVJLoader >> jar [

	^ jar
]

{ #category : 'accessing' }
VVJLoader >> jar: anObject [

	jar := anObject
]

{ #category : 'parsing' }
VVJLoader >> load [

	| model |
	self parse.
	model := self import.
	outputFilePath ensureDelete. "we delete the model after use"
	^ model
]

{ #category : 'accessing' }
VVJLoader >> outputFilePath [

	^ outputFilePath
]

{ #category : 'accessing' }
VVJLoader >> outputFilePath: anObject [

	outputFilePath := anObject
]

{ #category : 'parsing' }
VVJLoader >> parse [

	| err |
	self validate.

	OSSUnixSubprocess new
			command: '/usr/bin/java';
			arguments: {
				'-jar'.
				jar fullName.
				'-format'.
				'json'.
				'-o'.
				outputFilePath fullName.
				'-jdkMode'.
				'-1.7'.
			}, paths;
			redirectStdout;
			redirectStderr;
			runAndWaitPollingEvery: (Delay forMilliseconds: 50)
			retrievingStreams: true onExitDo: [ :command :outString :errString | 
				err := errString ].
			
	err ifNotEmpty: [ 
		self error: 'Errors while parsing: ', err ].
]

{ #category : 'accessing' }
VVJLoader >> paths [

	^ paths
]

{ #category : 'accessing' }
VVJLoader >> paths: anObject [

	paths := anObject
]

{ #category : 'parsing' }
VVJLoader >> validate [
	
	jar asFileReference exists ifFalse: [ 
		self error: 'Missing vvj jar file' ].
]
