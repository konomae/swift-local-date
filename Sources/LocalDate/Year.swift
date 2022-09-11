func isLeapYear(_ year: Int) -> Bool {
    year.isMultiple(of: 4) && (!year.isMultiple(of: 100) || year.isMultiple(of: 400))
}
