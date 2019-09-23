import Foundation

var mutableArray = [1, 2, 3]
for _ in mutableArray {
    print("执行了一次")
//    mutableArray.removeLast()
    mutableArray.removeAll()
    print("mutableArray = \(mutableArray)")
}

struct Student {
    var age: Int
}

var screens: [Student] = [] {
    didSet {
        print("Screens array changed:\(screens)")
    }
}

screens.append(Student(age: 10))
//Screens array changed:[__lldb_expr_15.Student(age: 10)]
screens[0].age = 11
//Screens array changed:[__lldb_expr_15.Student(age: 11)]

/*
 screens[0] 被自动的作为 inout 变量
 那些像 += 这样的操作符(函数) 需要其参数为 inout
 */





