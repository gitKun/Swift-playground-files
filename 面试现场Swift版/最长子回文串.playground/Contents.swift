import Foundation


let string = "eabadabacss"
let charS = string[string.index(string.startIndex, offsetBy: 3)]
//print(string.endIndex.encodedOffset)
//let indexChar = String.Index.init(encodedOffset: 3)
//print(string[indexChar])

print(string.endIndex.utf16Offset(in: string))
let indexChar = String.Index(utf16Offset: 3, in: string)
print(string[indexChar])



func isPlalindrome(s: String) -> Bool {
    /*
    let string = s as NSString
    let length = string.length
    for index in 0..<length {
        if (string.character(at: index) != string.character(at: length - 1 - index)) {
            return false
        }
    }
     */
    let count = s.count / 2
    let startIndex = s.startIndex
    for index in 0..<count  {
        if (s[s.index(startIndex, offsetBy: index)] != s[s.index(startIndex, offsetBy:(count - 1 - index))]) {
            return false
        }
    }
    return true
}

print(isPlalindrome(s: "#a#d#a#"))
print(isPlalindrome(s: "#a#d#d#a#"))
print(isPlalindrome(s: string))

// 预处理字符串,在字符中间加入#
func preHandleString(_ s: String) -> String {
    var stringArray = ["#"]
    for (_, item) in s.enumerated() {
        stringArray.append(String(item) + "#")
    }
    return stringArray.joined()
}

// 寻找最长回文子串
func findLongestPlalindromeString(_ s: String) -> String{
    // 先预处理字符串
    let str = preHandleString(s)
//    let str = s
    // 处理后的字串长度
    let len = str.count
    // 右边界
    var rightSide = 0
    // 右边界对应的回文串中心
    var rightSideCenter = 0
    // 保存以每个字符为中心的回文长度一半（向下取整）
    var halfLenArr: [Int] = Array.init(repeating: 0, count: len)
    // 记录回文中心
    var center = 0
    // 记录最长回文长度
    var longestHalf = 0

    //
    let startIndex = str.startIndex

    for i in 0..<len {
        // 是否需要中心扩展
        var needCalc = true
        // 如果在右边界的覆盖之内
        if rightSide > i {
            // 计算相对rightSideCenter的对称位置
            let leftCenter = 2 * rightSideCenter - i
            // 根据回文性质得到的结论
            halfLenArr[i] = halfLenArr[leftCenter]
            // 如果超过了右边界，进行调整
            if i + halfLenArr[i] > rightSide {
                halfLenArr[i] = rightSide - i
            }
            // 如果根据已知条件计算得出的最长回文小于右边界，则不需要扩展了
            if i + halfLenArr[leftCenter] < rightSide {
                needCalc = false
            }
        }
        // 中心扩展
        if needCalc {
            while (i - 1 - halfLenArr[i] >= 0 && i + 1 + halfLenArr[i] < len ) {
                if str[str.index(startIndex, offsetBy: i + 1 + halfLenArr[i])] == str[str.index(startIndex, offsetBy: i - 1 - halfLenArr[i])] {
                    halfLenArr[i] = halfLenArr[i] + 1
                }else {
                    break
                }
            }
            // 更新右边界及中心
            rightSide = i + halfLenArr[i]
            rightSideCenter = i
            // 记录最长回文串
            if halfLenArr[i] > longestHalf {
                center = i
                longestHalf = halfLenArr[i]
            }
        }
    }
    // 去掉之前添加的 #
    var resultArr: [String] = []
    for i in stride(from: center - longestHalf + 1, through: center + longestHalf, by: 2){
        resultArr.append(String(str[str.index(startIndex, offsetBy: i)]))
    }
//    for i in stride(from: center - longestHalf, through: center + longestHalf, by: 1) {
//        resultArr.append(String(str[str.index(startIndex, offsetBy: i)]))
//    }
    return resultArr.joined();
}

let testStrArr = [
    "abcdcef",
    "adaelele",
    "cabadaba",
    "cabadabae",
    "cabaddabae",
    "aaaabcdefgfedcbaa",
    "aaba",
    "aaaaaaaaa"
]


print("最长回文串: \(findLongestPlalindromeString("cabadabae"))")

for str in testStrArr {
    print("原字符串: \(str)")
    print("最长回文串: \(findLongestPlalindromeString(str))")
}

