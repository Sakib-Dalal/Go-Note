## Blocks
In Go, a **block** is a sequence of statements enclosed in curly braces `{}`. The primary purpose of a block is to group statements together and to create a **lexical scope**.
### Key Characteristics of Blocks

- **Lexical Scope**: A block introduces a new, nested scope. Any identifier (like a variable or constant) declared inside a block is only visible and accessible within that block and any blocks nested inside it. It is not visible to the outer, containing block.
    
- **Shadowing**: You can declare a variable inside an inner block with the same name as a variable in an outer block. This is called **shadowing**. The inner variable "hides" the outer one for the duration of the inner block's scope.
    

### Where Blocks Are Used

Blocks are a fundamental part of Go's syntax and are used in many places:

1. **Function Bodies**: The entire body of a function is a block.
    
    Go
    
    ```Go
    func greet() { // Start of function block
        message := "Hello, World!"
        fmt.Println(message)
    } // End of function block
    ```
    
2. **Control Flow Statements**: `if`, `for`, and `switch` statements all use blocks to define the code that gets executed conditionally or repeatedly.
    
    - **`if-else` Statements**: Each `if`, `else if`, and `else` has its own block.
        
        Go
        
        ```Go
        if x > 10 { // Start of if block
            y := 5
            fmt.Println(x + y)
        } else { // Start of else block
            z := 2
            fmt.Println(x + z)
        } // y and z are not accessible here
        ```
        
    - **`for` Loops**: The body of a `for` loop is a block. The loop's initialization statement also creates variables scoped to the loop.
        
        Go
        
        ```Go
        for i := 0; i < 3; i++ { // Start of for block. 'i' is scoped to the loop.
            fmt.Println(i)
        } // 'i' is not accessible here
        ```
        
    - **`switch` Statements**: Each `case` in a `switch` statement acts as an implicit block.
        
        Go
        
        ```Go
        switch day {
        case "Monday": // Start of implicit case block
            message := "Start of the week!"
            fmt.Println(message)
        case "Friday": // Start of implicit case block
            message := "End of the week!"
            fmt.Println(message)
        }
        ```
        
3. **Explicit Blocks**: You can also create an explicit block simply by using curly braces. This is less common but can be useful for controlling variable scope.
    
    Go
    
    ```GO
    package main
    
    import "fmt"
    
    func main() {
        x := 10
        fmt.Println("Outside:", x) // Prints 10
    
        { // Start of an explicit inner block
            x := 20 // This 'x' shadows the outer 'x'
            y := 30
            fmt.Println("Inside:", x, y) // Prints 20 30
        } // End of inner block. Inner 'x' and 'y' are destroyed.
    
        fmt.Println("Outside again:", x) // Prints 10, the original 'x'
        // fmt.Println(y) // This would cause a compile error: "undefined: y"
    }
    ```

***
## Shadowing Variables
A *shadowing variable* is a variable that has the same name as a variable in a containing block. For as long as the shadowing variable exist, you cannot access a shadowed variable.
```Go
func main() {
	x := 10
	if x > 5 {
		fmt.Println(x)
		x := 5
		fmt.Println(x)
	}
	fmt.Println(x)
}
```
```Output
10
5
10
```
Let's see another example..
```Go
func main() {
	x := 5
	if x > 5 {
		x, y := 5, 20
		fmt.Println(x, y)
	}
	fmt.Println(x)
}
```
```Output
5 20
10
```

***

## if
```Go
n := rand.Intn(10)

if n == 0 {
	fmt.Println("That's too low")
} else if n > 5 {
	fmt.Println("That's too big", n)
} else {
	fmt.Println("That's a good number", n)
}
```
The most visible difference between `if` statements in Go and other languages is that you don't put parentheses around the condition. But Go adds another feature to `if` statements that helps you better manage your variables.
In Go we can scope a variable to an `if` statement.
```Go
if n := rand.Intn(10); n == 0 {
	fmt.Println("That's too low")
} else if n > 5 {
	fmt.Println("That's too big", n)
} else {
	fmt.Println("That's a good number", n)
}
```
Having this special scope is handy. It lets you create variables that are available only where they are needed. Once the series of `if/else` statements ends, `n` is undefined.

***
## for, Four Ways
Go uses a for statement to loop. What makes Go different from other languages is that `for` is the *only* looping keyword in the language. Go accomplishes this by using the for keyword in four formats:
- A complete C-style `for`
- A condition only `for`
- An infinite `for`
- for-range

### The Complete for Statement 
The first `for` loop style is the complete `for` declaration.
```Go
for i := 0; i < 10; i++ {
	fmt.Println(i)
}
```
This program prints out the numbers from 0 to 9, inclusive.
Just like the `if` statement, the `for` statement does not use parentheses around its parts.
The for statement has three parts, separated by semicolons. 
- First part is initialisation. you must use `:=` to initialise the variable, `var` is not legal here. 
- Second part is comparison.
- Last part of a standard `for` statement is the increment.
Go allows you to leave out one or more of the three parts of the `for` statement. Most commonly, you'll either leave off the initialisation if it is based on a value calculated before the loop.
```Go
i := 0
for ; i < 10; i++ {
	fmt.Println(i)
}
```
or you leave of the increment because you have a more complicated increment rule inside the loop.
```Go
for i := 0; i < 10; {
	fmt.Println(i)
	if i % 2 == 0 {
		i++
	} else {
		i+=2
	}
}
```

### The Condition-Only for Statement 
When you leave off both the initialisation and the the increment in a for statement, do not include the semicolons. ==That leaves a `for` statement that functions like the `while` statement from C.== 
```Go
for i < 100 {
	fmt.Println(i)
	i = i * 2
}
```

### The Infinite for Statement
The third `for` statement format does away with the condition too. Go has a version of a `for` loop that loop forever. 
```Go
package main
import "fmt"

func main() {
	for {
		fmt.Println("Hello")
	}
}
```

## break and continue
How do you get out of an infinite `for` loop without using the keyboard or turning off your computer? That's the job of `break` statement. It exits the loop immediately. 
Go also include the `continue` keyword, which skips over the rest of the `for` loop's body and proceeds directly to the next iteration.

### The for-range Statement
The fourth `for` statement format is for iterating over elements in some of Go's built in types. It is called a `for-range` loop and resembles the iterators found in other languages.
This section shows how to use a `for-range` loop with strings, arrays, slices, and maps. 
First let's take a look at using `for-range` loop with a slice.
```Go
evenVals := []int{2, 4, 6, 8, 10, 12}

for i, v := range evenVals {
	fmt.Println(i, v)
}
```
```Output
0 2
1 4
2 6
3 8
4 10
5 12
```
The idiomatic names for the two loop variables depends on what is being looped over. When looping over an array, slice, or string, an `i` for *index* is commonly used. When iterating through a map, `k` for *key* is used instead.

`for-range` for maps.
```Go
uniqueNames := map[string]bool{  
    "John":  true,  
    "Smith": true,  
    "Fred":  false,  
}  
  
for k, v := range uniqueNames {  
    fmt.Println(k, v)  
}
```
```Output
John true
Smith true
Fred false
```
What if you want the `key` but don't want the value? In this situation, Go allows you to just leave off the second variable. 
```Go
uniqueNames := map[string]bool{  
    "John":  true,  
    "Smith": true,  
    "Fred":  false,  
}  
  
for k := range uniqueNames {  
    fmt.Println(k)  
}
```

#### Iterating over strings
You can also use a string with a `for-range` loop.
```Go
samples := []string{"hello", "apple_n!"}

for _, sample := range samples {
	for i, r := range sample {
		fmt.Println(i, r, string(r))
	}
	fmt.Println()
}
```
```Output
0 104 h
1 101 e
2 108 l
3 108 l
4 111 o

0 97 a
1 112 p
2 112 p
3 108 l
4 101 e
5 95 _
6 110 n
7 33 !
```
#### The for-range value is a copy
You should be aware that each time the `for-range` loop iterates over your compound type, it *copies* the value from the compound type to the value variable.
*Modifying the value variable will not modify the value in the compound type.*
```Go
evenVals := []int{2, 4, 6, 8, 10, 12}
for _, v := range evenVals {
	v *= 2
}
fmt.Println(evenVals)
```
```Output
[2, 4, 6, 8, 10, 12]
```
### Choosing the Right for Statement
Most of the time, you're going to use the `for-range` format. A `for-range` loop is the best way to walk through a string, since it properly gives you back runes instead of bytes. 

## switch
Like many C-derived languages, Go has a `switch` statement. Let's take a look.
```Go
words := []string{"a", "cow", "smile", "gopher", "octopus", "anthropologist"}  
  
for _, word := range words {  
    switch size := len(word); size {  
    case 1, 2, 3, 4:  
       fmt.Println(word, "is a short word!")  
  
    case 5:  
       wordLen := len(word)  
       fmt.Println(word, "is exactly the right length:", wordLen)  
    case 6, 7, 8, 9:  
    default:  
       fmt.Println(word, "is a long word!")  
    }  
}
```
```Ouptut
a is a short word!
cow is a short word!
smile is exactly the right length: 5
anthropologist is a long word!
```

