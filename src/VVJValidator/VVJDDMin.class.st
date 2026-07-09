"
```smalltalk
jar := FileLocator home / 'git/VerveineJ/app/build/libs/VerveineJ-Snapshot.jar'.
minResult := VVJDDMin new
	jar: jar;
	run: ccFiles
	asserting: [ :loader :model | | mu as |
		""The model is ok if...""
		mu := model entityNamed: 'org.apache.commons.collections.MapUtils'.
		as := model entityNamed: 'org.apache.commons.collections.ArrayStack.ArrayStack(int)'.
		""A model is ok if the problematic entities are not there""
		as isNil or: [ mu isNil or: [ as isStub or: [
			""But if they are there, then ArrayStack should have 2 incoming invocations!""
				as incomingInvocations size = 2] ] ]
].
```
"
Class {
	#name : 'VVJDDMin',
	#superclass : 'Object',
	#instVars : [
		'jar'
	],
	#category : 'VVJValidator',
	#package : 'VVJValidator'
}

{ #category : 'as yet unclassified' }
VVJDDMin >> jar: aJarPath [

	jar := aJarPath
]

{ #category : 'as yet unclassified' }
VVJDDMin >> run: files asserting: aBlock [

	| ddmin |
	ddmin := AnonymousDDMin testing: [ :vvjInputFiles |
			         | loader model isOK |
			         loader := VVJLoader new
				                   jar: jar;
				                   paths: vvjInputFiles.

			         isOK := false.

			         "catch the error of VVJ"
			         [ "non crash case"
				         model := loader load.
				         isOK := aBlock value: loader value: model ]
			
				         on: Error do: [ :ex | "crash case, we don't keep the file"
				         isOK := false ].
			         isOK ].
	^ ddmin reduce: files
]
