import Foundation

@objcMembers
public class ShuJiu: NSObject {
    private var _name: String
    private var _index: Int

    public var name: String {
        get {
            _name
        }
    }

    public var index: Int {
        get {
            _index
        }
    }

    init(name: String, index: Int) {
        _name = name
        _index = index
    }

    public override var description: String {
        get {
            "\(_name)第\(_index)天"
        }
    }

}
