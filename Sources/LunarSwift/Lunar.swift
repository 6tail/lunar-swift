import Foundation

@objcMembers
public class Lunar: NSObject {
    public static var JIE_QI: [String] = ["冬至", "小寒", "大寒", "立春", "雨水", "惊蛰", "春分", "清明", "谷雨", "立夏", "小满", "芒种", "夏至", "小暑", "大暑", "立秋", "处暑", "白露", "秋分", "寒露", "霜降", "立冬", "小雪", "大雪"]
    public static var JIE_QI_IN_USE: [String] = ["DA_XUE", "冬至", "小寒", "大寒", "立春", "雨水", "惊蛰", "春分", "清明", "谷雨", "立夏", "小满", "芒种", "夏至", "小暑", "大暑", "立秋", "处暑", "白露", "秋分", "寒露", "霜降", "立冬", "小雪", "大雪", "DONG_ZHI", "XIAO_HAN", "DA_HAN", "LI_CHUN", "YU_SHUI", "JING_ZHE"]

    private var _year: Int
    private var _month: Int
    private var _day: Int
    private var _hour: Int
    private var _minute: Int
    private var _second: Int
    private var _yearGanIndex: Int
    private var _yearZhiIndex: Int
    private var _yearGanIndexByLiChun: Int
    private var _yearZhiIndexByLiChun: Int
    private var _yearGanIndexExact: Int
    private var _yearZhiIndexExact: Int
    private var _monthGanIndex: Int
    private var _monthZhiIndex: Int
    private var _monthGanIndexExact: Int
    private var _monthZhiIndexExact: Int
    private var _dayGanIndex: Int
    private var _dayZhiIndex: Int
    private var _dayGanIndexExact: Int
    private var _dayZhiIndexExact: Int
    private var _dayGanIndexExact2: Int
    private var _dayZhiIndexExact2: Int
    private var _timeGanIndex: Int
    private var _timeZhiIndex: Int
    private var _weekIndex: Int
    private var _jieQi: [String: Solar]
    private var _solar: Solar
    private var _eightChar: EightChar?

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

    public var day: Int {
        get {
            _day
        }
    }

    public var hour: Int {
        get {
            _hour
        }
    }

    public var minute: Int {
        get {
            _minute
        }
    }

    public var second: Int {
        get {
            _second
        }
    }

    public var yearGanIndex: Int {
        get {
            _yearGanIndex
        }
    }

    public var yearZhiIndex: Int {
        get {
            _yearZhiIndex
        }
    }

    public var yearGanIndexByLiChun: Int {
        get {
            _yearGanIndexByLiChun
        }
    }

    public var yearZhiIndexByLiChun: Int {
        get {
            _yearZhiIndexByLiChun
        }
    }

    public var yearGanIndexExact: Int {
        get {
            _yearGanIndexExact
        }
    }

    public var yearZhiIndexExact: Int {
        get {
            _yearZhiIndexExact
        }
    }

    public var monthGanIndex: Int {
        get {
            _monthGanIndex
        }
    }

    public var monthZhiIndex: Int {
        get {
            _monthZhiIndex
        }
    }

    public var monthGanIndexExact: Int {
        get {
            _monthGanIndexExact
        }
    }

    public var monthZhiIndexExact: Int {
        get {
            _monthZhiIndexExact
        }
    }

    public var dayGanIndex: Int {
        get {
            _dayGanIndex
        }
    }

    public var dayZhiIndex: Int {
        get {
            _dayZhiIndex
        }
    }

    public var dayGanIndexExact: Int {
        get {
            _dayGanIndexExact
        }
    }

    public var dayZhiIndexExact: Int {
        get {
            _dayZhiIndexExact
        }
    }

    public var dayGanIndexExact2: Int {
        get {
            _dayGanIndexExact2
        }
    }

    public var dayZhiIndexExact2: Int {
        get {
            _dayZhiIndexExact2
        }
    }

    public var timeGanIndex: Int {
        get {
            _timeGanIndex
        }
    }

    public var timeZhiIndex: Int {
        get {
            _timeZhiIndex
        }
    }

    public var weekIndex: Int {
        get {
            _weekIndex
        }
    }

    public var solar: Solar {
        get {
            _solar
        }
    }

    public init(lunarYear: Int, lunarMonth: Int, lunarDay: Int, hour: Int = 0, minute: Int = 0, second: Int = 0) {
        var y = LunarYear(lunarYear: lunarYear)
        let m = y.getMonth(lunarMonth: lunarMonth)
        if nil == m {
            fatalError("wrong lunar year \(lunarYear) month \(lunarMonth)")
        }
        if lunarDay < 1 {
            fatalError("lunar day must bigger than 0")
        }
        let days = m!.dayCount
        if lunarDay > days {
            fatalError("only \(days) days in lunar year \(lunarYear) month \(lunarMonth)")
        }
        _year = lunarYear
        _month = lunarMonth
        _day = lunarDay
        _hour = hour
        _minute = minute
        _second = second
        var noon = Solar.fromJulianDay(julianDay: m!.firstJulianDay + Double(lunarDay - 1))
        _solar = Solar.fromYmdHms(year: noon.year, month: noon.month, day: noon.day, hour: hour, minute: minute, second: second)
        if noon.year != lunarYear {
            y = LunarYear(lunarYear: noon.year)
        }

        let julianDays = y.jieQiJulianDays
        var table = [String: Solar]()
        for i in (0..<Lunar.JIE_QI_IN_USE.count) {
            table[Lunar.JIE_QI_IN_USE[i]] = Solar.fromJulianDay(julianDay: julianDays[i])
        }
        _jieQi = table

        //以正月初一开始
        var offset = _year - 4
        _yearGanIndex = offset % 10
        _yearZhiIndex = offset % 12

        if _yearGanIndex < 0 {
            _yearGanIndex += 10
        }

        if _yearZhiIndex < 0 {
            _yearZhiIndex += 12
        }

        //以立春作为新一年的开始的干支纪年
        var g = _yearGanIndex
        var z = _yearZhiIndex

        //精确的干支纪年，以立春交接时刻为准
        var gExact = _yearGanIndex
        var zExact = _yearZhiIndex

        let solarYear = _solar.year
        let solarYmd = _solar.ymd
        let solarYmdHms = _solar.ymdhms

        //获取立春的阳历时刻
        var liChun = _jieQi["立春"]!
        if liChun.year != solarYear {
            liChun = _jieQi["LI_CHUN"]!
        }
        let liChunYmd = liChun.ymd
        let liChunYmdHms = liChun.ymdhms

        //阳历和阴历年份相同代表正月初一及以后
        if _year == solarYear {
            //立春日期判断
            if solarYmd < liChunYmd {
                g -= 1
                z -= 1
            }
            //立春交接时刻判断
            if solarYmdHms < liChunYmdHms {
                gExact -= 1
                zExact -= 1
            }
        } else if _year < solarYear {
            if solarYmd >= liChunYmd {
                g += 1
                z += 1
            }
            if solarYmdHms >= liChunYmdHms {
                gExact += 1
                zExact += 1
            }
        }

        if g < 0 {
            g += 10
        }
        if z < 0 {
            z += 12
        }
        if gExact < 0 {
            gExact += 10
        }
        if zExact < 0 {
            zExact += 12
        }

        _yearGanIndexByLiChun = g % 10
        _yearZhiIndexByLiChun = z % 12

        _yearGanIndexExact = gExact % 10
        _yearZhiIndexExact = zExact % 12

        var start: Solar?
        var end: Solar

        let size = Lunar.JIE_QI_IN_USE.count
        //序号：大雪以前-3，大雪到小寒之间-2，小寒到立春之间-1，立春之后0
        var index = -3
        for i in stride(from: 0, to: size, by: 2) {
            let jie = Lunar.JIE_QI_IN_USE[i]
            end = _jieQi[jie]!
            var symd = solarYmd
            if start != nil {
                symd = start!.ymd
            }
            if solarYmd >= symd && solarYmd < end.ymd {
                break
            }
            start = end
            index += 1
        }
        var add = 0
        if index < 0 {
            add = 1
        }

        offset = (((_yearGanIndexByLiChun+add)%5 + 1) * 2) % 10
        add = index
        if add < 0 {
            add += 10
        }
        _monthGanIndex = (add + offset) % 10
        add = index
        if add < 0 {
            add += 12
        }
        _monthZhiIndex = (add + LunarUtil.BASE_MONTH_ZHI_INDEX) % 12

        start = nil
        index = -3
        for i in stride(from: 0, to: size, by: 2) {
            let jie = Lunar.JIE_QI_IN_USE[i]
            end = _jieQi[jie]!
            var stime = solarYmdHms
            if start != nil {
                stime = start!.ymdhms
            }
            if solarYmdHms >= stime && solarYmdHms < end.ymdhms {
                break
            }
            start = end
            index += 1
        }

        add = 0
        if index < 0 {
            add = 1
        }

        offset = (((_yearGanIndexExact+add)%5 + 1) * 2) % 10
        add = index
        if add < 0 {
            add += 10
        }
        _monthGanIndexExact = (add + offset) % 10
        add = index
        if add < 0 {
            add += 12
        }
        _monthZhiIndexExact = (add + LunarUtil.BASE_MONTH_ZHI_INDEX) % 12

        noon = Solar.fromYmdHms(year: _solar.year, month: _solar.month, day: _solar.day, hour: 12, minute: 0, second: 0)
        offset = Int(noon.julianDay - 11)
        _dayGanIndex = offset % 10
        _dayZhiIndex = offset % 12

        var dayGanExact = _dayGanIndex
        var dayZhiExact = _dayZhiIndex

        _dayGanIndexExact2 = dayGanExact
        _dayZhiIndexExact2 = dayZhiExact

        let hm = String(format: "%02d:%02d", _hour, _minute)
        if hm >= "23:00" && hm <= "23:59" {
            dayGanExact += 1
            if dayGanExact >= 10 {
                dayGanExact -= 10
            }
            dayZhiExact += 1
            if dayZhiExact >= 12 {
                dayZhiExact -= 12
            }
        }

        _dayGanIndexExact = dayGanExact
        _dayZhiIndexExact = dayZhiExact

        _timeZhiIndex = LunarUtil.getTimeZhiIndex(hm: hm)
        _timeGanIndex = (_dayGanIndexExact%5*2 + _timeZhiIndex) % 10
        _weekIndex = _solar.week
    }

    public class func fromYmdHms(lunarYear: Int, lunarMonth: Int, lunarDay: Int, hour: Int = 0, minute: Int = 0, second: Int = 0) -> Lunar {
        Lunar(lunarYear: lunarYear, lunarMonth: lunarMonth, lunarDay: lunarDay, hour: hour, minute: minute, second: second)
    }

    public class func fromSolar(solar: Solar) -> Lunar {
        var lunarYear = 0
        var lunarMonth = 0
        var lunarDay = 0
        let ly = LunarYear(lunarYear: solar.year)
        for m in ly.months {
            let days = solar.subtract(solar: Solar.fromJulianDay(julianDay: m.firstJulianDay))
            if days < m.dayCount {
                lunarYear = m.year
                lunarMonth = m.month
                lunarDay = days + 1
                break
            }
        }
        return Lunar(lunarYear: lunarYear, lunarMonth: lunarMonth, lunarDay: lunarDay, hour: solar.hour, minute: solar.minute, second: solar.second)
    }

    public class func fromDate(date: Date) -> Lunar {
        fromSolar(solar: Solar.fromDate(date: date))
    }

    public var yearInChinese: String {
        get {
            let y = "\(_year)"
            var s = ""
            for i in (0..<y.count) {
                s += LunarUtil.NUMBER[Int(y[y.index(y.startIndex, offsetBy: i)].asciiValue!) - 48]
            }
            return s
        }
    }

    public var monthInChinese: String {
        get {
            var s = ""
            if _month < 0 {
                s += "闰"
            }
            s += LunarUtil.MONTH[abs(_month)]
            return s
        }
    }

    public var dayInChinese: String {
        get {
            LunarUtil.DAY[_day]
        }
    }

    public var yearGan: String {
        get {
            LunarUtil.GAN[_yearGanIndex + 1]
        }
    }

    public var yearGanExact: String {
        get {
            LunarUtil.GAN[_yearGanIndexExact + 1]
        }
    }

    public var yearGanByLiChun: String {
        get {
            LunarUtil.GAN[_yearGanIndexByLiChun + 1]
        }
    }

    public var yearZhi: String {
        get {
            LunarUtil.ZHI[_yearZhiIndex + 1]
        }
    }

    public var yearZhiExact: String {
        get {
            LunarUtil.ZHI[_yearZhiIndexExact + 1]
        }
    }

    public var yearZhiByLiChun: String {
        get {
            LunarUtil.ZHI[_yearZhiIndexByLiChun + 1]
        }
    }

    public var yearInGanZhi: String {
        get {
            "\(yearGan)\(yearZhi)"
        }
    }

    public var yearInGanZhiExact: String {
        get {
            "\(yearGanExact)\(yearZhiExact)"
        }
    }

    public var yearInGanZhiByLiChun: String {
        get {
            "\(yearGanByLiChun)\(yearZhiByLiChun)"
        }
    }

    public var yearShengXiao: String {
        get {
            LunarUtil.SHENG_XIAO[_yearZhiIndex + 1]
        }
    }

    public var yearShengXiaoByLiChun: String {
        get {
            LunarUtil.SHENG_XIAO[_yearZhiIndexByLiChun + 1]
        }
    }

    public var yearShengXiaoExact: String {
        get {
            LunarUtil.SHENG_XIAO[_yearZhiIndexExact + 1]
        }
    }

    public var monthGan: String {
        get {
            LunarUtil.GAN[_monthGanIndex + 1]
        }
    }

    public var monthZhi: String {
        get {
            LunarUtil.ZHI[_monthZhiIndex + 1]
        }
    }

    public var monthInGanZhi: String {
        get {
            "\(monthGan)\(monthZhi)"
        }
    }

    public var monthGanExact: String {
        get {
            LunarUtil.GAN[_monthGanIndexExact + 1]
        }
    }

    public var monthZhiExact: String {
        get {
            LunarUtil.ZHI[_monthZhiIndexExact + 1]
        }
    }

    public var monthInGanZhiExact: String {
        get {
            "\(monthGanExact)\(monthZhiExact)"
        }
    }

    public var monthShengXiao: String {
        get {
            LunarUtil.SHENG_XIAO[_monthZhiIndex + 1]
        }
    }

    public var dayGan: String {
        get {
            LunarUtil.GAN[_dayGanIndex + 1]
        }
    }

    public var dayGanExact: String {
        get {
            LunarUtil.GAN[_dayGanIndexExact + 1]
        }
    }

    public var dayGanExact2: String {
        get {
            LunarUtil.GAN[_dayGanIndexExact2 + 1]
        }
    }

    public var dayZhi: String {
        get {
            LunarUtil.ZHI[_dayZhiIndex + 1]
        }
    }

    public var dayZhiExact: String {
        get {
            LunarUtil.ZHI[_dayZhiIndexExact + 1]
        }
    }

    public var dayZhiExact2: String {
        get {
            LunarUtil.ZHI[_dayZhiIndexExact2 + 1]
        }
    }

    public var dayInGanZhi: String {
        get {
            "\(dayGan)\(dayZhi)"
        }
    }

    public var dayInGanZhiExact: String {
        get {
            "\(dayGanExact)\(dayZhiExact)"
        }
    }

    public var dayInGanZhiExact2: String {
        get {
            "\(dayGanExact2)\(dayZhiExact2)"
        }
    }

    public var dayShengXiao: String {
        get {
            LunarUtil.SHENG_XIAO[_dayZhiIndex + 1]
        }
    }

    public var timeGan: String {
        get {
            LunarUtil.GAN[_timeGanIndex + 1]
        }
    }

    public var timeZhi: String {
        get {
            LunarUtil.ZHI[_timeZhiIndex + 1]
        }
    }

    public var timeInGanZhi: String {
        get {
            "\(timeGan)\(timeZhi)"
        }
    }

    public var timeShengXiao: String {
        get {
            LunarUtil.SHENG_XIAO[_timeZhiIndex + 1]
        }
    }

    public var yearNaYin: String {
        get {
            LunarUtil.NAYIN[yearInGanZhi]!
        }
    }

    public var monthNaYin: String {
        get {
            LunarUtil.NAYIN[monthInGanZhi]!
        }
    }

    public var dayNaYin: String {
        get {
            LunarUtil.NAYIN[dayInGanZhi]!
        }
    }

    public var timeNaYin: String {
        get {
            LunarUtil.NAYIN[timeInGanZhi]!
        }
    }

    public var week: Int {
        get {
            _solar.week
        }
    }

    public var weekInChinese: String {
        get {
            SolarUtil.WEEK[week]
        }
    }

    public var season: String {
        get {
            LunarUtil.SEASON[abs(_month)]
        }
    }

    public var xiu: String {
        get {
            LunarUtil.XIU["\(dayZhi)\(week)"]!
        }
    }

    public var xiuLuck: String {
        get {
            LunarUtil.XIU_LUCK[xiu]!
        }
    }

    public var xiuSong: String {
        get {
            LunarUtil.XIU_SONG[xiu]!
        }
    }

    public var zheng: String {
        get {
            LunarUtil.ZHENG[xiu]!
        }
    }

    public var animal: String {
        get {
            LunarUtil.ANIMAL[xiu]!
        }
    }

    public var gong: String {
        get {
            LunarUtil.GONG[xiu]!
        }
    }

    public var shou: String {
        get {
            LunarUtil.SHOU[gong]!
        }
    }

    public var pengZuGan: String {
        get {
            LunarUtil.PENGZU_GAN[_dayGanIndex + 1]
        }
    }

    public var pengZuZhi: String {
        get {
            LunarUtil.PENGZU_ZHI[_dayZhiIndex + 1]
        }
    }

    public var dayPositionXi: String {
        get {
            LunarUtil.POSITION_XI[_dayGanIndex + 1]
        }
    }

    public var dayPositionXiDesc: String {
        get {
            LunarUtil.POSITION_DESC[dayPositionXi]!
        }
    }

    public var dayPositionYangGui: String {
        get {
            LunarUtil.POSITION_YANG_GUI[_dayGanIndex + 1]
        }
    }

    public var dayPositionYangGuiDesc: String {
        get {
            LunarUtil.POSITION_DESC[dayPositionYangGui]!
        }
    }

    public var dayPositionYinGui: String {
        get {
            LunarUtil.POSITION_YIN_GUI[_dayGanIndex + 1]
        }
    }

    public var dayPositionYinGuiDesc: String {
        get {
            LunarUtil.POSITION_DESC[dayPositionYinGui]!
        }
    }

    public var dayPositionFu: String {
        get {
            getDayPositionFu(sect: 2)
        }
    }

    public var dayPositionFuDesc: String {
        get {
            getDayPositionFuDesc(sect: 2)
        }
    }

    public func getDayPositionFu(sect: Int) -> String {
        (1 == sect ? LunarUtil.POSITION_FU : LunarUtil.POSITION_FU_2)[_dayGanIndex + 1]
    }

    public func getDayPositionFuDesc(sect: Int) -> String {
        LunarUtil.POSITION_DESC[getDayPositionFu(sect: sect)]!
    }

    public var dayPositionCai: String {
        get {
            LunarUtil.POSITION_CAI[_dayGanIndex + 1]
        }
    }

    public var dayPositionCaiDesc: String {
        get {
            LunarUtil.POSITION_DESC[dayPositionCai]!
        }
    }

    public var timePositionXi: String {
        get {
            LunarUtil.POSITION_XI[_timeGanIndex + 1]
        }
    }

    public var timePositionXiDesc: String {
        get {
            LunarUtil.POSITION_DESC[timePositionXi]!
        }
    }

    public var timePositionYangGui: String {
        get {
            LunarUtil.POSITION_YANG_GUI[_timeGanIndex + 1]
        }
    }

    public var timePositionYangGuiDesc: String {
        get {
            LunarUtil.POSITION_DESC[timePositionYangGui]!
        }
    }

    public var timePositionYinGui: String {
        get {
            LunarUtil.POSITION_YIN_GUI[_timeGanIndex + 1]
        }
    }

    public var timePositionYinGuiDesc: String {
        get {
            LunarUtil.POSITION_DESC[timePositionYinGui]!
        }
    }

    public var timePositionFu: String {
        get {
            getTimePositionFu(sect: 2)
        }
    }

    public var timePositionFuDesc: String {
        get {
            getTimePositionFuDesc(sect: 2)
        }
    }

    public func getTimePositionFu(sect: Int) -> String {
        (1 == sect ? LunarUtil.POSITION_FU : LunarUtil.POSITION_FU_2)[_timeGanIndex + 1]
    }

    public func getTimePositionFuDesc(sect: Int) -> String {
        LunarUtil.POSITION_DESC[getTimePositionFu(sect: sect)]!
    }

    public var timePositionCai: String {
        get {
            LunarUtil.POSITION_CAI[_timeGanIndex + 1]
        }
    }

    public var timePositionCaiDesc: String {
        get {
            LunarUtil.POSITION_DESC[timePositionCai]!
        }
    }

    public var zhiXing: String {
        get {
            var offset = _dayZhiIndex - _monthZhiIndex
            if offset < 0 {
                offset += 12
            }
            return LunarUtil.ZHI_XING[offset + 1]
        }
    }

    public var dayTianShen: String {
        get {
            LunarUtil.TIAN_SHEN[(_dayZhiIndex + LunarUtil.ZHI_TIAN_SHEN_OFFSET[monthZhi]!) % 12 + 1]
        }
    }

    public var dayTianShenType: String {
        get {
            LunarUtil.TIAN_SHEN_TYPE[dayTianShen]!
        }
    }

    public var dayTianShenLuck: String {
        get {
            LunarUtil.TIAN_SHEN_TYPE_LUCK[dayTianShenType]!
        }
    }

    public var timeTianShen: String {
        get {
            LunarUtil.TIAN_SHEN[(_timeZhiIndex + LunarUtil.ZHI_TIAN_SHEN_OFFSET[dayZhiExact]!) % 12 + 1]
        }
    }

    public var timeTianShenType: String {
        get {
            LunarUtil.TIAN_SHEN_TYPE[timeTianShen]!
        }
    }

    public var timeTianShenLuck: String {
        get {
            LunarUtil.TIAN_SHEN_TYPE_LUCK[timeTianShenType]!
        }
    }

    public var monthPositionTai: String {
        get {
            if _month < 0 {
                return "";
            }
            return LunarUtil.POSITION_TAI_MONTH[_month - 1]
        }
    }

    public var dayPositionTai: String {
        get {
            LunarUtil.POSITION_TAI_DAY[LunarUtil.getJiaZiIndex(ganZhi: dayInGanZhi)]
        }
    }

    public var dayYi: [String] {
        get {
            getDayYi(sect:1)
        }
    }

    public func getDayYi(sect: Int) -> [String] {
        LunarUtil.getDayYi(monthGanZhi: 2 == sect ? monthInGanZhiExact : monthInGanZhi, dayGanZhi: dayInGanZhi)
    }

    public var dayJi: [String] {
        get {
            getDayJi(sect:1)
        }
    }

    public func getDayJi(sect: Int) -> [String] {
        LunarUtil.getDayJi(monthGanZhi: 2 == sect ? monthInGanZhiExact : monthInGanZhi, dayGanZhi: dayInGanZhi)
    }

    public var dayJiShen: [String] {
        get {
            LunarUtil.getDayJiShen(lunarMonth: _month, dayGanZhi: dayInGanZhi)
        }
    }

    public var dayXiongSha: [String] {
        get {
            LunarUtil.getDayXiongSha(lunarMonth: _month, dayGanZhi: dayInGanZhi)
        }
    }

    public var dayChong: String {
        get {
            LunarUtil.CHONG[_dayZhiIndex]
        }
    }

    public var daySha: String {
        get {
            LunarUtil.SHA[dayZhi]!
        }
    }

    public var dayChongShengXiao: String {
        get {
            for i in (0..<LunarUtil.ZHI.count) {
                if LunarUtil.ZHI[i] == dayChong {
                    return LunarUtil.SHENG_XIAO[i]
                }
            }
            return ""
        }
    }

    public var dayChongGan: String {
        get {
            LunarUtil.CHONG_GAN[_dayGanIndex]
        }
    }

    public var dayChongGanTie: String {
        get {
            LunarUtil.CHONG_GAN_TIE[_dayGanIndex]
        }
    }

    public var dayChongDesc: String {
        get {
            "(\(dayChongGan)\(dayChong))\(dayChongShengXiao)"
        }
    }

    public var timeChong: String {
        get {
            LunarUtil.CHONG[_timeZhiIndex]
        }
    }

    public var timeSha: String {
        get {
            LunarUtil.SHA[timeZhi]!
        }
    }

    public var timeChongShengXiao: String {
        get {
            for i in (0..<LunarUtil.ZHI.count) {
                if LunarUtil.ZHI[i] == timeChong {
                    return LunarUtil.SHENG_XIAO[i]
                }
            }
            return ""
        }
    }

    public var timeChongGan: String {
        get {
            LunarUtil.CHONG_GAN[_timeGanIndex]
        }
    }

    public var timeChongGanTie: String {
        get {
            LunarUtil.CHONG_GAN_TIE[_timeGanIndex]
        }
    }

    public var yueXiang: String {
        get {
            LunarUtil.YUE_XIANG[_day]
        }
    }

    public var timeChongDesc: String {
        get {
            "(\(timeChongGan)\(timeChong))\(timeChongShengXiao)"
        }
    }

    public var jie: String {
        get {
            for i in stride(from: 0, to: Lunar.JIE_QI_IN_USE.count, by: 2) {
                let key = Lunar.JIE_QI_IN_USE[i]
                let d = _jieQi[key]!
                if d.year == _solar.year && d.month == _solar.month && d.day == _solar.day {
                    return Lunar.convertJieQi(name: key);
                }
            }
            return ""
        }
    }

    public var qi: String {
        get {
            for i in stride(from: 1, to: Lunar.JIE_QI_IN_USE.count, by: 2) {
                let key = Lunar.JIE_QI_IN_USE[i]
                let d = _jieQi[key]!
                if d.year == _solar.year && d.month == _solar.month && d.day == _solar.day {
                    return Lunar.convertJieQi(name: key);
                }
            }
            return ""
        }
    }

    private class func convertJieQi(name: String) -> String {
        var jq = name
        if "DONG_ZHI" == jq {
            jq = "冬至"
        } else if "DA_HAN" == jq {
            jq = "大寒"
        } else if "XIAO_HAN" == jq {
            jq = "小寒"
        } else if "LI_CHUN" == jq {
            jq = "立春"
        } else if "DA_XUE" == jq {
            jq = "大雪"
        } else if "YU_SHUI" == jq {
            jq = "雨水"
        } else if "JING_ZHE" == jq {
            jq = "惊蛰"
        }
        return jq
    }

    public var jieQiTable: [String: Solar] {
        get {
            _jieQi
        }
    }

    public var jieQi: String {
        get {
            var name = ""
            for jq in Lunar.JIE_QI_IN_USE {
                let d = _jieQi[jq]!
                if d.year == _solar.year && d.month == _solar.month && d.day == _solar.day {
                    name = jq
                    break
                }
            }
            return Lunar.convertJieQi(name: name)
        }
    }

    public var prevJie: JieQi {
        get {
            getPrevJie(wholeDay: false)!
        }
    }

    public var nextJie: JieQi {
        get {
            getNextJie(wholeDay: false)!
        }
    }

    public var prevJieQi: JieQi {
        get {
            getPrevJieQi(wholeDay: false)!
        }
    }

    public var nextJieQi: JieQi {
        get {
            getNextJieQi(wholeDay: false)!
        }
    }

    public var shuJiu: ShuJiu? {
        get {
            let current = Solar.fromYmdHms(year: solar.year, month: solar.month, day: solar.day)
            var start = _jieQi["DONG_ZHI"]!
            start = Solar.fromYmdHms(year: start.year, month: start.month, day: start.day)

            if current.isBefore(solar: start) {
                start = _jieQi["冬至"]!
                start = Solar.fromYmdHms(year: start.year, month: start.month, day: start.day)
            }

            let end = start.next(days: 81)

            if current.isBefore(solar: start) || !current.isBefore(solar: end) {
                return nil
            }

            let days = current.subtract(solar: start)
            return ShuJiu(name: LunarUtil.NUMBER[days / 9 + 1] + "九", index: days % 9 + 1)
        }
    }

    public var fu: Fu? {
        get {
            let current = Solar.fromYmdHms(year: solar.year, month: solar.month, day: solar.day)
            let xiaZhi = _jieQi["夏至"]!
            let liQiu = _jieQi["立秋"]!
            var start = Solar.fromYmdHms(year: xiaZhi.year, month: xiaZhi.month, day: xiaZhi.day)
            // 第1个庚日
            var add = 6 - xiaZhi.lunar.dayGanIndex
            if add < 0 {
                add += 10
            }
            // 第3个庚日，即初伏第1天
            add += 20
            start = start.next(days: add)

            // 初伏以前
            if current.isBefore(solar: start) {
                return nil
            }

            var days = current.subtract(solar: start)
            if days < 10 {
                return Fu(name: "初伏", index: days + 1)
            }

            // 第4个庚日，中伏第1天
            start = start.next(days: 10)
            days = current.subtract(solar: start)
            if days < 10 {
                return Fu(name: "中伏", index: days + 1)
            }

            // 第5个庚日，中伏第11天或末伏第1天
            start = start.next(days: 10)
            days = current.subtract(solar: start)
            let liQiuSolar = Solar.fromYmdHms(year: liQiu.year, month: liQiu.month, day: liQiu.day)
            // 末伏
            if !liQiuSolar.isAfter(solar: start) {
                if days < 10 {
                    return Fu(name: "末伏", index: days + 1)
                }
            } else {
                // 中伏
                if days < 10 {
                    return Fu(name: "中伏", index: days + 11)
                }
                // 末伏第1天
                start = start.next(days: 10)
                days = current.subtract(solar: start)
                if days < 10 {
                    return Fu(name: "末伏", index: days + 1)
                }
            }
            return nil
        }
    }

    public var liuYao: String {
        get {
            LunarUtil.LIU_YAO[(abs(month) - 1 + day - 1) % 6]
        }
    }

    public var wuHou: String {
        get {
            let jieQi = getPrevJieQi(wholeDay: true)!
            var offset = 0
            for i in (0..<Lunar.JIE_QI.count) {
                if jieQi.name == Lunar.JIE_QI[i] {
                    offset = i
                    break
                }
            }
            var index = solar.subtract(solar: jieQi.solar) / 5
            if index > 2 {
                index = 2
            }
            return LunarUtil.WU_HOU[(offset * 3 + index) % LunarUtil.WU_HOU.count]
        }
    }

    public var hou: String {
        get {
            let jieQi = getPrevJieQi(wholeDay: true)!
            let max = LunarUtil.HOU.count - 1
            var offset = solar.subtract(solar: jieQi.solar) / 5
            if offset > max {
                offset = max
            }
            return "\(jieQi.name) \(LunarUtil.HOU[offset])"
        }
    }

    public var dayLu: String {
        get {
            let gan = LunarUtil.LU[dayGan]!
            let zhi = LunarUtil.LU[dayZhi]
            var lu = "\(gan)命互禄"
            if nil != zhi {
                lu += " \(zhi!)命进禄"
            }
            return lu
        }
    }

    public var festivals: [String] {
        get {
            var l = [String]()
            let f = LunarUtil.FESTIVAL["\(_month)-\(_day)"]
            if nil != f {
                l.append(f!)
            }
            if abs(_month) == 12 && _day >= 29 && _year != next(days: 1).year {
                l.append("除夕")
            }
            return l
        }
    }

    public var otherFestivals: [String] {
        get {
            var l = [String]()
            let f = LunarUtil.OTHER_FESTIVAL["\(_month)-\(_day)"]
            if nil != f {
                for i in f! {
                    l.append(i)
                }
            }
            let solarYmd = _solar.ymd
            var jq = _jieQi["清明"]!
            if solarYmd == jq.next(days: -1).ymd {
                l.append("寒食节")
            }

            jq = _jieQi["立春"]!
            var offset = 4 - jq.lunar.dayGanIndex
            if offset < 0 {
                offset += 10
            }
            if solarYmd == jq.next(days: offset+40).ymd {
                l.append("春社")
            }

            jq = _jieQi["立秋"]!
            offset = 4 - jq.lunar.dayGanIndex
            if offset < 0 {
                offset += 10
            }
            if solarYmd == jq.next(days: offset+40).ymd {
                l.append("秋社")
            }
            return l
        }
    }

    public override var description: String {
        get {
            "\(yearInChinese)年\(monthInChinese)月\(dayInChinese)"
        }
    }

    public var fullString: String {
        get {
            var s = "\(description) \(yearInGanZhi)(\(yearShengXiao))年\(monthInGanZhi)(\(monthShengXiao))月\(dayInGanZhi)(\(dayShengXiao))日\(timeInGanZhi)(\(timeShengXiao))时"
            s += "纳音[\(yearNaYin) \(monthNaYin) \(dayNaYin) \(timeNaYin)] "
            s += "星期\(weekInChinese)"
            for i in festivals {
                s += " (\(i))"
            }
            for i in otherFestivals {
                s += " (\(i))"
            }
            if !jieQi.isEmpty {
                s += " [\(jieQi)]"
            }
            s += " \(gong)方\(shou) 星宿[\(xiu)\(zheng)\(animal)](\(xiuLuck)) 彭祖百忌[\(pengZuGan) \(pengZuZhi)]"
            s += " 喜神方位[\(dayPositionXi)](\(dayPositionXiDesc))"
            s += " 阳贵神方位[\(dayPositionYangGui)](\(dayPositionYangGuiDesc))"
            s += " 阴贵神方位[\(dayPositionYinGui)](\(dayPositionYinGuiDesc))"
            s += " 福神方位[\(dayPositionFu)](\(dayPositionFuDesc))"
            s += " 财神方位[\(dayPositionCai)](\(dayPositionCaiDesc))"
            s += " 冲[\(dayChongDesc)] 煞[\(daySha)]"
            return s
        }
    }

    public func next(days: Int) -> Lunar {
        _solar.next(days: days).lunar
    }

    public func getNextJieQi(wholeDay: Bool = false) -> JieQi? {
        getNearJieQi(forward: true, conditions: nil, wholeDay: wholeDay)
    }

    public func getNextJie(wholeDay: Bool = false) -> JieQi? {
        let l = Lunar.JIE_QI_IN_USE.count / 2
        var conditions = [String]()
        for i in (0..<l) {
            conditions.append(Lunar.JIE_QI_IN_USE[i*2])
        }
        return getNearJieQi(forward: true, conditions: conditions, wholeDay: wholeDay)
    }

    public func getPrevJieQi(wholeDay: Bool = false) -> JieQi? {
        getNearJieQi(forward: false, conditions: nil, wholeDay: wholeDay)
    }

    public func getPrevJie(wholeDay: Bool = false) -> JieQi? {
        let l = Lunar.JIE_QI_IN_USE.count / 2
        var conditions = [String]()
        for i in (0..<l) {
            conditions.append(Lunar.JIE_QI_IN_USE[i*2])
        }
        return getNearJieQi(forward: false, conditions: conditions, wholeDay: wholeDay)
    }

    private func getNearJieQi(forward: Bool, conditions: [String]?, wholeDay: Bool) -> JieQi? {
        var name = ""
        var near: Solar?
        var filters = [String: Bool]()
        if nil != conditions {
            for v in conditions! {
                filters[v] = true
            }
        }
        let filter = filters.count > 0
        var today = ""
        if wholeDay {
            today = _solar.ymd
        } else {
            today = _solar.ymdhms
        }
        for key in Lunar.JIE_QI_IN_USE {
            let jq = Lunar.convertJieQi(name: key)
            if filter {
                let f = filters[jq]
                if nil == f || !f! {
                    continue
                }
            }
            let solar = _jieQi[key]!
            var day = ""
            if wholeDay {
                day = solar.ymd
            } else {
                day = solar.ymdhms
            }
            if forward {
                if day < today {
                    continue
                }
                if nil == near {
                    name = jq
                    near = solar
                } else {
                    var nearDay = ""
                    if wholeDay {
                        nearDay = near!.ymd
                    } else {
                        nearDay = near!.ymdhms
                    }
                    if day < nearDay {
                        name = jq
                        near = solar
                    }
                }
            } else {
                if day > today {
                    continue
                }
                if nil == near {
                    name = jq
                    near = solar
                } else {
                    var nearDay = ""
                    if wholeDay {
                        nearDay = near!.ymd
                    } else {
                        nearDay = near!.ymdhms
                    }
                    if day > nearDay {
                        name = jq
                        near = solar
                    }
                }
            }
        }
        if nil == near {
            return nil
        }
        return JieQi(name: name, solar: near!)
    }

    public var yearXun: String {
        get {
            LunarUtil.getXun(ganZhi: yearInGanZhi)
        }
    }

    public var yearXunByLiChun: String {
        get {
            LunarUtil.getXun(ganZhi: yearInGanZhiByLiChun)
        }
    }

    public var yearXunExact: String {
        get {
            LunarUtil.getXun(ganZhi: yearInGanZhiExact)
        }
    }

    public var yearXunKong: String {
        get {
            LunarUtil.getXunKong(ganZhi: yearInGanZhi)
        }
    }

    public var yearXunKongByLiChun: String {
        get {
            LunarUtil.getXunKong(ganZhi: yearInGanZhiByLiChun)
        }
    }

    public var yearXunKongExact: String {
        get {
            LunarUtil.getXunKong(ganZhi: yearInGanZhiExact)
        }
    }

    public var monthXun: String {
        get {
            LunarUtil.getXun(ganZhi: monthInGanZhi)
        }
    }

    public var monthXunExact: String {
        get {
            LunarUtil.getXun(ganZhi: monthInGanZhiExact)
        }
    }

    public var monthXunKong: String {
        get {
            LunarUtil.getXunKong(ganZhi: monthInGanZhi)
        }
    }

    public var monthXunKongExact: String {
        get {
            LunarUtil.getXunKong(ganZhi: monthInGanZhiExact)
        }
    }

    public var dayXun: String {
        get {
            LunarUtil.getXun(ganZhi: dayInGanZhi)
        }
    }

    public var dayXunExact: String {
        get {
            LunarUtil.getXun(ganZhi: dayInGanZhiExact)
        }
    }

    public var dayXunExact2: String {
        get {
            LunarUtil.getXun(ganZhi: dayInGanZhiExact2)
        }
    }

    public var dayXunKong: String {
        get {
            LunarUtil.getXunKong(ganZhi: dayInGanZhi)
        }
    }

    public var dayXunKongExact: String {
        get {
            LunarUtil.getXunKong(ganZhi: dayInGanZhiExact)
        }
    }

    public var dayXunKongExact2: String {
        get {
            LunarUtil.getXunKong(ganZhi: dayInGanZhiExact2)
        }
    }

    public var timeXun: String {
        get {
            LunarUtil.getXun(ganZhi: timeInGanZhi)
        }
    }

    public var timeXunKong: String {
        get {
            LunarUtil.getXunKong(ganZhi: timeInGanZhi)
        }
    }

    public var eightChar: EightChar {
        get {
            if nil == _eightChar {
                _eightChar = EightChar(lunar: self)
            }
            return _eightChar!
        }
    }

    public var time: LunarTime {
        get {
            LunarTime.fromYmdHms(lunarYear: _year, lunarMonth: _month, lunarDay: _day, hour: _hour, minute: _minute, second: _second)
        }
    }

    public var times: [LunarTime] {
        get {
            var l = [LunarTime]()
            l.append(LunarTime.fromYmdHms(lunarYear: _year, lunarMonth: _month, lunarDay: _day, hour: 0, minute: 0, second: 0))
            for i in (0..<12) {
                l.append(LunarTime.fromYmdHms(lunarYear: _year, lunarMonth: _month, lunarDay: _day, hour: (i + 1) * 2 - 1, minute: 0, second: 0))
            }
            return l
        }
    }

}
