/*
 * Swift 中的闭包只会在使用到值时才会去捕获外部的变量
 */


var num1 = 1
var closure1 = {
    print("closure-> num1 = \(num1)")
}
num1 += 1
print("out1-> num1 = \(num1)")
closure1()
print("out2-> num1 = \(num1)")

/*
 out1-> num1 = 2
 closure-> num1 = 2
 out2-> num1 = 2
 */


var num2 = 1
var closure2 = {
    [num2] in
    print("closure2-> num2 = \(num2)")
}
num2 += 1
print("out1-> num2 = \(num2)")
closure2()
print("out2-> num2 = \(num2)")
/*
 out1-> num2 = 2
 closure2-> num2 = 1
 out2-> num2 = 2
 */

