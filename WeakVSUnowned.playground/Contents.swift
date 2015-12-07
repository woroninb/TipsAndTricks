//: Playground - noun: a place where people can play

import UIKit


//First, the window gets created, and the reference count for the window will be one. 
//The view gets created and holds a strong reference to the win- dow, so the window’s reference count will be two, and the view’s reference count will be one. 
//Then, assigning the view as the window’s rootView will increase the view’s reference count by one. 
//Now, both the view and the window have a reference count of two. After setting both variables to nil, they still have a reference count of one.


 class View {
    unowned var window: Window
    init(window: Window) {
        self.window = window
    }
    
    deinit {
        print("deinit")
    }
}

class Window {
    var rootView: View?
}

//In the code below, we create a window and a view. 
//The view strongly ref- erences the window, but because the window’s rootView is declared as weak, the window does not strongly reference the view. 
//This way, we have broken the reference cycle, and after setting both variables to nil, both views get deallocated:


var window: Window? = Window()
var view: View? = View(window: window!)
window?.rootView = view!

window = nil
view = nil



//Weak references must always be optional types because they can become nil, but sometimes we might not want this.
//For example, maybe we know that our views will always have a window (so the property shouldn’t be optional), but we do not want a view to strongly reference the window.
//For these cases, there is the unowned keyword, which assumes the reference is always valid:

//class View {
//    unowned var window: Window
//    init(window: Window) {
//        self.window = window }
//}
//
//class Window {
//    var rootView: View?
//}

