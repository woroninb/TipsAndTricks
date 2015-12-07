//: Playground - noun: a place where people can play

import UIKit


//Map

let ao1:[Int?] = [1,2,3,4,5,6]
let ao2 = ["1","2","3","a"]

var ao1m = ao1.map({$0! * 2})

var s1:String? = "1"

var i1 = s1.map {
    Int($0) // additional wrapping performed by map.
}

let test = ao2.map {
    Int($0)
    }
    .filter({$0 != nil})
    .map {$0! * 2}
/* [Int?] with content [.Some(2),.Some(4),.Some(6)] */


i1 /* Int?? with content 1 */
ao1m /* [Int] with content [2, 4, 6, 8, 10, 12]  */


//FlatMap

var s2:String? = "1"
var i2 = s1.flatMap {
    Int($0) // no additinal wrapping
}

var far1 = ["1","2","3","a"]
var far1m = far1.flatMap {
        Int($0)
    }.map {
        $0 * 2
}


//FlatMap

