import UIKit

/// 2. 레퍼런스 카운팅 (Reference Counting)
/// Swift는 Heap에 할당된 메모리가 언제 해제해도 되는지, 언제 해야 안전한지 어떻게 알까?
/// - Swift는 Heap의 모든 인스턴스에 대한 Reference Counting을 유지함
/// - Reference Counting은 각각의 인스턴스 내부에 위치함
/// -> Reference Counting이 0이 될 경우 해지해도 안전하다는 것을 알게 됨
///
/// Reference Counting은 매우 빈번하게 수행됨
/// - 카운팅을 증가/감소 시키는 것은 정수를 증가/감소하는 것 보다 더 많은 작업을 거침
/// - Heap 메모리 특성상 다른 Thread에서도 접근이 가능하기 때문에 Thread Safety를 고려해야함
/// -> 원자적으로 Reference Counting의 증가/감소를 진행해야함
///  - Reference Counting 빈도로 인해 비용이 늘어날 수 있음
///
/// 원자성 (atomically)
/// - 작업이 부분적으로 실행되거나 중단되지 않는 것을 보장하는 것
/// -> 티켓 예매 시 결제와 동시에 좌석이 지정되는 걸 보장하는 것, 결제/지정 둘 중 하나만 되는 건 허용하지 않음
///
/// 컴파일러는 Class를 비롯한 Heap 메모리 할당 시 아래 코드를 자동으로 삽입함
/// refCount: 레퍼런스의 카운트를 나타내는 값 (Class 내부 위치)
/// retain/release: 레퍼런스 카운트를 올리고 내릴 때 사용
/// - 값을 할당/해지 한다고 해서 레퍼런스 카운트가 자동으로 올라가는 것이 아닌 위 함수를 호출해야함

class SizeClass {
    var width, height: Double
    // var refCount:Int // SizeClass에 대한 레퍼런스 카운트를 나타냄
    
    init(width: Double, height: Double) {
        self.width = width
        self.height = height
    }
}

var sizeClass1: SizeClass? = SizeClass(width: 100.0, height: 100.0)

var sizeClass2: SizeClass?  = sizeClass1
// retain(sizeClass2) // SzieClass에 대한 레퍼런스 카운트 증가함

sizeClass1 = nil
// release(sizeClass1) // SizeClass에 대한 레퍼런스 카운트 감소

sizeClass2 = nil
// release(sizeClass2) // SizeClass에 대한 레퍼런스 카운트 감소 + 0이 되어서 메모리 해지

print(sizeClass1, sizeClass2)

/// Struct은 내부에 Value 타입만 사용할 경우 Heap 메모리를 할당 받아 사용하지 않음
/// 단 Struct 내부의 프로퍼티가 Heap을 사용하는 객체라면 Heap 메모리를 할당 받아서 사용함
/// - Struct 내부에 Heap을 사용하는 객체는 Struct 내부에 프로퍼티에는 Heap의 레퍼런스만 저장하고, Heap에 데이터를 저장함 (Class의 저장방식과 동일)
/// 값을 복사하거나 제거할 때는 Struct 자체는 복사되지만 내부 Heap을 사용하는 객체는 레퍼런스 관리를 거치게됨
/// -> refCount 관리, retain/release

struct Message {
    var text: String
    var font: UIFont
    var size: CGSize
}

var message1: Message? = Message(text: "", font: .boldSystemFont(ofSize: 10), size: .init(width: 10, height: 10))

CFGetRetainCount(message1?.font)

var message2: Message? = message1
// retain(message1.text._storage)
// retain(message1.font) // Heap을 사용하기 때문에 레퍼런스 카운트를 관리함

CFGetRetainCount(message1?.font)

message1 = nil
// release(message1.text._storage)
// release(message1.font)

message2 = nil
// release(message2.text._storage)
// release(message2.font)

// CFGetRetainCount(message1?.font) -> 오류 발생

/// Struct 내부에 Heap 타입을 사용하는 레퍼런스가 있을 경우 값을 복사/할당/제거 할 때 Heap을 사용하는 객체 모두에 대한 레퍼런스 관리를 해야하기 때문에 오버헤드가 커지게됨
/// - Heap 레퍼런스 수에 비레하여 오버헤드를 지불하게 됨
/// -> 2개 이상의 Heap 메모리를 사용하는 프로퍼티가 있다면 Class를 사용하는 것이 더 효율적일 수 있음
/// -> 2개 이상인 경우 Class 보다 오버헤드가 더 발생함

class InnerClass {
    var num = 0
}

class ClassOfClass {
    var innerClass: InnerClass = .init()
    var innerClass2: InnerClass = .init()
}

struct StructOfClass {
    var innerClass: InnerClass = .init()
    var innerClass2: InnerClass = .init()
}

let class1 = ClassOfClass()
let class2 = class1
let class3 = class1
let class4 = class1

let struct1 = StructOfClass()
let struct2 = struct1
let struct3 = struct1
let struct4 = struct1

CFGetRetainCount(class1.innerClass)
CFGetRetainCount(struct1.innerClass)
