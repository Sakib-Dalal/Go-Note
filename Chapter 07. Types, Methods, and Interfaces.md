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

## Pointer Receivers and Value Receivers
Go uses parameters of pointer type to indicate that a parameter might be modified by the function. The same rule apply for method receivers too. They can be *pointer receivers (the type is a pointer type)* or *value receivers (the type is a value type)*. 
The following rules help you determine when to use each kind of receivers:
- If your method modifies the receiver, you must use a pointer receiver.
- If your method needs to handle `nil` instances then it *must* use a pointer receiver.
- If your method doesn't modify the receiver, you *can* use a value receiver.
