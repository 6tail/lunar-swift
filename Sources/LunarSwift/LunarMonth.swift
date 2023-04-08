import Foundation

@objcMembers
public class LunarMonth: NSObject {
    private var _year: Int
    private var _month: Int
    private var _dayCount: Int
    private var _index: Int
    private var _zhiIndex: Int
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
    
    public var index: Int {
        get {
            _index
        }
    }
    
    public var zhiIndex: Int {
        get {
            _zhiIndex
        }
    }
    
    public var ganIndex: Int {
        get {
            let offset = (LunarYear(lunarYear: _year).ganIndex + 1) % 5 * 2
            return (_index - 1 + offset) % 10
        }
    }

    public var firstJulianDay: Double {
        get {
            _firstJulianDay
        }
    }

    public init(lunarYear: Int, lunarMonth: Int, dayCount: Int, firstJulianDay: Double, index: Int) {
        _year = lunarYear
        _month = lunarMonth
        _dayCount = dayCount
        _firstJulianDay = firstJulianDay
        _index = index
        _zhiIndex = (index - 1 + LunarUtil.BASE_MONTH_ZHI_INDEX) % 12
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
    
    public var gan: String {
        get {
            LunarUtil.GAN[ganIndex + 1]
        }
    }

    public var zhi: String {
        get {
            LunarUtil.ZHI[_zhiIndex + 1]
        }
    }

    public var ganZhi: String {
        get {
            "\(gan)\(zhi)"
        }
    }
    
    public var positionXi: String {
        get {
            LunarUtil.POSITION_XI[ganIndex + 1]
        }
    }

    public var positionXiDesc: String {
        get {
            LunarUtil.POSITION_DESC[positionXi]!
        }
    }

    public var positionYangGui: String {
        get {
            LunarUtil.POSITION_YANG_GUI[ganIndex + 1]
        }
    }

    public var positionYangGuiDesc: String {
        get {
            LunarUtil.POSITION_DESC[positionYangGui]!
        }
    }

    public var positionYinGui: String {
        get {
            LunarUtil.POSITION_YIN_GUI[ganIndex + 1]
        }
    }

    public var positionYinGuiDesc: String {
        get {
            LunarUtil.POSITION_DESC[positionYinGui]!
        }
    }

    public var positionFu: String {
        get {
            getPositionFu(sect: 2)
        }
    }

    public var positionFuDesc: String {
        get {
            getPositionFuDesc(sect: 2)
        }
    }

    public func getPositionFu(sect: Int) -> String {
        (1 == sect ? LunarUtil.POSITION_FU : LunarUtil.POSITION_FU_2)[ganIndex + 1]
    }

    public func getPositionFuDesc(sect: Int) -> String {
        LunarUtil.POSITION_DESC[getPositionFu(sect: sect)]!
    }

    public var positionCai: String {
        get {
            LunarUtil.POSITION_CAI[ganIndex + 1]
        }
    }

    public var positionCaiDesc: String {
        get {
            LunarUtil.POSITION_DESC[positionCai]!
        }
    }

}
