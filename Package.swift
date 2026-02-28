// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "Pasty",
    platforms: [.macOS(.v14)],
    targets: [
        .executableTarget(
            name: "Pasty",
            path: "Sources/Pasty",
            swiftSettings: [.swiftLanguageMode(.v6)]
        ),
        .testTarget(
            name: "PastyTests",
            dependencies: ["Pasty"],
            path: "Tests/PastyTests"
        ),
    ]
)
