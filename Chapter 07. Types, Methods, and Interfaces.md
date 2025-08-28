## Types in Go
Back in Structs, you saw how to define a struct type:
```Go
type Person struct {
	FirstName string
	LastName string
	Age int	
}
```
This should be read as declaring a user-defined type with the name `Person` to have the *underlying type* of the struct literal that follows. 
In addition to struct literals, you can use any primitive type or compound type literal to define a concrete type. 
```Go
type Score int
type Converter func(string)Score
type TeamScores map[string]Score
```
Go allows you to declare a type at any block level, from the package block down. However, you can access the type only from within its scope.
```Go
package main  
  
import "fmt"  
  
func main() {  
    type a int  
    var myInt a = 1  
    fmt.Println(myInt)  
}
```
```Output
1
```

## Methods 
Like most languages, Go supports methods on user-defined types.
The methods for a type are defined at the package block level.
```Go
type Person struct {
	FirstName string
	LastName string
	Age int
}

func (p Person) String() string {
	return fmt.Sprintf("%s %s, age %d", p.FirstName, p.LastName, p.Age)
}
```
Syntax to write a Method.
```Go
func (receiverName ReceiverType) MethodName(parameters) (returnTypes) {
    // Method body
}
```
Example of method
```Go
package main  
  
import "fmt"  
  
// Rectangle Define a new type Rectangle  
  
type Rectangle struct {  
    width  float64  
    height float64  
}  
  
// Area 'Area' is a method with a receiver of type 'Rectangle'.  
// 'r' is the name of the receiver variable.  
  
func (r Rectangle) Area() float64 {  
    return r.width * r.height  
}  
  
func main() {  
    rect := Rectangle{width: 10, height: 5}  
    fmt.Println("Area", rect.Area())  
}
```
```Output
Area 50
```
Method declarations look like function declarations, with one addition: the *receiver* specification. 
- The receiver appears between the keyword `func` and the name of the method. 
- Like all other variable declarations, the receiver name appears before the type. 
- By convention, the receiver name is a sort abbreviation of the type's name, usually its first letter. 
There is one key difference between declaring methods and functions: 
- Methods can be defined *only* at the package block level, while functions can be defined inside any block.

Method names cannot be overloaded
- You can use the same method names for different types
- But you can't use the same method name for two different methods on the same type.

> Methods must be declared in the same package as their associated type, Go doesn't allow you to add methods to types you don't control.
> While you can define a method in a different file within the same package as the type declaration, it is best to keep your type definition and its associated methods together so that it's easy to follow the implementation.

Method invocations.
```Go
p := Person {
	FirstName: "Fred",
	LastName: "Fredson",
	Age: 52,
}

output := p.String()
```

Full Code:
```Go
package main  
  
import "fmt"  
  
type Person struct {  
    FirstName string  
    LastName  string  
    Age       int  
}  
  
func (p Person) String() string {  
    return fmt.Sprintf("%s %s, age %d", p.FirstName, p.LastName, p.Age)  
}  
  
func main() {  
    p := Person{  
       FirstName: "John",  
       LastName:  "Doe",  
       Age:       42,  
    }  
    output := p.String()  
    fmt.Println(output)  
}
```
```Output
John Doe, age 42
```
```Go
package main  
  
import "fmt"  
  
type Person struct {  
    FirstName string  
    LastName  string  
    Age       int  
}  
  
func (p *Person) String() string {  
    return fmt.Sprintf("%s %s %d", p.FirstName, p.LastName, p.Age)  
}  
  
func main() {  
    p := &Person{}  
    output := p.String()  
    fmt.Println(output)  
}
```
## Pointer Receivers and Value Receivers
Go uses parameters of pointer type to indicate that a parameter might be modified by the function. The same rule apply for method receivers too. They can be *pointer receivers (the type is a pointer type)* or *value receivers (the type is a value type)*. 
The following rules help you determine when to use each kind of receivers:
- If your method modifies the receiver, you must use a pointer receiver.
- If your method needs to handle `nil` instances then it *must* use a pointer receiver.
- If your method doesn't modify the receiver, you *can* use a value receiver.
Whether you use a value receiver for a method that doesn't modify the receiver depends on the other methods declared on the type. When a type has any pointer receiver methods, a common practice is to be consistent and use pointer receiver for *all* methods, even the ones that don't modify the receiver.
Here's some simple code to demonstrate pointer and value receivers. It starts with a type that has two methods on it, one using a value receiver, the other with a pointer receiver.
```Go
type Counter string {
	total int
	lastUpdated time.Time
}

func (c *Counter) Increment() {
	c.total++
	c.lastUpdated = time.Now()
}

func (c Counter) String() string {
	return fmt.Sprintf("total: %d, last updated: %v",  c.total, c.lastUpdated)
}
```
Full code:
```Go
package main  
  
import (  
    "fmt"  
    "time")  
  
type Counter struct {  
    total       int  
    lastUpdated time.Time  
}  
  
func (c *Counter) Increment() {  
    c.total++  
    c.lastUpdated = time.Now()  
}  
  
func (c Counter) String() string {  
    return fmt.Sprintf("total: %d, last updated: %v", c.total, c.lastUpdated)  
}  
  
func main() {  
    counter := Counter{  
       total: 1,  
    }  
    counter.Increment()  
    fmt.Println(counter.String())  
  
    counter.Increment()  
    fmt.Println(counter.String())  
}
```
```Output
total: 2, last updated: 2025-08-28 12:36:07.013601 +0530 IST m=+0.000173376
total: 3, last updated: 2025-08-28 12:36:07.014042 +0530 IST m=+0.000614376
```
When you use a pointer receiver with a local variable that's a value type, Go automatically takes the address of the local variable when calling the method. In this case, `counter.Increment()` is converted to `(&c).Increment()`.
If you call a value receiver on a pointer variable, Go automatically dereferences the pointer when calling the method. In this code;
```Go
counter := &Counter{}
fmt.Println(counter.String())
counter.Increment()
fmt.Println(counter.String())
```
the call `counter.String()` is silently converted to `(*counter).String()`.

> Be aware that the rules for passing values to functions still apply. If you pass a value type to a function and call a pointer receiver method on the passed value, you are invoking the method on a *copy*.

```Go
func doUpdateWrong(c Counter) {
	c.Increment()
	fmt.Println("in doUpdateWrong:", c.String())
}

func doUpdateRight(c *Counter) {
	c.Increment()
	fmt.Println("in doUpdateRight:", c.String())
}

func main() {
	var c Counter
	doUpdateWrong(c)
	fmt.Println("in main:", c.String())
	doUpdateRight(&c)
	fmt.Println("in main:", c.String())
}
```
```Output
in doUpdateWrong: total: 1, last updated: 2025-08-28 12:57:57.013832 +0530 IST m=+0.000110793
in main: total: 0, last updated: 0001-01-01 00:00:00 +0000 UTC
in doUpdateRight: total: 1, last updated: 2025-08-28 12:57:57.014131 +0530 IST m=+0.000409543
in main: total: 1, last updated: 2025-08-28 12:57:57.014131 +0530 IST m=+0.000409543
```

## Code Your Methods for nil Instances
 The previous section covered pointer receivers, which might make you wonder what happens when you call a method on a `nil` instance. 
 Go does something a little different. It actually tries to invoke the method. As mentioned earlier, 
 - if it's a *method with value receiver*, you'll get a panic, since there is no value being pointed to by the pointer. 
 - If it's a *method with a pointer receiver*, it can work if the method is written to handle the possibilities of a `nil` instance.
In some cases, expecting a `nil` receiver makes the code simpler. 
Here's an implementation of binary tree that takes advantage of `nil` values for the receiver.
```Go
package main  
  
import "fmt"  
  
type IntTree struct {  
    value int  
    left  *IntTree  
    right *IntTree  
}  
  
// Corrected Insert methodfunc (it *IntTree) Insert(value int) *IntTree {  
    if it == nil {  
       // Base case: We've found an empty spot. Create a new node.  
       return &IntTree{value: value}  
    }  
  
    // Recursive step: Traverse down the tree  
    if value < it.value {  
       // Make the recursive call on the LEFT CHILD  
       it.left = it.left.Insert(value)  
    } else if value > it.value {  
       // Make the recursive call on the RIGHT CHILD  
       it.right = it.right.Insert(value)  
    }  
    // If value == it.value, do nothing (no duplicates)  
    return it  
}  
  
func main() {  
    var intTree *IntTree  
    intTree = intTree.Insert(5)  
    intTree = intTree.Insert(7)  
    intTree = intTree.Insert(9)  
    intTree = intTree.Insert(3)  
    intTree = intTree.Insert(4)  
  
    // You'll need a way to print the tree to verify it works.  
    // This simple in-order traversal function will print the values in sorted order.    var traverse func(t *IntTree)  
    traverse = func(t *IntTree) {  
       if t == nil {  
          return  
       }  
       traverse(t.left)  
       fmt.Printf("%d ", t.value)  
       traverse(t.right)  
    }  
  
    fmt.Println("Tree values (in-order):")  
    traverse(intTree)  
    fmt.Println()  
}
```
```Output
Tree values (in-order):
3 4 5 7 9 
```
