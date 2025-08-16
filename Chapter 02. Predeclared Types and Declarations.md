## The predeclared Types
Go has many types build into the language. These are called *predeclared* types. They are similar to types that are found in other languages: booleans, integers, floats, and strings. Before, let's cover some of the concepts that apply to all types.

### The Zero Value
Go, like most modern languages, assigns a default *zero* value to any variable that is declared but not assigned a value.

### Literals
A Go *literal* is an explicitly specific number, character, or string. Go programs have four common kinds of literals. 

### Numerical Types
Go has a large number of numerical types: 12 types that are grouped into three categories.
- Integer Types: provides both signed and unsigned integers in a variety of sizes.
- Floating Types: provides both float32 and float64 

### Explicit Type Conversion
Most languages that have multiple numeric types automatically convert from one to another when needed. This is called *automatic type promotion*. Go doesn't allow automatic type promotion between variables. You must use a *type conversion* when variable types do not match. Even different sized integers and floats must be converted to the same type to interact.

```Go
var x int = 10
var y float64 = 30.2
var sum1 float64 = float64(x) + y
var sum2 int = x + int(y)

fmt.Println(sum1, sum2)
```

Same behavior applies with different sized integer types.
```Go
var x int = 10
var b byte = 100
var sum3 int = x + int(b)
var sum4 byte = byte(x) + b

fmt.Println(sum3, sum4)
```

### var Versus :=
Go has a lot of ways to declare variables. The most verbose eay to declare a variable in Go uses the *var* keyword, and explicit type, and an assignment. 
```Go
var x int = 10

var x = 10    // auto declare type
```
If you want to declare a variable and assign it the zero value, you can keep the type and drop the = on the righthand side
```Go
var x int
```
You can declare multiple variables at once with var, and they can be the same type.
```Go
var x, y int = 10, 20

var x, y int.   // zero value
```
or different type.
```Go
var x, y = 10, "hello"
```

There are one more way to use var. If you are declaring multiple variables at once, you can wrap them in a *declaration list*.
```Go
var (
	x int
	y = 20
	z int = 30
	d, e = 40, "hello"
	f, g string
)
```

Go also support a short decalration and assignment format. When you are within a function, you can use the := operator to replace a var declaration that uses type inference.
```Go
x := 10

x, y := 10, "hello"
```

