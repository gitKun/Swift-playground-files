import UIKit

typealias FnClo = (Int) -> (Int, Int)

func getFun() -> (FnClo, FnClo) {
    var num1 = 0
    var num2 = 0
    func plus(_ i: Int) -> (Int, Int) {
        num1 += i
        num2 += i << 1
        return (num1, num2)
    }
    
    func mnus(_ i: Int) -> (Int, Int) {
        num1 -= i
        num2 -= i << 1
        return (num1, num2)
    }
    return (plus, mnus)
}

let (p, m) = getFun()
print(p(5))
print(m(4))

print(p(3))
print(m(2))

class Person {
    var age = 9
}

typealias Clo = (Int) -> Int
func getFunc2() -> Clo {
    var p = Person()
    func plus(_ v: Int) -> Int {
        p.age += v
        return p.age
    }
    return plus
}

var f = getFunc2()

f(3)

