## Pointer
A *pointer* is a variable that holds the location in memory where a value is stored. Every variable is stored in one or more contiguous memory locations, called *addresses*. Different type of variables can take up different amount of memory. 
A pointer is a variable that contains the address where another variable is stored. 
Here is the demonstration how pointers are stored in memory
```Go
var x int32 = 10
var y bool = true
pointerX := &x
pointerY := &y
var pointerZ *string

fmt.Println("X, Y, Z addresses in memory are: ", pointerX, pointerY, pointerZ)
```
```Output
X, Y, Z addresses in memory are:  0x1400000e114 0x1400000e118 <nil>
```
A pointer holds a number that indicates the location in memory where the data being pointed to is stored. That number is called the *address*.

> The zero value for a pointer is `nil` 

Go's pointer syntax is partially borrowed from C and C++. Since Go has a garbage collector, most memory management pain is removed. Further more, some tricks that you can do with pointers in C and C++, including *pointer arithmetic*, are not allowed in Go.

The `&` is the *address* operator. It precedes a value type and returns the address where the value is stored.
```Go
x := "hello"
pointerToX := &x
```

The `*` is the *indirection* operator. It precedes a variable of pointer type and returns the pointed-to value. ==This is called *dereferencing*.==
```Go
x := 10
pointerToX := &x
fmt.Println(pointerToX) // prints a memory address
fmt.Println(*pointerToX) // prints 10
z := 5 + *pointerToX
fmt.Println(z, ", address of z", &z)
```
```Output
0x14000102020
10
15 , address of z 0x14000102028
```
before dereferencing a pointer, you must make sure that the pointer is non-nil. Your program will panic if you attempt to dereference a `nil` pointer.
```Go
var x *int
fmt.Println(x == nil) // prints true
fmt.Println(*x) // panics
```

A *pointer type* is a type that represents a pointer. It is written with a `*` before a type name. A pointer type can be based on any type.
```Go
x := 10
var pointerToX *int
pointerToX = &x

fmt.Println(pointerToX) // 0x1400000e118
```

The built-in function `new` creates a pointer variable. It returns a pointer to a zero-value instance of the provided type.
```Go
var x = new(int)
fmt.Println(x == nil) // prints false
fmt.Println(*x) // prints 0
```
The `new` function is rarely used.
For structs, use an `&` before a struct literal to create a pointer instance. You can't use an `&` before a primitive literal (numbers, booleans, and strings) or a constant because they don't have memory addresses; they exist only at compile time. 
When you need a pointer to a primitive type, declare a variable and point to it.
```Go
x := &Foo{}

var y string
z := &y
```
```Go
package main  
  
import "fmt"  
  
func main() {  
    type Foo struct {  
       age  int  
       name string  
    }  
    x := &Foo{  
       age:  20,  
       name: "hello",  
    }  
    fmt.Println(x)  
  
    var y string  
    z := &y  
    fmt.Println(z)  
}
```
```Output
&{20 hello}
0x14000122010
```
Not being able to take the address of a constant is sometimes inconvenient. If you have a struct with a field of a pointer to a primitive type, you can't assign a literal directly to the field.
```Go
type person struct {
	FirstName string
	MiddleName *string
	LastName string
}

p := person{
	FistName: "Pat",
	MiddleName: "Perry", // This line won't compile
	LastName: "Peterson",
}
```
Compiling this code returns the error:
```Output
cannot use "Perry" (type string) as type *string in field value
```
If you try to put an `&` before "Perry", you'll get the error message:
```Output
cannot take the address of "Perry"
```
There are two ways around this problem. The first is to do what was shown previously, which is to introduce a variable to hold the constant value. 
The second way is to write a generic helper function that takes in a parameter of any type and returns a pointer to that type.
```Go
func makePointer[T any] (t T) *T {
	return &t
}

p := person {
	FirstName: "Pat",
	SencondName: makePointer("Perry"), // this works
	LastName: "Peterson",
}
```
When you pass a constant to a function, the constant is copied to a parameter, which is a variable. Since it's a variable, it has an address in memory. The function then returns the variable's memory address. 

### Don't Fear the Pointers
When a primitive value is assigned to another variable or passed to a function or method, any changes made to the other variable aren't reflected in the original.
```Go
var x int = 10
var y int = x
y = 20

fmt.Println(x) // Prints 10
```
When an instance of a class is assigned to another variable or passed to a function or method this following will happen;
- If you pass an instance of a class to a function and you change the value of a field, the change is reflected in the variable that was passed in.
- If you reassign the parameter, the change is *not* reflected in the variable that was passed in.
- If you pass `nil/null/None` for a parameter value, setting the parameter itself to a new value doesn't modify the variable in the calling function.
What you are seeing is that every instance of a class in these languages is implemented as a pointer. When a class instance is passed to a function or method, the value being copied is the pointer to the instance.

## Pointers Indicate Mutable Parameters
Using mutable objects is just fine if you are using them entirely locally within a method, and with only one reference to the object. Rather than declare that some variable and parameters are immutable, Go developers use pointers to indicate that a parameter is mutable. 
Since Go is called-by-value language, the values passed to functions are copies. For non-pointer types like primitives, structs, and arrays, this means that the called function cannot modify the original. Since the called function has a copy of the original data, the original data's immutability is guaranteed.
However, if a pointer is passed to a function, the function gets a copy of the pointer. This still points to the original data, which means that the original data can be modified by the called function.
This has a couple of related implications.
- The first implication is that when you pass a `nil` pointer to a function, you cannot make the value non-nil. You can reassign the value only if there was a value already assigned to the pointer. You can demonstrate this with the following program:
```Go
package main  
  
import "fmt"  
  
func failedUpdate(g *int) {  
    x := 10  
    g = &x  
    fmt.Println(g, *g) // prints address and value of x = 10  
}  
func main() {  
    var f *int  
    failedUpdate(f)  
    fmt.Println(f) // prints nil  
}
```
```Output
0x1400000e118 10
<nil>
```

- The second implication of copying a pointer is that if you want  the value assigned to a pointer parameter to still be there when you exit the function, you must dereference the pointer and set the value. If you change the pointer, you have changed the copy, not the original. 
- Dereferencing puts the new value in the memory location pointed to by both the original and the copy. 
```Go
package main  
  
import "fmt"  
  
func failedUpdate(px *int) {  
    x2 := 20  
    px = &x2  
}  
  
func update(px *int) {  
    *px = 20  
}  
  
func main() {  
    x := 10  
    failedUpdate(&x)  
    fmt.Println(x) // prints 10  
    update(&x)  
    fmt.Println(x) // prints 20  
}
```

## Reducing the Garbage Collector's Workload
When programmers talk about "garbage" what they mean is "data that has no more pointers pointing to it." Once there are no more pointers pointing to some data, the memory that this data takes up can be reused. If the memory isn't recovered, the program's memory usage would continue to grow until the computer ran out of RAM. The job of the garbage collector is to automatically detect unused memory and recover it so it can be reused.

Many garbage-collection algorithms have been written, and they can be placed into two rough categories,
- Those that are designed for higher throughput (find the most garbage possible in a single scan).
- Lower latency (finish the garbage scan as quickly as possible).

> **Jeffrey Dean**, the genius behind many Google's engineering successes, cowrote a paper in 2013 called *The Tail at Scale*. It argues that systems should be optimised for latency, to keep response times low. 

The garbage collector used by the Go runtime favours low latency.
The second problem deals with the nature of computer hardware. RAM might mean "random access memory", but the fastest way to read from memory is to read it sequentially. A slice of structs in Go has all the data laid out sequentially in memory. This makes it fast to load and fast to process. A slice of pointers to structs has its data scattered across RAM, making it far slower to read and process. 

> The approach of writing software that's aware of the hardware it's running on is called *mechanical sympathy*. 

### Tuning the Garbage Collector
A garbage collector doesn't immediately reclaim memory as soon as it is no longer referenced. Doing so would seriously impact performance. Instead, it lets the garbage pile up for a bit. The heap almost always contains both live data and memory that's no longer needed. The Go runtime provides users a couple of settings to control the heap's size. The first is the `GOGC` environment variable. The garbage collector look at the heap size at the end of a garbage collection cycle and uses the formula `CURRENT_HEAP_SIZE + CURRENT_HEAP_SIZE*GOGC/100` to calculate the heap size that needs to be reached to trigger the next garbage collection cycle. 
By default, `GOGC` is set to 100, which means that the heap size that triggers the next collection is roughly double the heap size at the end of the current collection. Setting `GOGC` to a smaller value will decrease the target heap size, and setting it to a larger value will increase it. 
Setting `GOGC` to off disables garbage collection. This will make your programs run faster. However turning off garbage collection on a long running process will potentially use all available memory on your computer. 
The second garbage-collection setting specifies a limit on the total amount of memory your Go program is allowed to use. By default the `GOMEMLIMIT` is disable. The value for `GOMEMLIMIT` is specified in bytes, but you can optionally use the suffixes B, KiB, MiB, GiB, and TiB. For example, `GOMEMLIMIT=3GiB` sets the memory limit to 3 gibibytes.
