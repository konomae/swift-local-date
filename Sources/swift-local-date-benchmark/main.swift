import Benchmark
import LocalDate

benchmark("LocalDate.init(from:)") {
    _ = try LocalDate(from: "1970-12-31")
}

let d = LocalDate(year: 1970, month: 12, day: 31)
benchmark("LocalDate.description") {
    _ = d.description
}

benchmark("LocalTime.init(from:)") {
    _ = try LocalTime(from: "23:59:59.999999999")
}

let t = LocalTime(hour: 23, minute: 59, second: 59, nanosecond: 999999999)
benchmark("LocalTime.description") {
    _ = t.description
}

benchmark("LocalDateTime.init(from:)") {
    _ = try LocalDateTime(from: "1970-12-31T23:59:59.999999999")
}

let dt = LocalDateTime(year: 1970, month: 12, day: 31, hour: 23, minute: 59, second: 59, nanosecond: 999999999)
benchmark("LocalDateTime.description") {
    _ = dt.description
}

benchmark("ZoneOffset.init(from:)") {
    _ = try ZoneOffset(from: "+02:30")
}

let zo = ZoneOffset(second: 9000)
benchmark("ZoneOffset.description") {
    _ = zo.description
}

benchmark("OffsetDateTime.init(from:)") {
    _ = try OffsetDateTime(from: "1970-12-31T01:02:03.4+02:30")
}

let odt = OffsetDateTime(
    dateTime: .init(year: 1970, month: 12, day: 31, hour: 23, minute: 59, second: 59, nanosecond: 999999999),
    offset: .init(second: 9000)
)
benchmark("OffsetDateTime.description") {
    _ = odt.description
}

Benchmark.main()
