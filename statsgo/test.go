package main
import (
	"fmt"
	//"io/ioutil"
	//"encoding/json"
)

type fileData struct{
	name string
	age int
}

func main(){
	//fmt.Println("hi")
	// fmt.Println(getname())
	readtoMem()
}

func getname() (byte){
	return 102
}

func readtoMem(){
	// data, err := ioutil.ReadFile("dummy.json")

	// if err != nil {
	// 	fmt.Println("file reading error", err)
	// }
	// var result fileData
	// json.Unmarshal(data,&result)
	// fmt.Println(result)

	var user []fileData = { "name" : "akash", age: 10}
	

	fmt.Println(user)
}