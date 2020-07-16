// swift-tools-version:5.0
import PackageDescription

let package = Package(
    name: "SmartDeviceLink",
    products: [
        .library(name: "SmartDeviceLink", targets: ["SmartDeviceLink"]),
        .library(name: "SmartDeviceLinkSwift", targets: ["SmartDeviceLinkSwift"])
    ],
    targets: [
        .target(
            name: "SmartDeviceLink",
            dependencies: ["bson"],
            path: "SmartDeviceLink",
            publicHeadersPath: "."
        ),
        .target(
            name: "SmartDeviceLinkSwift",
            dependencies: [
                "SmartDeviceLink"
            ],
            path: "SmartDeviceLinkSwift"
        ),
        .target(name: "bson",
                path: "Sources/bson",
                sources: [
                    "bson_array.c",
                    "bson_object.c",
                    "bson_util.c",
                ],
                publicHeadersPath: "include"
        ),
    ]
)
