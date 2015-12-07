//: Playground - noun: a place where people can play

import UIKit

// struct GaussianBlur {
//    var inputImage: CIImage
//    var radius: Double
//}
//
//let image = CIImage()
//
//var blur1 = GaussianBlur(inputImage: image, radius: 10)
//blur1.radius = 20
//var blur2 = blur1
//blur2.radius = 30


//Note that inputImage is an object and will be shared between blur1 and blur2. However, CIImage is immutable by design. Therefore, sharing the image between two structs is safe.



 struct GaussianBlur {
    
     var inputImage: CIImage {
        get { return filter.valueForKey(kCIInputImageKey) as! CIImage }
        set { filterForWriting.setValue(newValue, forKey: kCIInputImageKey) }
    }
    
    var radius: Double {
        get { return filter.valueForKey(kCIInputRadiusKey) as! Double }
        set { filterForWriting.setValue(newValue, forKey: kCIInputRadiusKey) }
    }
    
    private var filter: CIFilter
    init(inputImage: CIImage, radius: Double) {
        filter = CIFilter(name: "CIGaussianBlur", withInputParameters: [ kCIInputImageKey: inputImage, kCIInputRadiusKey: radius
        ])!
    }
}

 extension GaussianBlur {
    private var filterForWriting: CIFilter {
        mutating get {
            filter = filter.copy() as! CIFilter
            return filter
        }
    }
}


let image = CIImage()
let blur = GaussianBlur(inputImage: image, radius: 10)
var blur2 = blur
assert(blur.filter === blur2.filter)


blur2.radius = 25
assert(blur.filter !== blur2.filter)