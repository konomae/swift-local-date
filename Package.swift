// swift-tools-version:5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "swift-local-date",
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "LocalDate",
            targets: ["LocalDate"]
        ),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        .package(url: "https://github.com/google/swift-benchmark", from: "0.1.2"),
        .package(url: "https://github.com/nicklockwood/SwiftFormat", from: "0.53.8"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "LocalDate",
            dependencies: []
        ),
        .testTarget(
            name: "LocalDateTests",
            dependencies: ["LocalDate"]
        ),
        .executableTarget(
            name: "swift-local-date-benchmark",
            dependencies: [
                "LocalDate",
                .product(name: "Benchmark", package: "swift-benchmark"),
            ]
        ),
    ]
)
