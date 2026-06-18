# VVJValidator

A tool to validate and test VerveineJ models creations using Delta Debugging and file shuffling.

## Baseline
```Smalltalk
Metacello new
	baseline: 'VVJValidator';
	repository: 'github://moosetechnology/VVJValidator:main/src';
	load
```

## How to use the VerveineJ Validator
TODO

## How it works ?
### Load a model with the Loader
First of all, you need to load the files you want to compare and the .jar from VerveineJ.
The loader will parse the file list with VerveineJ, and load it into a model.

```Smalltalk

files := #('/home/user/path/to/your/java/file/file.java'
		'/home/user/path/to/your/java/file/file2.java'
		'/home/user/path/to/your/java/file/fileN.java').

jar := '/home/user/path/to/VVJ/jar/VerveineJ/app/build/libs/VerveineJ-Snapshot.jar' asFileReference .

model := VVJLoader new
	jar: jar;
	paths: files;
	load.

e := model entityNamed: 'org.apache.commons.collections.ArrayStack.ArrayStack()'.
e incomingInvocations size
```

### Isolate a bug with VVJDDMin
We uses the Delta Debugging (DDMin) algorithm to isolate the minimal set of files reproducing a specific bug in the model. 
Find below an example with `MapUtils` and `ArrayStack` from Commons Collections:

```Smalltalk
jar := '/home/user/VerveineJ/app/build/libs/VerveineJ-Snapshot.jar' asFileReference.

files := #(
'/home/user/commons_collections/commons-collections-3.1-src/src/java/org/apache/commons/collections/ArrayStack.java'
'/home/user/commons_collections/commons-collections-3.1-src/src/java/org/apache/commons/collections/MapUtils.java'
).

minResult := VVJDDMin new
	             jar: jar;
	             run: files asserting: [ :loader :model |
			             | mu as |
			             "loading our entities"
			             mu := model entityNamed: 'org.apache.commons.collections.MapUtils'.
			             as := model entityNamed: 'org.apache.commons.collections.ArrayStack.ArrayStack()'.

			             "A model is ok if the problematic entities are not there"
			             as isNil or: [
						             mu isNil or: [
									             as isStub or: [ "But if they are there, then ArrayStack should have 2 incoming invocations!"
											             as incomingInvocations size = 2 ]]]].
```

### Shuffler

# WIP
