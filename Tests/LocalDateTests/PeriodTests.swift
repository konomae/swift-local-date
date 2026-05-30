import LocalDate
import Testing

struct PeriodTests {
    @Test
    func test_init() {
        let period = Period(years: 1, months: 2, days: 3)
        #expect(period.years == 1)
        #expect(period.months == 2)
        #expect(period.days == 3)
    }
}
