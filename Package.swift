// swift-tools-version:5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Brotli",
    platforms: [
        .iOS(.v15),
        .macOS(.v10_15),
    ],
    products: [
        .library(
            name: "Brotli",
            targets: ["Brotli"]),
    ],
    targets: [
        .target(
            name: "Brotli",
            path: "Brotli",
            exclude: [
                "Source/c/common/dictionary.bin",
                "Source/c/common/dictionary.bin.br",
            ],
            sources: ["Classes", "Source/c/common", "Source/c/dec", "Source/c/enc"],
            publicHeadersPath: "Classes",
            cSettings: [.headerSearchPath("Source/c/include")])
    ]
)
