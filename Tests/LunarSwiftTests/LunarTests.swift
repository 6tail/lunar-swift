import XCTest
@testable import LunarSwift

final class LunarTests: XCTestCase {
    func test1() throws {
        let lunar = Lunar.fromYmdHms(lunarYear: 2019, lunarMonth: 3, lunarDay: 27)
        XCTAssertEqual(lunar.description, "二〇一九年三月廿七")
        XCTAssertEqual(lunar.solar.fullString, "2019-05-01 00:00:00 星期三 (劳动节) 金牛座")
    }

    func test2() throws {
        XCTAssertEqual(Solar.fromYmdHms(year: 1, month: 1, day: 1, hour: 12).lunar.description, "〇年冬月十八")
    }

    func test3() throws {
        XCTAssertEqual(Solar.fromYmdHms(year: 9999, month: 12, day: 31, hour: 12).lunar.description, "九九九九年腊月初二")
    }

    func test4() throws {
        XCTAssertEqual(Lunar.fromYmdHms(lunarYear: 1905, lunarMonth: 1, lunarDay: 1, hour: 12).solar.description, "1905-02-04")
    }

    func test5() throws {
        XCTAssertEqual(Lunar.fromYmdHms(lunarYear: 2038, lunarMonth: 12, lunarDay: 29, hour: 12).solar.description, "2039-01-23")
    }

    func test6() throws {
        let lunar = Lunar.fromYmdHms(lunarYear: 2020, lunarMonth: -4, lunarDay: 2, hour: 13)
        XCTAssertEqual(lunar.description, "二〇二〇年闰四月初二")
        XCTAssertEqual(lunar.solar.description, "2020-05-24")
    }

    func test7() throws {
        let lunar = Lunar.fromYmdHms(lunarYear: 2020, lunarMonth: 12, lunarDay: 10, hour: 13)
        XCTAssertEqual(lunar.description, "二〇二〇年腊月初十")
        XCTAssertEqual(lunar.solar.description, "2021-01-22")
    }

    func test8() throws {
        XCTAssertEqual(Lunar.fromYmdHms(lunarYear: 1500, lunarMonth: 1, lunarDay: 1, hour: 12).solar.description, "1500-01-31")
    }

    func test9() throws {
        XCTAssertEqual(Lunar.fromYmdHms(lunarYear: 1500, lunarMonth: 12, lunarDay: 29, hour: 12).solar.description, "1501-01-18")
    }

    func test10() throws {
        XCTAssertEqual(Solar.fromYmdHms(year: 1582, month: 10, day: 4, hour: 12).lunar.description, "一五八二年九月十八")
    }

    func test11() throws {
        XCTAssertEqual(Solar.fromYmdHms(year: 1582, month: 10, day: 15, hour: 12).lunar.description, "一五八二年九月十九")
    }

    func test12() throws {
        XCTAssertEqual(Lunar.fromYmdHms(lunarYear: 2021, lunarMonth: 12, lunarDay: 29).festivals[0], "除夕")
    }

    func test13() throws {
        XCTAssertEqual(Lunar.fromYmdHms(lunarYear: 2020, lunarMonth: 12, lunarDay: 30).festivals[0], "除夕")
    }

    func test14() throws {
        XCTAssertEqual(Solar.fromYmdHms(year: 2022, month: 1, day: 31).lunar.festivals[0], "除夕")
    }

    func test15() throws {
        XCTAssertEqual(Lunar.fromYmdHms(lunarYear: 2033, lunarMonth: -11, lunarDay: 1).solar.description, "2033-12-22")
    }

    func test16() throws {
        XCTAssertEqual(Solar.fromYmdHms(year: 1990, month: 10, day: 8).lunar.monthInGanZhiExact, "乙酉")
    }

    func test17() throws {
        XCTAssertEqual(Solar.fromYmdHms(year: 1990, month: 10, day: 9).lunar.monthInGanZhiExact, "丙戌")
    }

    func test18() throws {
        XCTAssertEqual(Solar.fromYmdHms(year: 1990, month: 10, day: 8).lunar.monthInGanZhi, "丙戌")
    }

    func test19() throws {
        XCTAssertEqual(Lunar.fromYmdHms(lunarYear: 37, lunarMonth: -12, lunarDay: 1).monthInChinese, "闰腊")
    }

    func test20() throws {
        XCTAssertEqual(Solar.fromYmdHms(year: 5553, month: 1, day: 22).lunar.description, "五五五二年闰腊月初二")
    }

    func test21() throws {
        XCTAssertEqual(Solar.fromYmdHms(year: 7013, month: 12, day: 24).lunar.description, "七〇一三年闰冬月初四")
    }

    func test22() throws {
        XCTAssertEqual(Solar.fromYmdHms(year: 4, month: 2, day: 10).lunar.yearShengXiao, "鼠")
    }

    func test23() throws {
        XCTAssertEqual(Solar.fromYmdHms(year: 4, month: 2, day: 9).lunar.yearShengXiao, "猪")
    }

    func test24() throws {
        XCTAssertEqual(Lunar.fromYmdHms(lunarYear: 1518, lunarMonth: 1, lunarDay: 1).solar.ymd, "1518-02-10")
    }

    func test25() throws {
        XCTAssertEqual(Lunar.fromYmdHms(lunarYear: 793, lunarMonth: 1, lunarDay: 1).solar.ymd, "0793-02-15")
    }

    func test26() throws {
        XCTAssertEqual(Lunar.fromYmdHms(lunarYear: 2025, lunarMonth: -6, lunarDay: 1).solar.ymd, "2025-07-25")
    }

    func test27() throws {
        XCTAssertEqual(Lunar.fromYmdHms(lunarYear: 2025, lunarMonth: 6, lunarDay: 1).solar.ymd, "2025-06-25")
    }

    func test28() throws {
        XCTAssertEqual(Lunar.fromYmdHms(lunarYear: 41, lunarMonth: 1, lunarDay: 1).solar.ymd, "0041-02-20")
    }

    func test29() throws {
        XCTAssertEqual(Lunar.fromYmdHms(lunarYear: 1537, lunarMonth: 1, lunarDay: 1).solar.ymd, "1537-02-10")
    }

}
