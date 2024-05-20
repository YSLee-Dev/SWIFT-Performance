import UIKit

/// 3. 메소드 디스패치 (Method Dispatch)
/// 런타임에 메소드를 호출하면 Swift는 정확한 메소드를 구현(실행) 해야함
/// Dispatch는 Swift가 어떤 메소드를 호출해야 맞는지, 정확한 구현을 호출하는 과정을 의미함
///
/// 컴파일 시 디스패치를 정할 수 있는 경우 = 컴파일 시 어떤 메소드를 실행해야 하는지 결정할 수 있는 경우
/// - Static Dispatch라고 말함
/// - 컴파일러가 실제로 어떤 구현이 될 것인지 알기 떄문에 inlining 기법 등을 이용해서 코드를 최적화 할 수 있음
///
/// inlining
/// - 메소드를 호출할 때 실제 메소드를 호출하지 않고 결과 값을 바로 돌려주는 최적화 기법
/// - 굳이 실행하지 않아도 되는 메소드는 실행하지 않고 값을 계산하는 것

struct View {
    func setting() {}
}

func attribute(settingView: View){
    settingView.setting()
}

let view = View()
attribute(settingView: view) // 실제로는 실행되지 않음
// view.setting()

/// inlining 사용 시 attribute() 함수에서 setting()을 호출하지 않고, 바로 view에서 setting()을 실행하는 것
///
/// 반대로 Dynamic Dispatch는 컴파일러가 컴파일 시 어떤 구현을 실행하는지 미리 알 수 없음
/// - 런타임 시 실제 구현된 함수로 jump 하게 됨
/// -> Dynamic Dispatch는 사실 Static Dispatch와 비용차이가 크지 않지만 컴파일러의 가시성을 낮추기 때문에 최적화를 막음
/// -> 최적화를 컴파일 시 못하기 때문에 비용이 커지게 됨
///
/// Single Static Dispatch와 Single Dynamic Disaptch는 성능차이가 별로 없지만, Dispatch Chain에서 차이가 큼
/// - Static Dispatch는 컴파일러가 전체 체인에 대해 코드를 파악하고 있어서 가시성을 가질 수 있지만, Dynamic Dispatch는 컴파일럭 추론을 할 수 없기 때문에 가시성을 가지지 못함
///
/// 그럼에도 Dynamic Dispatch를 사용하는 이유는 Dynamic Dispatch를 통해서 다형성 등 다양한 기능을 사용할 수 있기 때문
///
/// 다형성
/// - 하나의 객체가 여러가지의 타입을 가질 수 있는 것
/// -> 상속이 대표적인 예

class Meth{
    func plus() {}
}

class Computer: Meth {
    override func plus() {}
    // override func plus(_ self: Computer) {}
}

class Phone: Meth {
    override func plus() {}
    // override func plus(_ self: Phone) {}
}

var meths: [Meth] = [Computer(), Phone()]
meths.forEach {
    $0.plus()
    // $0.type.vtable.draw($0)
}

/// meths 배열에는 meth를 상속받는 객체들이 담길 수 있고 Meth의 함수인 Plus도 모두 사용할 수 있음
/// meths 배열에는 Heap의 레퍼런스만 저장하기 때문에 각 인스턴스의 크기는 동일함
///
/// 컴파일러는 위 코드를 보고 어떤 Class의 Plus를 실행해야 하는지 알 수 없음
/// 컴파일러는 Class에 Type 필드를 추가해 Type에 대한 정보를 가지고 있음
/// - 이 정보는 Static Memory에 저장
///
/// forEach를 통해 plus()를 실행할 때 static Memory에 있는 virutal method table를 확인 후 맞는 구현을 실행함
/// class 함수도 자신의 타입을 식별할 수 있는 함수로 변경 후 $0.type.vtable.draw($0)로 실행됨

/// Class는 기본적으로 Dynamic Dispatch를 기반으로 동작함
/// - SubClass가 필요하지 않으면 final 키워드를 통해 상속을 막을 경우 컴파일러는 Static Dispatch로 작동함
/// - 또한 SubClass가 쓰이지 않는걸 Private 키워드 등을 통해 증명할 경우 Static Dispatch로 동작함
