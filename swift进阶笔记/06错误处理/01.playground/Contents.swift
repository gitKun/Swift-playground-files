import Foundation
import UIKit


print("Hello world!")

//extension Sequence {
//    func all(matching predicate: (Element) -> Bool) -> Bool {
//        for element in self {
//            guard predicate(element) else { return false }
//        }
//        return true
//    }
//}


/// Rethrows 关键字

extension Sequence {
    func all(matching predicate: (Element) throws -> Bool) rethrows -> Bool {
        for element in self {
            guard try predicate(element) else { return false }
        }
        return true
    }
}



//extension Result {
//    func flatMap<B>(transform: (A) -> Result<B>) -> Result<B> {
//        switch self {
//        case let .failure(m):
//            return .failure(m)
//        case let .success(x):
//            return transform(x)
//        }
//    }
//}


//func compute(callback: (Int) -> ())
//
//compute { result in
//    print(result)
//}














