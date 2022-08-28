import Benchmark
import LocalDate

benchmark("LocalDate.init(from:)") {
    _ = try LocalDate(from: "1970-12-31")
}

let d = LocalDate(year: 1970, month: 12, day: 31)
benchmark("LocalDate.description") {
    _ = d.description
}

Benchmark.main()
