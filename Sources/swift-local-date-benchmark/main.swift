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

Benchmark.main()
