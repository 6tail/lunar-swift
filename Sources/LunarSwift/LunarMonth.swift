import Foundation

@objcMembers
public class LunarMonth: NSObject {
    private var _year: Int
    private var _month: Int
    private var _dayCount: Int
    private var _firstJulianDay: Double

    public var year: Int {
        get {
            _year
        }
    }

    public var month: Int {
        get {
            _month
        }
    }

    public var dayCount: Int {
        get {
            _dayCount
        }
    }

    public var firstJulianDay: Double {
        get {
            _firstJulianDay
        }
    }

    public init(lunarYear: Int, lunarMonth: Int, dayCount: Int, firstJulianDay: Double) {
        _year = lunarYear
        _month = lunarMonth
        _dayCount = dayCount
        _firstJulianDay = firstJulianDay
    }

    public class func fromYm(lunarYear: Int, lunarMonth: Int) -> LunarMonth? {
        LunarYear(lunarYear: lunarYear).getMonth(lunarMonth: lunarMonth)
    }

    public var leap: Bool {
        get {
            _month < 0
        }
    }

    public override var description: String {
        get {
            var r = ""
            if leap {
                r = "闰"
            }
            let m = abs(_month)
            return "\(_year)年\(r)\(LunarUtil.MONTH[m])月(\(_dayCount))天"
        }
    }

}
