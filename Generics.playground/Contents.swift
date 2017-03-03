//: Playground - noun: a place where people can play

import UIKit

//Generic Functions, T : type parameter(大於一個，用逗號隔開)，可作為函數的參數，返回值，函數內部宣告的型別，命名要有意義，沒意義的話就取T, U....

func swapTwoValues<T>(_ a: inout T, _ b: inout T){
    let temporaryA = a
    a = b
    b = temporaryA
}

//Generic types（Array, Dictionary都是struct）, Element: type parameter
struct Stack<Element>{
    var items = [Element]()
    mutating func push(_ item: Element){
        items.append(item)
    }
    mutating func pop(){
        items.removeLast()
    }
}
//創立instance
var stackOfString = Stack<String>()

//extention generic type時，不必給定type parameter list, 內部可直接使用type parameter
extension Stack{
    var topItem : Element?{
        return items.isEmpty ? nil : items[items.count - 1]
    }
}

//type constraint (ex: Dictionary 的key的型別皆遵從Hashable protocol)
//enable you to define requirement on the type parameters associated with a generic function or type.
func findIndex<T: Equatable>(of valueToFind: T, in array: [T]) -> Int?{
    for (index, value) in array.enumerated(){
        if value == valueToFind{
            return index
        }
    }
    return nil
}

//Associated types : it gives a placeholder name to a type that is used as part of the protocol
protocol Container{
    associatedtype ItemType
    mutating func append(_ item: ItemType)
    var count: Int{get}
    subscript(i: Int) -> ItemType{get}
}

struct IntStack: Container{
    var items = [Int]()
    
    mutating func push(_ item: Int){
        items.append(item)
    }
    
    mutating func pop(){
        items.removeLast()
    }
    
    typealias ItemType = Int //這行不打，也會自動推斷型別
    
    mutating func append(_ item: Int) {
        self.push(item)
    }
    
    var count: Int{
        return items.count
    }
    
    subscript(i: Int) -> Int{
        return items[i]
    }
}
//自動推斷Container的型別要為Element
extension Stack: Container{
    
    mutating func append(_ item: Element) {
        self.push(item)
    }
    var count: Int{
        return items.count
    }
    subscript(i: Int) -> Element{
        return items[i]
    }
}

extension Array: Container{}

//Generic where clause: define equirement for associated types
func allItemsMatch<C1: Container, C2: Container>(_ someContainer: C1, _ anotherContainer: C2) -> Bool where C1.ItemType == C2.ItemType, C1.ItemType: Equatable{
    if someContainer.count != anotherContainer.count{return false}
    
    for i in 0..<someContainer.count{
        if someContainer[i] != anotherContainer[i]{return false}
    }
    
    return true
}
