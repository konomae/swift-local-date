extension String.StringInterpolation {
    mutating func appendInterpolation(_ n: some SignedInteger, width: Int) {
        let description = abs(n).description
        let s = String(repeating: "0", count: max(width - description.utf8.count, 0)) + description
        appendLiteral(n < 0 ? "-" + s : s)
    }
}
