### 代码



1. 布局一个棋盘 (如图)

	![chessBoard_2x.png](chessBoard_2x.png)

	```
	struct Chessboard {
    	let boardColors: [Bool] = {
        	var temporaryBoard = [Bool]()
        	var isBlack = false
        	for i in 1...8 {
            	for j in 1...8 {
                	temporaryBoard.append(isBlack)
                	isBlack = !isBlack
            	}
            	isBlack = !isBlack
        	}
        	return temporaryBoard
    	}()
    	func squareIsBlackAt(row: Int, column: Int) -> Bool {
        	return boardColors[(row * 8) + column]
    	}
	}
	```

2. 对于可选链要注意 `=` 运算符右手侧是否被评判(执行)，如：


	```
	let somePerson.residence?.address = someAddress
	```
	
	```
	func createAddress() -> Address {
    	print("Function was called.")
    	let someAddress = Address()
    	someAddress.buildingNumber = "29"
    	someAddress.street = "Acacia Road"
    	return someAddress
	}
	somePerson.residence?.address = createAddress()
	```
	
	上面的例子中如果 `somePerson.residence` 为 `nil` 则函数不会被调用；

3. 赋值表达式的返回值

	```
	var setI: Float = 1
	print(setI = 3.1)
	// ()
	```
	
	赋值表达式有个返回值 `Void` 类型，或者成为 内容为空的 `元组` `()`;
	
	
4. 元类型

	元类型指的是所有类型的类型，包括类类型、结构体类型、枚举类型和协议类型 
	
	类、结构体或枚举类型的元类型是类型名字后紧跟 `.Type`  。协议类型的元类型——并不是运行时遵循该协议的具体类型——是的该协议名字紧跟 `.Protocol` 。例如，类类型 `SomeClass` 的元类型就是 `SomeClass.Type` ，协议类型 `SomeProtocol` 的元类型就是 `SomeProtocal.Protocol` 。

	你可以使用后缀 `self` 表达式来获取类型作为一个值。比如说， `SomeClass.self` 返回 `SomeClass` 本身，而不是 `SomeClas` 的一个实例。并且 `SomeProtocol.self`  返回 `SomeProtocol` 本身，而不是运行时遵循 `SomeProtocol` 的某个类型的实例。你可以对类型的实例使用 `dynamicType` 表达式来获取该实例的动态运行时的类型，

	```
	class SomeBaseClass {
	    class func printClassName() {
	        print("SomeBaseClass")
	    }
	}
	class SomeSubClass: SomeBaseClass {
	    override class func printClassName() {
	        print("SomeSubClass")
	    }
	}
	let someInstance: SomeBaseClass = SomeSubClass()
	// The compile-time type of someInstance is SomeBaseClass,
	// and the runtime type of someInstance is SomeSubClass
	someInstance.dynamicType.printClassName()
	// Prints "SomeSubClass"
	
	```

5. **weak** 与 **unowned**

	[弱引用](https://www.cnswift.org/automatic-reference-counting#spl-3)
	
	[无主引用](https://www.cnswift.org/automatic-reference-counting#spl-7)
	
	- 无主引用是非可选类型, `ARC` 无法在实例被释放后将无主引用设为 `nil` ，因为非可选类型的变量不允许被赋值为 `nil` 。
	
	- 弱引用不会强保持对实例的引用,需要允许它们的值为 `nil` ，它们一定得是 **可选类型**
	
	注意：
	
	> 在 `ARC` 给弱引用设置 `nil` 时不会调用属性观察者。
	
	> 如果你试图在实例的被释放后访问无主引用，那么你将触发运行时错误。只有在你确保引用会一直引用实例的时候才使用无主引用。

	> 还要注意的是，如果你试图访问引用的实例已经被释放了的无主引用，Swift 会确保程序直接崩溃。你不会因此而遭遇无法预期的行为。所以你应当避免这样的事情发生


### swift 中的注意点

> [无主引用和隐式展开的可选属性](https://www.cnswift.org/automatic-reference-counting#spl-7)

> 如果被捕获的引用永远不会变为 `nil` ，应该用无主引用而不是弱引用。

	

### 基础知识备忘录

> 负数的编码就是所谓的 `二进制补码` 表示
> 
> 首先，如果想给 -4 加个 -1  ，只需要将这两个数的全部八个比特位相加（包括符号位），并且将计算结果中超出的部分丢弃：
> 
> 其次，使用二进制补码可以使负数的位左移和右移操作得到跟正数同样的效果，即每向左移一位就将自身的数值乘以 2 ，每向右一位就将自身的数值除以 2 。要达到此目的，对有符号整数的右移有一个额外的规则：当对正整数进行位右移操作时，遵循与无符号整数相同的规则，但是对于移位产生的空白位使用符号位进行填充，而不是 0 。


	