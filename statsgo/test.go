package main
import (
	"fmt"
	"io/ioutil"
	//"encoding/json"
	"os"
)

type fileData struct{
	name string
	age int
}

func main(){
	
	readCmdArgs()
	readContents()
}


func readCmdArgs() {
	var a = os.Args[1:]
	fmt.Println(a)
}

func readContents() {
	var data,_ = ioutil.ReadFile("dummy.json")
	fmt.Println(string(data))
}