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

    public init(lunar: Lunar) {
        sect = 2
        _lunar = lunar
    }

    public class func fromLunar(lunar: Lunar) -> EightChar {
        EightChar(lunar: lunar)
    }

    public var year: String {
        get {
            _lunar.yearInGanZhiExact
        }
    }

    public var yearGan: String {
        get {
            _lunar.yearGanExact
        }
    }

    public var yearZhi: String {
        get {
            _lunar.yearZhiExact
        }
    }

    public var yearHideGan: [String] {
        get {
            LunarUtil.ZHI_HIDE_GAN[yearZhi]!
        }
    }

    public var yearWuXing: String {
        get {
            LunarUtil.WU_XING_GAN[yearGan]! + LunarUtil.WU_XING_ZHI[yearZhi]!
        }
    }

    public var yearNaYin: String {
        get {
            LunarUtil.NAYIN[year]!
        }
    }

    public var month: String {
        get {
            _lunar.monthInGanZhiExact
        }
    }

    public var monthGan: String {
        get {
            _lunar.monthGanExact
        }
    }

    public var monthZhi: String {
        get {
            _lunar.monthZhiExact
        }
    }

    public var monthHideGan: [String] {
        get {
            LunarUtil.ZHI_HIDE_GAN[monthZhi]!
        }
    }

    public var monthWuXing: String {
        get {
            LunarUtil.WU_XING_GAN[monthGan]! + LunarUtil.WU_XING_ZHI[monthZhi]!
        }
    }

    public var monthNaYin: String {
        get {
            LunarUtil.NAYIN[month]!
        }
    }

    public var day: String {
        get {
            2 == sect ? lunar.dayInGanZhiExact2 : lunar.dayInGanZhiExact
        }
    }

    public var dayGan: String {
        get {
            2 == sect ? _lunar.dayGanExact2 : lunar.dayGanExact
        }
    }

    public var dayZhi: String {
        get {
            2 == sect ? _lunar.dayZhiExact2 : lunar.dayZhiExact
        }
    }

    public var dayHideGan: [String] {
        get {
            LunarUtil.ZHI_HIDE_GAN[dayZhi]!
        }
    }

    public var dayWuXing: String {
        get {
            LunarUtil.WU_XING_GAN[dayGan]! + LunarUtil.WU_XING_ZHI[dayZhi]!
        }
    }

    public var dayNaYin: String {
        get {
            LunarUtil.NAYIN[day]!
        }
    }

    public var time: String {
        get {
            _lunar.timeInGanZhi
        }
    }

    public var timeGan: String {
        get {
            _lunar.timeGan
        }
    }

    public var timeZhi: String {
        get {
            _lunar.timeZhi
        }
    }

    public var timeHideGan: [String] {
        get {
            LunarUtil.ZHI_HIDE_GAN[timeZhi]!
        }
    }

    public var timeWuXing: String {
        get {
            LunarUtil.WU_XING_GAN[timeGan]! + LunarUtil.WU_XING_ZHI[timeZhi]!
        }
    }

    public var timeNaYin: String {
        get {
            LunarUtil.NAYIN[time]!
        }
    }

    public func getYun(gender: Int, sect: Int = 1) -> Yun {
        Yun(eightChar: self, gender: gender, sect: sect)
    }

    public var yearXun: String {
        get {
            _lunar.yearXunExact
        }
    }

    public var yearXunKong: String {
        get {
            _lunar.yearXunKongExact
        }
    }

    public var monthXun: String {
        get {
            _lunar.monthXunExact
        }
    }

    public var monthXunKong: String {
        get {
            _lunar.monthXunKongExact
        }
    }

    public var dayXun: String {
        get {
            2 == sect ? _lunar.dayXunExact2 : _lunar.dayXunExact
        }
    }

    public var dayXunKong: String {
        get {
            2 == sect ? _lunar.dayXunKongExact2 : _lunar.dayXunKongExact
        }
    }

    public var timeXun: String {
        get {
            _lunar.timeXun
        }
    }

    public var timeXunKong: String {
        get {
            _lunar.timeXunKong
        }
    }

}
