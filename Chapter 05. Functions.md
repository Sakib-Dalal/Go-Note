## Declaring and Calling Functions
Every Go program starts from a `main` function, and you've been called the `fmt.Println` function to print to the screen. Since a `main` function doesn't take in parameters or return values, let's see what it looks like when a function does.
```Go
func div(num int, denom int) int {
	if denom == 0 {
		return 0
	}
	return num / denom
}
```
A function declared has four parts:
- The keyword `func`
- The name of the function 
- The input parameters 
- The return type

The input parameter are listed in parenthesis, separated by commas, with the parameter name first and the type second. Go is a typed language, so you must specify the type of the parameters. The return type is written between the input parameters closing parenthesis and the opening brace for the function body.
Go has `return` keyword for returning values from a function. 
- If a function returns a value, you *must* supply a `return`.
- If a function returns nothing, a `return` statement is not needed at the end of the function.
- The `return` keyword is needed in a function that returns nothing only if you are exiting from the function before the last line.

The `main` function has no input parameters or return values. When a function has no input parameters, use empty parenthesis (). 
```Go
func main() {
	result := div(5, 2)
	fmt.Println(result)
}
```

When you have two or more consecutive input parameters of the same type, you can specify the type once for all of them like this.
```Go
func div(num, denom int) int {}
```

## Simulating Named and Optional Parameters 
Go *doesn't* have named and optional input parameters.  If you want to emulate named and optional parameters, define a struct that has fields that match the desired parameters, and pass the struct to your function. 
```Go
type MyFuncOpts struct {
	FirstName string
	LastName string
	Age int
}

func MyFunc(opts MyFuncOpts) error {
	// do something here
	fmt.Println(opts.FirstName, opts.LastName, opts.Age)
}

func main() {
	MyFunc(MyFuncOpts{
		LastName : "Patel",
		Age: 50,
	})
	MyFunc(MyFuncOpts{
		FirstName: "Joe",
		LastName: "Smith",	
	})
}
```
## Variadic Input Parameters and Slices
You've been using `fmt.Println` to print results to the screen and you've probably noticed that it allows any number of input parameters. Like many languages Go supports *variadic parameters*. The variadic parameter must be the last parameter in the input parameter list. You indicate it with three dots (...) *before* the type. The variable that's created within the function is a slice of the specific type.
```Go
func addTo(base int, vals ...int) []int {
	out := make([]int, 0, len(vals))
	for _, v := range vals {
		out = append(out, base+v)	
	}
	return out
}

func main() {
	fmt.Println(addTo(3))
	fmt.Println(addTo(3, 2))
	fmt.Println(addTo(3, 2, 4, 6, 8))
	a := []int{4, 3}
	fmt.Println(addTo(3, a...))
	fmt.Println(addTo(3, []int{1, 2, 3, 4, 5}...))
}
```
```Output
[]
[5]
[5 7 9 11]
[7 6]
[4 5 6 7 8]
```
## Multiple Return Values
Go allow for multiple return values. updated code for returning multiple return values.
```Go
func divAndRemainder(num int, denom int) (int, int, error) {
	if denom == 0 {
		return 0, 0, errors.New("cannot divide by zero")
	}
	return num / demon, num % denom, nil 
}
```
Go multiple return values support to return an `error` if something goes wrong in a function. If the function completes successfully, it will return `nil` value.
Calling the updated function.
```Go
func main() {
	result, remainder, err := divAndRemainder(5, 2)
	if err != nil {
		fmt.Println(err)
		os.Exit(1)
	}
	fmt.Println(result, remainder)
}
```
## Ignoring Returned Values
What if you call a function and don't want to use all the returned values! Go does not allow unusual variables. If a function returns multiple values, but you don't need to read one or more of the values, assign the unused values to the name `_`. 

## Named Return Values
In addition to letting you return more than one value from a function, Go allows you to specify *names* for your return values. Rewrite the `divAndRemainder` function one more time, this time using named return values.
```Go
func divAndRemainder(num int, denom int) (result int, remainder int, err error) {
	if denom == 0 {
		err = errors.New("cannot divide by zero")
		return result, remainder, err
	}
	result, remainder = num/denom, num%denom
	return result, remainder, err
}
```
When you supply names to your return values, what you are doing is predeclaring variables that you use within the function to hold the return values.

## Functions Are Values
Just as in many other languages, functions in Go are values. The type of a function is built out of the keyword `func` and the types of the parameters and return values. This combinations is called *signature* of the function. Since functions are values, you can declare a declare variable.
```Go
var myFuncVariable func(string) int
```
`myFuncVariable` can be assigned any function that has a single parameter of type `string` and returns a single value of type `int`. Long example:
```Go
func f1(a string) int {
	return len(a)
}

func f2(a string) int {
	total := 0
	for _, v := range a {
		total += int(v)
	}
	return total
}

func main() {
	var myFuncVariable func(string) int
	myFuncVariable = f1
	result := myFuncVariable("Hello")
	fmt.Println(result)
}
```
## Function Type Declaration 
You can use `type` keyword to define a function. (*similar to struct keyword*)
```Go
type opFuncType func(int, int) int {
	
}
```
Rewrite the `opMap` declaration to look like this.
```Go
var opMap = map[string]opFuncType {
	
}
```
## Anonymous Function
We can not only assign functions to variables, but also define new functions within a function and assign them to variables.
```Go
func main() {
	f := func(j int) {
		fmt.Println("printing", j, "from inside of an anonymous function")
	}
	for i := 0; i < 5; i++ {
		f(i)	
	}
}
```
You don't have to assign an anonymous function to a variable, you can write them inline and call the immediately.
```Go
func main() {
	for i := 0; i < 5; i++ {
		func(j int) {
			fmt.Println("printing", j, "from inside of an anonymous function")
		}(i)
	}
}
```
You can also declare package scope variables that are assigned anonymous function.
```Go
var (
	add = func(i int, j int) int { return i + j }
	sub = func(i int, j int) int { return i - j }
	mul = func(i int, j int) int { return i*j }
	div = func(i int, j int) int { return i/j }
)

func main() {
	x := add(2, 3)
	fmt.Println(x)
}
```
Unlike a normal function definition, you can assign a new value to a package level anonymous function.
```Go
func main() {
	x := add(2, 3)
	fmt.Println(x)
	changeAdd()
	y := add(2, 3)
	fmt.Println(y)
}

func changeAdd() {
	add = func(i int, j int) int { return i + j + j }
}
```
```Output
5
8
```
## Closures
==Functions declared inside functions== are special, they are called *closures*. That means functions declared inside functions are able to access and modify variables declared in the outer function. Let's look an example,
```Go
func main() {
	a := 20
	f := func() {
		fmt.Println(a)
		a = 30
	}
	f()
	fmt.Println(a)
}
```
```Output
20
30
```
Just as with any inner scope, you can shadow a variable inside a closure. If you change the code to,
```Go
func main() {
	a := 20
	f := func() {
		fmt.Println(a)
		a := 30
		fmt.Println(a)
	}
	f()
	fmt.Println(a)
}
```
```Output
20
30
20
```
## Passing Functions as Parameters
Since functions are values and you can specify the type of a function using its parameter and return types, you can pass functions as parameters into functions. 
One example is sorting slices. The `sort` package in the standard library has a function called `sort.Slice`. It takes in any slice and a function that is used to sort the slice that's passed in. Let's see how it works by sorting a slice of a struct using two different fields.
Let's see how to use closures to sort the same data different ways. 
```Go
type Person struct {
	FirstName string
	LastName string
	Age int
}

people := []Person {
	{"Pat", "Patterson", 20},
	{"Tracy", "Bobdaughter", 23},
	{"Ajay", "Kumar", 12}
}
fmt.Println(people)
```
```Output
[{Pat Patterson 20} {Tracy Bobdaughter 23} {Ajay Kumar 12}]
```
Next sort the slices by last name and print out the result.
```Go
sort.Slice(people, func(i int, j int) bool { return people[i].LastName < people[j].LastName})
fmt.Println(people)
```
```Output
[{Tracy Bobdaughter 23} {Ajay Kumar 12} {Pat Patterson 20}]
```
Next, you do the same, sorting by the `Age` field.
```Go
sort.Slice(people, func(i int, j int) bool { return people[i].Age < people[j].Age })
fmt.Println(people)
```
```Output
[{Ajay Kumar 12} {Pat Patterson 20} {Tracy Bobdaughter 23}]
```
## Returning Functions from Functions
In addition to using a closure to pass some function state to another function, you can also return a closure from a function.
