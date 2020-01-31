# About HW3: Java

We don't have hint code for Java. And we don't think you need any hint code to get it done. For further information on the file format please visit [tutorial](https://docs.oracle.com/javase/tutorial/deployment/jar/index.html). For more on threads and locks [official language spec](https://docs.oracle.com/javase/specs/jls/se13/html/index.html) [Chapter 17](https://docs.oracle.com/javase/specs/jls/se13/html/jls-17.html)

Remember **not** to include your name / ID in report.


## About the .jar format

### To Unzip the .jar file
```bash
jar xf jmm.jar
```
Then you should see the *jmm* folder.

### To zip your solutions
```bash
jar cvf jmmplus.jar *.java
```

## Explanations of Requirements

All in homework spec.

## To compile
```bash
javac *.java
```

## To run / test

For your debugging purpose (just an example, you should try different parameters):
```bash
java UnsafeMemory Synchronized 8 100000000 5
```
means run our **UnsafeMemory** java class with parameters: ```Synchronized 8 100000000 5```.
- **SynchronizedState** implementation
- divide the work into **8** threads of roughly equal size
- do **100000000** swap transitions total
- use a state array of **5** entries



