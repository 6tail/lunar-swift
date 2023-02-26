import Foundation

@objcMembers
public class EightChar: NSObject {
    public static var MONTH_ZHI: [String] = ["", "寅", "卯", "辰", "巳", "午", "未", "申", "酉", "戌", "亥", "子", "丑"]
    public static var CHANG_SHENG: [String] = ["长生", "沐浴", "冠带", "临官", "帝旺", "衰", "病", "死", "墓", "绝", "胎", "养"]

    public var sect: Int
    private var _lunar: Lunar

    public var lunar: Lunar {
        get {
            _lunar
        }
    }

    init(lunar: Lunar) {
        sect = 2
        _lunar = lunar
    }

}
