# LocalDate for Swift

[![Swift](https://github.com/konomae/LocalDate/actions/workflows/ci.yml/badge.svg)](https://github.com/konomae/LocalDate/actions/workflows/ci.yml)

`LocalDate` is a struct that represents a date without a time zone, such as a birthday.
This library provides the ability to convert a `LocalDate` to a `Date` or `String` and vice versa.

(This is similar to `java.time.LocalDate`, but this is not intended to be compatible with it. 🙏)

## Installation

Add the following line to the dependencies in your `Package.swift` file.

```swift
.package(url: "https://github.com/konomae/LocalDate", from: "0.1.0"),
```

## Example

```swift
import LocalDate

let localDate = try LocalDate(from: "1970-01-01")
print(localDate.year) // 1970
print(localDate.month) // 1
print(localDate.day) // 1
print(localDate.string()) // 1970-01-01

var date: Date = localDate.date(in: TimeZone(secondsFromGMT: 0)!)
print(date) // 1970-01-01 00:00:00 +0000

date = localDate.date(in: TimeZone(identifier: "Asia/Tokyo")!)
print(date) // 1969-12-31 15:00:00 +0000 (1970-01-01 00:00:00 +0900)
```
