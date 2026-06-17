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

### Loader
First of all, you need to load the files you want to compare and the .jar from VerveineJ.
The loader will parse the file list with VerveineJ, and load it into the model.

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

### DDMin
### Shuffler

# WIP
