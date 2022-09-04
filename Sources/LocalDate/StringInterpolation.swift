extension String.StringInterpolation {
    mutating func appendInterpolation<I: SignedInteger>(_ n: I, width: Int) {
        let description = abs(n).description
        let s = String(repeating: "0", count: max(width - description.count, 0)) + description
        appendLiteral(n < 0 ? "-" + s : s)
    }
}
