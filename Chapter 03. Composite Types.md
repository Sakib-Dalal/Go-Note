## Arrays - Too Rigid to Use Directly
Like most programming languages, Go has arrays. However, arrays are rarely used directly in Go. 
All elements in array must be of the same type that's specified. There are few declaration styles. In the first, you specify the size of the array and the type of the elements in the array.
```Go
var x [3]int
```
This creates an array of three ints. Since no values were specified, all of the elements (x[0], x[1], x[2]) are initialized to the zero value for an int, which is 0.
If you have initial values for the array, you specify them with an array literal.
```Go
var x = [3]int{10, 20, 30}
```
If you have a *sparse array* (an array where most elements are set to their zero value), you can specify only the indices with nonzero values in the array literal.
```Go
var x = [12]int{1, 5: 4, 6, 10: 100, 15}
```
This creates an array of 12 ints with the following values: [1 0 0 0 0 4 0 0 0 0 100 15].

When using an array literal to initialise an array, you can replace the number that specifies the number of elements in the array with ...
```Go
var x = [...]int{10, 20, 30}
```

You can compare two arrays using `==` and `!=`. Arrays are equal if they are the same length and contain equal values.
```Go
var x = [...]int{1, 2, 3}
var y = [3]int{1, 2, 3}

fmt.Println(x == y) // prints true
```

Go has only one-dimensional arrays, but you can simulate multidimensional arrays:
```Go
var x [2][3]int
```
This declares x to be an array if length 2 whose type is an array of ints of length 3.

Arrays in Go are read and written using bracket syntax.
```Go
x[0] = 10
fmt.Println(x[2])
```

Finally, The built in function *len* takes in an array and returns its length.
```Go
fmt.Println(len(x))
```

**Array Limitation:** Go considers the size of the array to be part of the type of the array. This makes an array that's declared to be [3]int a different type from an array that's declared to be [4]int. This also means that you can't use a variable to specify the size of an array, because types must be resolved at compile time, not at runtime.
*You can't use a type conversion to directly convert arrays of different sizes to identical types*.
Because you can't convert arrays of different sizes into each other, you can't write a function that works with arrays of any size and you can't assign arrays of different sizes to the same variable.
The main reason arrays exist in Go is to provide the backing store for *slices*, which are one of the most useful features of Go.
***
## Slices
Most of the time, when you want a data structure that holds a sequence of values, a slice is what you should use. What makes slices so useful is that you can grow slices as needed. This is because the length of a slice is *not* part of its type.
The first thing to notice is that you don't specify the size of the slice when you declare it.
```Go
var x = []int{10, 20, 30}
```
This create a slice of three ints using a *slice literal*.
Just as with arrays, you can also specify only the indices with nonzero values in the slice literal.
```Go
var x = []int{1, 5: 4, 6, 10: 100, 15}
```
You can simulate multidimensional slices and make a slice of slices.
```Go
var x [][]int
```
You read and write slices using bracket syntax, and just as with array, you can't read or wright past the end or use a negative indnex.
```Go
x[0] = 10
fmt.Println(x[2])
```
An empty slice assigns the value as `nil`. In Go, `nil` is an identifier that represents the lack of a value for some types. A `nil` slice contains nothing.
A slice is the first type you've seen that isn't *comparable*. It is a compile-time error to use == to see if two slices are identical or != to see if they are different. The only thing you can compare a slice with == is nil.
```Go
fmt.Println(x == nil) // prints true
```
The `slices.Equal` function takes in two slices and returns true if the slices are the same length, and all of the elements are equal.
The other function is `slices.EqualFunc`, lets you pass in a function to determine equality and does not require the slice element to be comparable.
```Go
x := []int{1, 2, 3, 4}
y := []int{1, 2, 3, 4}
z := []int{1, 2, 3, 4, 5}
s := []string{"a", "b", "c"}

fmt.Println(slices.Equal(x, y)) // prints true
fmt.Println(slices.Equal(x, z)) // prints false
fmt.Println(slices.Equal(x, s)) // does not compile
```
### len
`len` function provides the length of a slice.
```Go
var x = []int{1, 2, 3}
fmt.Println(len(x))
```
### append
The built-in append function is used to grow slices.
```Go
var x []int
x = append(x, 10) //assign result to the variable that's passed in
```
The append function takes at least two parameters, a slice of any type and a value of that type.
```Go
var x = []int{1, 2, 3}
x = append(x, 4)
```
You can append more than one value at a time.
```Go
x = append(x, 5, 6, 7)
```

One slice is appended onto another by using the `...` operator to expand the source slice into individual values.
```Go
y := []int{20, 30, 40}
x = append(x, y...)
```
Passing a slice to the append function actually passes a copy of the slice to the function. The function adds the values to the copy of the slice and returns the copy. You then assign the returned slice back to the variable in the calling function.

### cap
The built in `cap` function returns the current capacity of a slice. Most of the time, cap is used to check if a slice is large enough to hold new data, or if a call to make is needed to create a new slice.
```Go
var x []int
fmt.Println(x, len(x), cap(x))
```
```Go
x = append(x, 10)
fmt.Println(x, len(x), cap(x))

x = append(x, 20)
fmt.Println(x, len(x), cap(x))

x = append(x, 30)
fmt.Println(x, len(x), cap(x))

x = append(x, 40)
fmt.Println(x, len(x), cap(x))

x = append(x, 50)
fmt.Println(x, len(x), cap(x))
```
```bash
# Output
[] 0 0
[10] 1 1
[10 20] 2 2
[10 20 30] 3 4
[10 20 30 40] 4 4
[10 20 30 40 50] 5 8
```

### make
`make` function allow you to create an empty slice that already has a length or capacity specified. It allow you to specify the *type*, *length* and *optinally the capacity*.
```Go
x := make([]int, 5)
```
This creates an int slice with a legth of 5 and capacity of 5 (x[0] to x[4]).
One common mistake if to try populate those initial elements using append.
```Go
x := make([]int, 5)
x = append(x, 10)
```
The 10 is placed at the end of the slice, *after* the zero values in elements 0-4.

You can also specify an initial capacity with make.
```Go
x := make([]int, 5, 10)
```
This creates an int slice with a length of 5 and a capacity of 10.
You can also create a slice with zero length but a capacity that's greater than zero.
```Go
x := make([]int, 0, 10)
```
Since the length is 0, you can't directly index into it, but you can append values to it.
```Go
x := make([]int, 0, 10)
x = append(x, 5, 6, 7, 8)
```
The value of x is now [5, 6, 7, 8], with a length of 4 and capacity of 10.

### Emptying a Slice
`clear` function that takes a slice and sets all of the slice's elements to their zero value. The length of the slice remains unchanges.
```Go
s := []string{"first", "second", "third"}
fmt.Println(s, len(s))
clear(s)
fmt.Println(s, len(s))
```
### Slicing Slices
A *slice expression* creates a slice from a slice. It's written inside brackets and consist of a starting offset and an ending offset, seperated by a colon (:).
```Go
x := []string{"a", "b", "c", "d", "e"}
y := x[:2]
z := x[1:]
d := x[1:3]
e := x[:]

fmt.Println(x)
fmt.Println(y)
fmt.Println(z)
fmt.Println(d)
fmt.Println(e)
```
When you take a slice from a slice, you are not making a copy of the data. Instead, you now have two variables that are sharing memory. This means changes to an element in a slice affect all slices that share that element. 
```Go
x := []string{"a", "b", "c", "d", "e"}
y := x[:2]
z := x[1:]

x[1] = "y"
y[0] = "x"
z[1] = "z"

fmt.Println(x)
fmt.Println(y)
fmt.Println(z)
```

### copy
If you need to create a slice that's independent of the original, use the built-in `copy` function.
```Go
x := []int{1, 2, 3, 4}
y := make([]int, 4)

num := copy(y, x)
fmt.Println(y, num)
```
```Bash
# Output
[1 2 3 4] 4
```
The `copy` function takes two parameters. The first is the *destination* slice, and the second is the *source* slice.
You can copy a subset of a slice. The following code copies the first two elements of a four-element slice into a two-element slice.
```Go
x := []int{1, 2, 3, 4}
y := make([]int, 2)
num := copy(y, x)

fmt.Println(y, num)
```
```Bash
# Output
[1 2] 2
```
The `copy` function allows you to copy between two slices that cover overlapping sections of an underlying slice.
```Go
x := []int{1, 2, 3, 4}
num := copy(x[:3], x[1:])
fmt.Println(x, num)
```
```Bash
# Output
[2 3 4 4] 3
```
You can use `copy` with arrays by taking a slice of the array. you can make the array either the source of the destination of the copy. 
```Go
x := []int{1, 2, 3, 4}
d := [4]int{5, 6, 7, 8}

y := make([]int, 2)

copy(y, d[:])
fmt.Println(y)

copy(d[:], x)
fmt.Println(d)
```
```Output
[5 6]
[1 2 3 4]
```

### Converting Arrays to Slices 
To convert an entire array into a slice, use the [:] syntax.
```Go
xArray := [4]int{5, 6, 7, 8}
xSlice := xArray[:]
```
You can also convert a subset of an array into a slice.
```Go
x := [4]int{5, 6, 7, 8}
y := x[:2]
z := x[2:]
```
Be aware that taking a slice from an array has the same memory-sharing properties as taking a slice from a slice.

### Convert Slices to Arrays
You can convert an entire slice to an array of the same type, or you can create an array from a subset of the slice.
When you convert a slice to an array, the data in the slice is copied to new memory. That means that the changes to the slice won't affect the array.
```Go
xSlice := []int{1, 2, 3, 4}
xArray := [4]int(xSlice)

smallArray := [2]int(xSlice)

fmt.Println(xSlice)
fmt.Println(xArray)
fmt.Println(smallArray)
```
```Output
[1 2 3 4]
[1 2 3 4]
[1 2]
```
While the size of the array can be smaller than the size of the slice, it cannot be bigger.

## Strings and Runes and Bytes
Go uses a sequence of bytes to represent a string.
You can extract a single value from a string by using an *index expression*.
```Go
var s string = "Hello there"
var b byte = s[6]

fmt.Println(b)
```
```Output
116
```
It return an UTF-8 value of a lowercase t.
The slice expression notation taht you used array and slices also works with strings.
```Go
var s string = "Hello there"
var s2 string = s[4:7]
var s3 string = s[:5]
var s4 string = s[6:]
```
A single rune or byte can be converted to a string.
```Go
var a rune = 'x'
var s string = string(a)
fmt.Println(s)

var b byte = 'y'
var s2 string = string(b)
fmt.Println(s2)
```
A string can be converted back and forth to a slice of bytes or a slice of runes.
```Go
var s string = "Hello 👋"
var bs []byte = []byte(s)
var rs []rune = []rune(s)

fmt.Println(bs)
fmt.Println(rs)
```
```Output
[72 101 108 108 111 32 240 159 145 139]
[72 101 108 108 111 32 128075]
```
The first output line has the string converted to UTF-8 bytes. The second has the string converted to runes.
***
## Maps
Go provides a built-in data type for situations where you want to associate one value to another. The map type is written as *map[keyType]valueType*. 
You can use the `var` declaration to create a map variable that's set to its zero value.
```Go
var nilMap map[string]int
```
In this case, `nilMap` is declared to be a map with `string` keys and `int` values. The zero value for a map is `nil`. A `nil` map has a length of 0. Attempt to write to a `nil` map variable causes a panic.
You can use a `:=` declaration to create a map variable by assigning it a map literal.
```Go
totalWins := map[string]int{}
```
In this case you are using an empty map literal. This is not the same as a `nil` map. It has a length of 0, but you can read and write to a map assigned an empty map literal.
Here's what a non empty map looks like.
```Go
teams := map[string][]string{
	"Orcas": []string{"Fred", "Ralp", "Bijou"},
	"Lions": []string{"Sarah", "Peter", "Billie"},
	"Kittens": []string{"Waldo", "Raul", "Ze"},
}

fmt.Println(teams)
```

If you know how many key-value pairs you intend to put in the map but don't know the exact values, you can use `make` to create a map with a default size.
```Go
ages = make(map[int][]string, 10)
```
Maps created with `make` still have a length of 0, and they can grow past the initially specified size.
Maps are like slices in several ways:
- Maps automatically grow.
- If you know how many key-value pairs you plan to insert into a map, you can use `make` to create a map with a specific initial size.
- Passing a map to `len` function tells you the number of key-value pairs in a map.
- The zero value for a map is nil.
- Maps are not comparable.
- You cannot use a slice or a map as the key for a map.

### Reading and Writing a Map
Program that declares, writes to, and reads from a map.
```Go
totalWins := map[string]int{}
fmt.Println(totalWins)

totalWins["Orcas"] = 1
totalWins["Lions"] = 2
fmt.Println(totalWins)

fmt.Println(totalWins["Orcas"])
fmt.Println(totalWins["Kittens"])

totalWins["Kittens"]++
fmt.Println(totalWins["Kittens"])

totalWins["Lions"] = 3
fmt.Println(totalWins)

clear(totalWins)
fmt.Println(totalWins)
```
```Output
map[]
map[Lions:2 Orcas:1]
1
0
1
map[Kittens:1 Lions:3 Orcas:1]
map[]
```
### The comma ok Idiom
A map returns the zero value if you ask for the value associated with a key that's not in the map. This is handy when implementing things like `totalWins` counter. However, you sometimes do need to find out if a key is in a map. Go provides the *comma ok idiom* to tell the difference between a key that's associated with a zero value and a key that's not in the map.
```Go
m := map[string]int{
	"hello": 5,
	"world": 0,
}

var v, ok = m["hello"]
fmt.Println(v, ok)

v, ok = m["world"]
fmt.Println(v, ok)

v, ok = m["goodbye"]
fmt.Println(v, ok)
```
```Output
5 true
0 true
0 false
```
### Deleting from Maps
Key-value pairs are removed from a map via the build in `delete` function.
```Go
m := map[string]int{
	"hello": 5,
	"world": 0,
}

delete(m, "hello")
```
### Emptying a Map
The `clean` function can be used to empty a map. A cleaned map has its length set to zero.
```Go
m := map[string]int{
	"hello": 5,
	"world": 0,
}

clean(m)
fmt.Println(m)
```
```Output
map[] 0
```
### Comparing Maps
Go added a package to the standard library called `maps` that contains helper functions for working with maps. Two functions in the package are useful for comparing if two maps are equal, `maps.Equal` and `maps.EqualFunc`. 
```Go
import {
	"fmt"
	"maps"
}

m := map[string]int{
	"hello": 5,
	"world": 10,
}

n := map[string]int{
	"world": 10,
	"hello": 5,
}

fmt.Println(maps.Equal(m, n)) // Prints true
```
### Using Maps as Sets
A *set* is a data type that ensures there is at most one of a value, but doesn't guarantee that the values are in any particular order.
Checking to see if an element is in a set is fast, no matter how many elements are in the set.
Go doesn't include set, but you can use a map to simulate some of its features. 
```Go
var intSet = map[int]bool{}

vals := []int{5, 10, 2, 5, 8, 9, 1, 2, 10}

for _, v := range vals {
	intSet[v] = true
}

fmt.Println(len(vals), len(intSet))
fmt.Println(intSet[5])
fmt.Println(intSet)

if intSet[10] {
	fmt.Println("10 is in the set")
}
```
```Output
9 6
true
false
map[1:true 2:true 5:true 8:true 9:true 10:true]
10 is in the set
```
***
## Structs
Maps are a convenient way to store some kinds of data, but they have limitations. They don't define an API since there's no way to constrain a map to allow only certain keys. Also, all values in a map must be of the same type. 
When you have related data that you want to group together, you should define a *struct*.
```Go
type person struct {
	name string
	age int
	pet string
}
```
A struct type is defined with the keyword `type`, the name of the struct type, the keyword `struct`, and a pair of braces ({}). Within the braces, you list the field in the struct. 
Once a struct type is declared, you can define variables of that type.
```Go
var fred person
```
Since no value is assigned to `fred`, it gets the zero for the `person` struct type. A zero value struct has every field set to the field's zero value.
A *struct literal* can be assigned to a variable as well.
```Go
bob := persion{}
```
Unlike maps, there is no difference assigning an empty struct literal and not assigning a value at all. There are two styles for a nonempty struct literal. 
```Go
julia := person{
	"Julia",
	40,
	"cat",
}
```
When using this struct literal format, a value for every field in the struct must be specified, and the values are assigned to the fields in the order they were declared int the struct definition.
The second struct literal style look like the map literal style.
```Go 
beth := person{
	age: 30,
	name:  "Beth",
}
```
This style has some advantages. It allows you to specify the fields in any order, and you don't need to provide a value for all fields. Any field not specified is set to its zero value.

A field in a struct is accessed with dot notation.
```Go
bob.name = "Bob"
fmt.Println(bob.name)
```
### Anonymous Structs
You can also declare that a variable implements a struct type without first giving the struct type a name. This is called an *anonymous struct*.
```Go
var person struct {
	name string
	age int
	pet string
}

person.name = "bob"
person.age = 12
person.age = "dog"

pet := struct {
	name string
	kind string
}{
	name: "Fido",
	kind: "dog",
}
```
In this example, the types of the variable `peerson` and `pet` are anonymous structs. Anonymous structs are handy in two common situations.
The first is when you translate external data into a struct or a struct into external data (like JSON).
Writing test is another place where anonymous structs pop up. 
### Comparing and Converting Structs
Whether a struct is comparable depends on the struct's fields. Structs that are entirely composed of comparable types are comparable; those with slice or map fields are not.
Go does allow you to perform a type conversion from one struct type to another *if the fields of both structs have the same names, order, and types*. 
```Go
type firstPerson struct {
	name string
	age int
}
```
You can use type conversion to convert an instance of `firstPerson` to `secondPerson`, but you can't use `==` to compare an instance of `firstPerson` and an instance of `secondPerson`, because they are different types.
```Go
type secondPerson struct {
	name string
	age int
}
```
You can't convert an instance of `firstPerson` to `thirdPerson`, because the fields are in a different order.
```Go
type thirdPerson struct {
	age int
	name string
}
```
You can't convert an instance of `firstPerson` to `fourthPerson` because the field names don't match.
```Go
type thirdPerson struct {
	firstName string
	age int
}
```
Finally, you can't convert an instance of `firstPerson` to `fifthPerson` because there's an additional field.
```Go
type fifthPerson struct {
	name string
	age int
	favouriteColor string
}
```
Anonymous structs add a twist, if two struct variables are being compared and at least one has a type that's an anonymous struct, you can compare them without a type conversion if the field of both structs have the same names, order and type. 
```Go
type firstPerson struct {
	name string
	age int
}

f := firstPerson{
	name: "Bob",
	age: 50,
}

var g struct {
	name string
	age int
}

// compares 
g = f
fmt.Println(f == g)
```
