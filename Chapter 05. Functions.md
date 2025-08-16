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
Let's demonstrate this by writing a function that returns a multiplier function. 
```Go
func makeMult(base int) func(int) int {
	return func(factor int) int {
		return base * factor 
	}
}
```
And here is how the function is used
```Go
func main() {
	twoBase := makeMult(2)
	threeBase := makeMult(3)
	for i := 0; i < 3; i++ {
		fmt.Println(twoBase(i), threeBase(i))
	}
}
```
```Output 
0 0
2 3
4 6
```
A closure is also used to efficiently search a sorted slice with `sort.Search`. As for returning closures, you will see this pattern used when you build middleware for a web server in ==Middleware==. Go also uses closures to implement resource cleanup, via the `defer` keyword.
## ==defer==
Programs often create temporary resources, like files or network connections, that need to be cleaned up. This cleanup has to happen, no matter how many exit points a function has, or whether a function completed successfully or not. In Go, the cleanup code is attached to the function with the `defer` keyword.
Let's take a look at how to use `defer` to release resources. 
- You'll do this by writing a simple version of `cat`, the Unix utility for printing the contents of file.
```Go
func main() {
	if len(os.Args) < 2 {
		log.Fatal("no file specified")
	}
	f, err := os.Open(os.Args[1])
	if err != nil {
		log.Fatal(err)
	}
	defer f.Close()
	data := make([]byte, 2048)
	for {
		count, err := f.Read(data)
		os.Stdout.Write(data[:count])
		if err != nil {
			if err != io.EOF {
				log.Fatal(err)
			}
			break
		}
	}
}
```
```Bash
go run hello.go test.txt
```
```Output
Hello World
How are you?
```
First, you make sure that a filename was specified on the command line by checking the length of os.Args, a slice in the os package. The first value in os.Args is the name of the program. The remaining values are the arguments passed to the program. You check that the length of os.Args is at least 2 to determine whether the argument to the program was provided. If it wasn’t, use the Fatal function in the log package to print a message and exit the program. Next, you acquire a read-only file handle with the Open function in the os package. The second value that’s returned by Open is an error. If there’s a problem opening the file, you print the error message and exit the program. As mentioned earlier, I’ll talk about errors in Chapter 9. 

Once you know there is a valid file handle, you need to close it after you use it, no matter how you exit the function. To ensure that the cleanup code runs, you use the defer keyword, followed by a function or method call. In this case, you use the Close method on the file variable. (I cover at methods in Go in Chapter 7.) Normally, a function call runs immediately, but defer delays the invocation until the surrounding function exits. 

You read from a file handle by passing a slice of bytes into the Read method on a file variable. I’ll cover how to use this method in detail in “io and Friends”, but Read returns the number of bytes that were read into the slice and an error. If an error occurs, you check whether it’s an end-of-file marker. If you are at the end of the file, you use break to exit the for loop. For all other errors, you report it and exit immediately, using log.Fatal. I’ll talk a little more about slices and function parameters in “Go Is Call by Value” and go into details on this pattern when I discuss pointers in the next chapter.

You can `defer` multiple functions in a Go function. They run in last-in, first-out (LIFO) order, the last `defer` registered runs first.
The code within `defer` functions runs *after* the return statement. As mentioned, you can supply a function within input parameters to a `defer`. The input parameters are evaluated immediately and their values are stored until the function runs. 
Here is the quick example:
```Go 
func deferExample() int {
	a := 10
	defer func(val int) {
		fmt.Println("first:", val)
	}(a)
	a = 20
	defer func(val int) {
		fmt.Println("second:", val)
	}(a)
	a = 30
	fmt.Println("exiting:", a)
	return a
}
```
```Output
exiting: 30
second: 20
first: 10
```
## Go Is Call by Value
You might hear people say that Go is a ***call-by-value*** language and wonder what that means. It means that you supply a variable for a parameter to a function, Go *always* makes a copy of the value of the variable. 
```Go
type person struct {
	age int
	name string
}
```
Next you write a function that takes in an `int`, a `string` and a `person`, and modifies their values.
```Go
func modifyFails(i int, s string, p person) {
	i = i * 2
	s = "Goodbye"
	p.name = "Bob"
}
```
You then call this function from `main` and see whether the modifications sticks.
```Go
func main() {
	p := person{}
	i := 2
	s := "Hello"
	modifyFails(i, s, p)
	fmt.Println(i, s, p)
}
```
```Output
2 Hello {0 }
```
Running this code shows that a function won't change the values of the parameters passed into it.

> If you have programming experience in Java, JavaScript, Python, or Ruby, you might find the `struct` behavior strange. After all, those languages let you modify the fields in an object when you pass an object as a parameter to a function.

The behaviour is a little different for maps and slices. Let's see what happens when you try to modify them within a function. 
```Go
func modMap(m map[int]string) {
	m[2] = "hello"
	m[3] = "goodbye"
	delete(m, 1)
}

func modSlice(s []int) {
	for k, v := range s {
		s[k] = v * 2
	}
	s = append(s, 10)
}
```
You then call these functions from main.
```Go 
func main() {
	// for map 
	m := map[int]string {
		1: "first",
		2: "second",
	}
	modMap(m)
	fmt.Println(m)
	
	// for slice
	s := []int{1, 2, 3}
	modSlice(s)
	fmt.Println(s)
}
```
```Output
map[2:hello 3:goodbye]
[2 4 6]
```
- Any changes made to a map parameter are reflected in the variable passed into the function. 
- You can modify any element in the slice, but you can't lengthen the slice. 
- This is true for maps and slices that are passed directly into functions as well as map and slice fields in structs.
