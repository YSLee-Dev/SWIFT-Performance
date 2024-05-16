import Foundation

/// 1. 할당
/// Swift는 자동으로 메모리를 할당하고 해지함
///
/// Stack
/// Stack은 LIFO 구조로 상단 Top 부분에서만 Push, Pop이 가능
/// - 해당 Top 부분을 Stack Pointer라고 칭하며, Pointer를 이용해 메모리를 할당/ 해지할 수 있음
/// -> Stack Pointer가 가르키고 있는 부분을 줄임으로써 메모리를 할당할 수 있고, 가르키고 있는 부분을 증가시킴으로써 메모리를 해지할 수 있음
/// - Stack은 O(1)로 아주 빠름
///
/// Heap
/// Heap은 Stack 대비 Dynamic lifetime을 가진 메모리를 할당할 수 있어 동적이지만, 효율적이지 못함
///
/// Heap이 메모리에 할당되는 방법
///     0. Stack에 Heap 메모리의 레퍼런스를 저장할 공간을 만듦
///     1. Heap 메모리를 lock하고 적절한 메모리 블록을 찾음
///   ->  Heap은 Swift 내부에서 실시하는 메모리 관리를 위해 데이터 보다 더 큰 공간을 할당함
///     2. 적절한 블록에 데이터를 저장 후 Stack에는 Heap 메모리의 레퍼런스를 저장함
///     3. 사용이 끝난 경우 Heap 메모리를 lock하고 사용하지 않는 메모리 블록을 적절한 위치에 삽입함
///     4. Stack 메모리를 pop함
///
/// Heap 메모리를 lock 하는 이유
/// - Heap 메모리는 다른 쓰레드에서도 메모리를 할당할 수 있기 때문에 동기화 메커니즘을 통해 무결성을 보호해야함
///
/// Stack VS Heap
/// - Stack은 Struct, Enum이 사용, Heap은 Class가 사용함
/// - Struct은 Value 타입, Class은 Reference으로 데이터를 저장함
/// -> 값을 복사할 때 Struct은 실제로 값을 복사하지만, Class는 Heap 메모리에 대한 참조만 복사함
/// ->> Class는 복사한 프로퍼티에 Heap 메모리 참조를 복사하기만 할 뿐 실제로 값을 복사하지 않음
///
/// 이러한 특징으로 인해 Heap 메모리를 사용하는 Class는 Struct 대비 비용이 많이 들게 됨
/// -> 메모리를 찾는 과정도 비용이 발생하지만 무결성 보장으로 인한 메커니즘이 비용이 더 큼
/// - Heap에 할당된다는 특징은 레퍼런스 체계를 가지므로 간접 저장소와 같은 특성이 있음
///  -> 추상화가 필요 없고 값을 공유하지 않아도 되는 경우 Struct을 사용하는게 효율적일 수 있음

struct SizeStruct {
    var width, height: Double
}

let sizeStruct1 = SizeStruct(width: 100.0, height: 100.0) // Stack에 값 할당
var sizeStruct2 = sizeStruct1 // 값을 복사하여 새로운 인스턴스 생성
sizeStruct2.width = 150.0
sizeStruct2.height = 150.0

print("----struct----")
print("SizeStruct1: ", sizeStruct1.width, sizeStruct1.height)
print("SizeStruct2: ", sizeStruct2.width, sizeStruct2.height) // 각자 독립적인 인스턴스이기 때문에 값이 공유되지 않음

class SizeClass {
    var width, height: Double
    
    init(width: Double, height: Double) {
        self.width = width
        self.height = height
    }
}

let sizeClass1 = SizeClass(width: 100.0, height: 100.0) // Heap에 값을 할당하고 Stack에 Heap Reference를 저장
var sizeClass2 = sizeClass1 // Heap Reference를 복사하여 Stack에 저장
sizeClass2.width = 150.0
sizeClass2.height = 150.0

print("----class----")
print("SizeClass1: ", sizeClass1.width, sizeClass1.height)
print("SizeClass1 Reference", sizeClass1)
print("SizeClass2: ", sizeClass2.width, sizeClass2.width) // 동일한 Reference를 바라보고 있기 때문에 값이 둘 다 변경됨
print("SizeClass2 Reference", sizeClass2)

/// String은 어느 메모리에 저장될까?
/// - String은 Value 타입에 속하지만 내부에는 참조타입의 성격을 가지는 Text Storage를 통해 데이터를 관리함
/// - 짧은 String은 Stack에 바로 저장될 수 있지만, 텍스트가 길거나 특정 조건에 부합하는 경우 Text Stroage를 사용하게 됨
/// -> Heap 메모리를 사용하는 것
///
/// String은 무조건 Stack에 저장되지 않기 때문에 성능을 최적화 할 때에는 Struct, Enum 등 String을 대채할 수 있는 Value 타입을 쓰는게 좋을 수 있음

enum Key: Hashable {
    case groupOne
    case groupTwo
}

var cache1: [String: Int] = [:]
var cache2: [Key: Int] = [:]

// 딕셔너리를 String으로 사용할 경우 Heap 메모리를 참조하게 되며, 안전하지 않음
cache1["groupOne"] = 1
// Value 타입의 Enum에 Hashable을 준수해서 사용할 경우 Heap 메모리를 사용하지 않으며, 원하는 값만 넣을 수 있음
cache1["groupTwo"] = 2

cache2[.groupOne] = 1
cache2[.groupTwo] = 2

print("cache1: ", cache1)
print("cache2: ", cache2)
