## Installing the Go Tools 
To build Go code, you need to download and install the Go development tools.
> Download Link: https://go.dev/

Command to check go version
```bash
go version
```

## Go Tooling
All of the Go development tools are accessed via the go command. In addition to go version, there's a compiler (go build), code formatter (go fmt), dependency manager (go test), a tool that scans for common coding mistakes (go vet), and more.
For now let's look ate most common used tools by writing some code.

## Making a Go Module
The first thing you need to do is create a directory to hold your program. Call it *ch1*.
```bash
mkdir ch1
cd ch1
```
Inside the directory, run the go mod init command to mark this directory as a Go module.
```bash
go mod init hello_world
```
**A Go project is called as *module***. A module is not just source code. It is also an exact specification of the dependencies of the code within the module. Every module has a *go.mod* file in its root directory. Running go mod init creates this file for you. 
The *go.mod* file declares the name of the module, the minimum supported version of Go for the module, and any other modules that your module depends on.

## go build
open text editor and save this code inside the *ch1* with the file name **hello.go**
```go
package main

import "fmt"

func main() {
	fmt.Println("Hello World!")
}
```
After the file is saved, go back to your terminal or cmd and type.
```bash
go build
```
This creates an executable called hello_world. To run it use this command.
```bash 
./hello_world
```

If you want a different name for your application, or if you want to store it in a different location, use the *-o* flag.
For example, if you wanted to compile the code to a binary called "hello," you would use the following.
```go
go build -o hello
```

## go fmt
The go development tools include a command, **go fmt**, which automatically fixes the whitespaces in your code to match the standard format. However, it can't fix braces on the wrong line. Run it with the following.
```bash
go fmt ./...
```
Using `./...` tells a Go tool to apply the command to all the files in the current directory and all subdirectories. 

## go vet 
The go tool includes a command called go vet to detect bugs and errors. Add one to the program and watch it get detected. 
```go
fmt.Println("Hello World, %s!\n")
```
In this example you have a template with %s placeholder, but no value was specified for the placeholder. This code will compile and run, but it's not correct.

## Makefiles
Go developers have adopted make as their solution. It lets developers specify a set of operations that ate necessary to build a program and the order in which the steps must be performed.
Create a file called *Makefile* in the ch1 directory with the following contents.
```Makefile
.DEFAULT_GOAL := build

.PHONY:fmt vet build
fmt: 
	go fmt ./...
vet: fmt
	go vet ./...
build: vet
	go build
```
Run make
```bash
	make
```
Entering a single command formats the code correctly, checks it for non-obvious errors, and compiles it.