// import PackageDescription
//
// let package = Package(
//     name: "ETradeDemo",
//     platforms: [.iOS(.v15)],
//     products: [
//         .library(
//             name: "ETradeDemo",
//             targets: ["ETradeDemo"]
//         ),
//     ],
//     dependencies: [
//         .package(
//             url: "https:github.com/socketio/socket.io-client-swift.git",
//             .upToNextMajor(from: "16.0.0")
//         ),
//     ],
//     targets: [
//         .target(
//             name: "ETradeDemo",
//             dependencies: [
//                 .product(name: "SocketIO", package: "socket.io-client-swift"),
//             ]
//         ),
//         .testTarget(
//             name: "ETradeDemoTests",
//             dependencies: ["ETradeDemo"]
//         ),
//     ]
// )
