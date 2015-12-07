//: Playground - noun: a place where people can play

import UIKit


// Goal: Create sequence prefixes of a string (including the string itself).


struct PrefixSequence {
    let string: String
}


var prefixSeq = PrefixSequence(string: "Hello")

prefixSeq.map { prefix in
    
}


//map, filter, reduce etc can be used to types conforimg to sequence type

var array = [1, 2, 3, 6]

var newArray = array.map {
    $0*2
}


//Example Generators

 class ConstantGenerator: GeneratorType {
    typealias Element = Int
    func next() -> Element? {
        return 1
    }
}

 class PrefixGenerator: GeneratorType {
    
    let string: String
    var offset: String.Index
    
    init(string: String) {
        self.string = string
        offset = string.startIndex
    }
    
    func next() -> String? {
        if offset < string.endIndex {
            offset++
            return string[string.startIndex..<offset]
        }
        return nil
    }
}

 var generator = PrefixGenerator(string: "halloHowAreYou?")


while let x = generator.next() {
    print(x)
}

//Conforimg to SequenceType
//NOW WE CAN ITERATE OVER ITEMS,
//TO MAKE IT WE NEED TO CONFORM OUR STRUCT TO SEQUENCETYPE PROTOCO: contains, enumerate, filter, join, lazy, map, maxElement, minElement, reduce, sorted, startsWith, underestimateCount, zip

extension PrefixSequence: SequenceType {
    func generate() -> PrefixGenerator {
        return PrefixGenerator(string: string)
    }
}

//OR!!! For

//Function-Based Generators and Sequences
//There is an even easier way to create generators and sequences. 
//Instead of creating a custom class, we can also use the built-in AnyGenerator and AnySequence types, which take a function as a parameter.

//extension PrefixSequence: SequenceType {
//    func generate() -> AnyGenerator<String> {
//        var offset = self.string.startIndex
//        return anyGenerator {
//            if offset < self.string.endIndex {
//                offset++
//                return self.string[self.string.startIndex..<offset]
//            }
//            return nil
//        }
//    }
//}

//contains, enumerate, filter, join, lazy, map, maxElement, minElement, reduce, sorted, startsWith, underestimateCount, zip

var pefixSeq = PrefixSequence(string: "Hello")


var seq = pefixSeq.map { prefix in
    prefix+"1"
}


//
//var generator = ConstantGenerator()
//while let x = generator.next() {
//  
//}


//



