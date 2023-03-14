import Foundation

@objcMembers
public class LunarYear: NSObject {
    public static var YUAN: [String] = ["下", "上", "中"]
    public static var YUN: [String] = ["七", "八", "九", "一", "二", "三", "四", "五", "六"]
    private static var LEAP_11: [Int] = [75, 94, 170, 238, 265, 322, 389, 469, 553, 583, 610, 678, 735, 754, 773, 849, 887, 936, 1050, 1069, 1126, 1145, 1164, 1183, 1259, 1278, 1308, 1373, 1403, 1441, 1460, 1498, 1555, 1593, 1612, 1631, 1642, 2033, 2128, 2147, 2242, 2614, 2728, 2910, 3062, 3244, 3339, 3616, 3711, 3730, 3825, 4007, 4159, 4197, 4322, 4341, 4379, 4417, 4531, 4599, 4694, 4713, 4789, 4808, 4971, 5085, 5104, 5161, 5180, 5199, 5294, 5305, 5476, 5677, 5696, 5772, 5791, 5848, 5886, 6049, 6068, 6144, 6163, 6258, 6402, 6440, 6497, 6516, 6630, 6641, 6660, 6679, 6736, 6774, 6850, 6869, 6899, 6918, 6994, 7013, 7032, 7051, 7070, 7089, 7108, 7127, 7146, 7222, 7271, 7290, 7309, 7366, 7385, 7404, 7442, 7461, 7480, 7491, 7499, 7594, 7624, 7643, 7662, 7681, 7719, 7738, 7814, 7863, 7882, 7901, 7939, 7958, 7977, 7996, 8034, 8053, 8072, 8091, 8121, 8159, 8186, 8216, 8235, 8254, 8273, 8311, 8330, 8341, 8349, 8368, 8444, 8463, 8474, 8493, 8531, 8569, 8588, 8626, 8664, 8683, 8694, 8702, 8713, 8721, 8751, 8789, 8808, 8816, 8827, 8846, 8884, 8903, 8922, 8941, 8971, 9036, 9066, 9085, 9104, 9123, 9142, 9161, 9180, 9199, 9218, 9256, 9294, 9313, 9324, 9343, 9362, 9381, 9419, 9438, 9476, 9514, 9533, 9544, 9552, 9563, 9571, 9582, 9601, 9639, 9658, 9666, 9677, 9696, 9734, 9753, 9772, 9791, 9802, 9821, 9886, 9897, 9916, 9935, 9954, 9973, 9992]
    private static var LEAP_12: [Int] = [37, 56, 113, 132, 151, 189, 208, 227, 246, 284, 303, 341, 360, 379, 417, 436, 458, 477, 496, 515, 534, 572, 591, 629, 648, 667, 697, 716, 792, 811, 830, 868, 906, 925, 944, 963, 982, 1001, 1020, 1039, 1058, 1088, 1153, 1202, 1221, 1240, 1297, 1335, 1392, 1411, 1422, 1430, 1517, 1525, 1536, 1574, 3358, 3472, 3806, 3988, 4751, 4941, 5066, 5123, 5275, 5343, 5438, 5457, 5495, 5533, 5552, 5715, 5810, 5829, 5905, 5924, 6421, 6535, 6793, 6812, 6888, 6907, 7002, 7184, 7260, 7279, 7374, 7556, 7746, 7757, 7776, 7833, 7852, 7871, 7966, 8015, 8110, 8129, 8148, 8224, 8243, 8338, 8406, 8425, 8482, 8501, 8520, 8558, 8596, 8607, 8615, 8645, 8740, 8778, 8835, 8865, 8930, 8960, 8979, 8998, 9017, 9055, 9074, 9093, 9112, 9150, 9188, 9237, 9275, 9332, 9351, 9370, 9408, 9427, 9446, 9457, 9465, 9495, 9560, 9590, 9628, 9647, 9685, 9715, 9742, 9780, 9810, 9818, 9829, 9848, 9867, 9905, 9924, 9943, 9962, 10000]
    private static var LEAP: [Int: Int] = {
        var leap: [Int: Int] = [:]
        for y in LEAP_11 {
            leap[y] = 13
        }
        for y in LEAP_12 {
            leap[y] = 14
        }
        return leap
    }()
    private static var CACHE: [Int: LunarYear] = [:]

    private var _year: Int
    private var _ganIndex: Int
    private var _zhiIndex: Int
    private var _months: [LunarMonth]
    private var _jieQiJulianDays: [Double]

    public var year: Int {
        get {
            _year
        }
    }

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

    public var months: [LunarMonth] {
        get {
            _months
        }
    }

    public var monthsInYear: [LunarMonth] {
        get {
            var l: [LunarMonth] = []
            for m in _months {
                if m.year == _year {
                    l.append(m)
                }
            }
            return l
        }
    }

    public var dayCount: Int {
        get {
            var n = 0
            for m in _months {
                if m.year == _year {
                    n += m.dayCount
                }
            }
            return n
        }
    }

    public var jieQiJulianDays: [Double] {
        get {
            _jieQiJulianDays
        }
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

    public init(lunarYear: Int) {
        _year = lunarYear
        _months = [LunarMonth]()
        let offset = lunarYear - 4
        var yearGanIndex = offset % 10
        var yearZhiIndex = offset % 12
        if yearGanIndex < 0 {
            yearGanIndex += 10
        }
        if yearZhiIndex < 0 {
            yearZhiIndex += 12
        }
        _ganIndex = yearGanIndex
        _zhiIndex = yearZhiIndex
        // 节气(中午12点)，长度27
        var jq = [Double]()
        // 合朔，即每月初一(中午12点)，长度16
        var hs = [Double]()
        // 每月天数，长度15
        var dayCounts = [Int]()

        let currentYear = _year
        let year = currentYear - 2000

        // 从上年的大雪到下年的立春
        _jieQiJulianDays = [Double]()
        for i in 0..<Lunar.JIE_QI_IN_USE.count {
            // 精确的节气
            var t = 36525 * ShouXingUtil.saLonT(w: (Double(year)+Double(17+i)*15/360)*ShouXingUtil.PI_2)
            t += ShouXingUtil.ONE_THIRD - ShouXingUtil.dtT(t: t)
            _jieQiJulianDays.append(t + Solar.J2000)
            // 按中午12点算的节气
            if i > 0 && i < 28 {
                jq.append(round(t))
            }
        }

        // 冬至前的初一
        var w = ShouXingUtil.calcShuo(pjd: jq[0])
        if w > jq[0] {
            if currentYear != 41 && currentYear != 193 && currentYear != 288 && currentYear != 345 && currentYear != 918 && currentYear != 1013
            {
                w -= 29.5306
            }
        }
        // 递推每月初一
        for i in (0..<16) {
            hs.append(ShouXingUtil.calcShuo(pjd: w + 29.5306*Double(i)))
        }
        // 每月天数
        for i in (0..<15) {
            dayCounts.append(Int(hs[i+1] - hs[i]))
        }

        let prevYear = currentYear - 1
        var leapYear = -1
        var leapIndex = -1

        var leap = LunarYear.LEAP[currentYear]
        if nil == leap
        {
            leap = LunarYear.LEAP[prevYear]
            if nil == leap
            {
                if hs[13] <= jq[24] {
                    var i = 1
                    while hs[i + 1] > jq[2 * i] && i < 13 {
                        i += 1
                    }
                    leapYear = currentYear
                    leapIndex = i
                }
            } else {
                leapYear = prevYear
                leapIndex = leap! - 12
            }
        } else {
            leapYear = currentYear
            leapIndex = leap!
        }

        var y = prevYear
        var m = 11
        for i in (0..<15) {
            var cm = m
            if y == leapYear && i == leapIndex {
                cm = -cm
            }
            _months.append(LunarMonth(lunarYear: y, lunarMonth: cm, dayCount: dayCounts[i], firstJulianDay: hs[i] + Solar.J2000))
            if y != leapYear || i + 1 != leapIndex {
                m += 1
            }
            if m == 13 {
                m = 1
                y += 1
            }
        }
    }

    public class func fromYear(lunarYear: Int) -> LunarYear {
        var y = LunarYear.CACHE[lunarYear]
        if nil == y {
            y = LunarYear(lunarYear: lunarYear)
            LunarYear.CACHE[lunarYear] = y
        }
        return y!
    }

    public func getMonth(lunarMonth: Int) -> LunarMonth? {
        for m in _months {
            if m.year == _year && m.month == lunarMonth {
                return m
            }
        }
        return nil
    }

    public override var description: String {
        get {
            "\(_year)"
        }
    }

    public var fullString: String {
        get {
            "\(year)年"
        }
    }

}
