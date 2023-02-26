import Foundation

@objcMembers
public class Holiday: NSObject {
    private var _day: String
    private var _name: String
    private var _work: Bool
    private var _target: String

    public var day: String {
        get {
            _day
        }
    }

    public var name: String {
        get {
            _name
        }
    }

    public var work: Bool {
        get {
            _work
        }
    }

    public var target: String {
        get {
            _target
        }
    }

    init(day: String, name: String, work: Bool, target: String) {
        if !day.contains("-") {
            _day = day.prefix(4) + "-" + day[day.index(day.startIndex, offsetBy: 4)..<day.index(day.startIndex, offsetBy: 6)] + "-" + day.suffix(2)
        } else {
            _day = day
        }
        _name = name
        _work = work
        if !target.contains("-") {
            _target = target.prefix(4) + "-" + target[target.index(target.startIndex, offsetBy: 4)..<target.index(target.startIndex, offsetBy: 6)] + "-" + target.suffix(2)
        } else {
            _target = target
        }
    }

    public override var description: String {
        get {
            "\(_day) \(_name) \(_work ? "调休" : "") \(_target)"
        }
    }

}
