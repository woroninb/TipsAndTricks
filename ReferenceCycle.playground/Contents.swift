//: Playground - noun: a place where people can play

import UIKit


//The usual pattern is like this: object A references object B, but object B references a callback that references object A.

 class XMLReader {
    var onTagOpen: (tagName: String) -> ()
    var onTagClose: (tagName: String) -> ()
    
    init(url: NSURL) {
        // ...
        onTagOpen = { _ in }
        onTagClose = { _ in }
    }
    deinit {
        print("reader deinit")
    }
}

 class Controller {
    let reader: XMLReader = XMLReader(url: NSURL())
    var tags: [String] = []
    
    //The reference cycle originates in the viewDidLoad method. Here, we as- sign a new closure to the XMLReader’s onTagOpen callback. This closure appends a tag to the view controller’s tags array. However, that means the closure will hold a reference to the view controller. The XMLReader will hold a reference to the closure, and the view controller will hold a ref- erence to the XMLReader, thereby creating a reference cycle
    func viewDidLoad() {
        reader.onTagOpen = { [unowned self] in
            self.tags.append($0)
        }
    }
    
    deinit {
        print("controller deinit")
    }
}

var ctrl: Controller? = Controller()
ctrl?.viewDidLoad()
ctrl = nil

//Solution To break the cycle above, we want to make sure that the closure will not reference the controller. We can do this by using a capture list and mark- ing the captured variable (self) as either weak or unowned. In this case, we know that the controller will outlive the XML reader (the reader is owned by the controller), so we can use unowned:
//func viewDidLoad() {
//    reader.onTagOpen = { [unowned self] in
//        self.tags.append($0)
//    }
//}


