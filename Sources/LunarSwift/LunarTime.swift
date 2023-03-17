import Foundation

@objcMembers
public class LunarTime: NSObject {
    private var _ganIndex: Int
    private var _zhiIndex: Int
    private var _lunar: Lunar

    public var ganIndex: Int {
        get {
            _ganIndex
        }
    }

    public var zhiIndex: Int {
        get {
            _zhiIndex
        }
    }

    public var lunar: Lunar {
        get {
            _lunar
        }
    }

    public init(lunarYear: Int, lunarMonth: Int, lunarDay: Int, hour: Int = 0, minute: Int = 0, second: Int = 0) {
        _lunar = Lunar.fromYmdHms(lunarYear: lunarYear, lunarMonth: lunarMonth, lunarDay: lunarDay, hour: hour, minute: minute, second: second)
        _zhiIndex = LunarUtil.getTimeZhiIndex(hm: String(format:"%02d:%02d", hour, minute))
        _ganIndex = (_lunar.dayGanIndexExact % 5 * 2 + _zhiIndex) % 10
    }

    public class func fromYmdHms(lunarYear: Int, lunarMonth: Int, lunarDay: Int, hour: Int = 0, minute: Int = 0, second: Int = 0) -> LunarTime {
        LunarTime(lunarYear: lunarYear, lunarMonth: lunarMonth, lunarDay: lunarDay, hour: hour, minute: minute, second: second)
    }

    public var gan: String {
        get {
            LunarUtil.GAN[_ganIndex + 1]
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

    public var shengXiao: String {
        get {
            LunarUtil.SHENG_XIAO[_zhiIndex + 1]
        }
    }

    public var naYin: String {
        get {
            LunarUtil.NAYIN[ganZhi]!
        }
    }

    public var positionXi: String {
        get {
            LunarUtil.POSITION_XI[_ganIndex + 1]
        }
    }

    public var positionXiDesc: String {
        get {
            LunarUtil.POSITION_DESC[positionXi]!
        }
    }

    public var positionYangGui: String {
        get {
            LunarUtil.POSITION_YANG_GUI[_ganIndex + 1]
        }
    }

    public var positionYangGuiDesc: String {
        get {
            LunarUtil.POSITION_DESC[positionYangGui]!
        }
    }

    public var positionYinGui: String {
        get {
            LunarUtil.POSITION_YIN_GUI[_ganIndex + 1]
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
        (1 == sect ? LunarUtil.POSITION_FU : LunarUtil.POSITION_FU_2)[_ganIndex + 1]
    }

    public func getPositionFuDesc(sect: Int) -> String {
        LunarUtil.POSITION_DESC[getPositionFu(sect: sect)]!
    }

    public var positionCai: String {
        get {
            LunarUtil.POSITION_CAI[_ganIndex + 1]
        }
    }

    public var positionCaiDesc: String {
        get {
            LunarUtil.POSITION_DESC[positionCai]!
        }
    }

    public var tianShen: String {
        get {
            LunarUtil.TIAN_SHEN[(_zhiIndex + LunarUtil.ZHI_TIAN_SHEN_OFFSET[_lunar.dayZhiExact]!) % 12 + 1]
        }
    }

    public var tianShenType: String {
        get {
            LunarUtil.TIAN_SHEN_TYPE[tianShen]!
        }
    }

    public var tianShenLuck: String {
        get {
            LunarUtil.TIAN_SHEN_TYPE_LUCK[tianShenType]!
        }
    }

    public var yi: [String] {
        get {
            LunarUtil.getTimeYi(dayGanZhi: _lunar.dayInGanZhiExact, timeGanZhi: ganZhi)
        }
    }

    public var ji: [String] {
        get {
            LunarUtil.getTimeJi(dayGanZhi: _lunar.dayInGanZhiExact, timeGanZhi: ganZhi)
        }
    }

    public var chong: String {
        get {
            LunarUtil.CHONG[_zhiIndex]
        }
    }

    public var sha: String {
        get {
            LunarUtil.SHA[zhi]!
        }
    }

    public var chongShengXiao: String {
        get {
            for i in (0..<LunarUtil.ZHI.count) {
                if LunarUtil.ZHI[i] == chong {
                    return LunarUtil.SHENG_XIAO[i]
                }
            }
            return ""
        }
    }

    public var chongGan: String {
        get {
            LunarUtil.CHONG_GAN[_ganIndex]
        }
    }

    public var chongGanTie: String {
        get {
            LunarUtil.CHONG_GAN_TIE[_ganIndex]
        }
    }

    public var chongDesc: String {
        get {
            "(\(chongGan)\(chong))\(chongShengXiao)"
        }
    }

    public override var description: String {
        get {
            "\(ganZhi)"
        }
    }

    public var xun: String {
        get {
            LunarUtil.getXun(ganZhi: ganZhi)
        }
    }

    public var xunKong: String {
        get {
            LunarUtil.getXunKong(ganZhi: ganZhi)
        }
    }

    public var minHm: String {
        get {
            let hour = lunar.hour
            if hour < 1 {
                return "00:00"
            } else if hour > 22 {
                return "23:00"
            }
            return String(format:"%02d:00", hour % 2 == 0 ? hour - 1 : hour)
        }
    }

    public var maxHm: String {
        get {
            let hour = lunar.hour
            if hour < 1 {
                return "00:59"
            } else if hour > 22 {
                return "23:59"
            }
            return String(format:"%02d:59", hour % 2 == 0 ? hour : hour + 1)
        }
    }

}
