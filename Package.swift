// swift-tools-version: 5.9

import PackageDescription

let cSettings: [CSetting] = [
    .unsafeFlags(["-fno-objc-arc", "-Wno-shorten-64-to-32", "-O3"]),
    .define("NDEBUG"),
    //.define("WHISPER_USE_COREML"),
    //.define("WHISPER_COREML_ALLOW_FALLBACK"),
    .define("GGML_USE_ACCELERATE"),
    .define("GGML_USE_METAL"),
    .define("ACCELERATE_NEW_LAPACK"),
    .define("ACCELERATE_LAPACK_ILP64")
]

let package = Package(
    name: "WhisperCpp",
    platforms: [
        .macOS(.v14),
        .iOS(.v17),
        .watchOS(.v10),
        .tvOS(.v17)
    ],
    products: [
        .library(
            name: "WhisperCpp",
            targets: ["WhisperCpp"]
        )
    ],
    targets: [
        .target(
            name: "WhisperCpp",
            dependencies: [
                .target(name: "WhisperCoreML"),
                .target(name: "GGML")
            ],
            path: ".",
            exclude: [
               "bindings",
               "cmake",
               "examples",
               "ggml",
               "grammars",
               "models",
               "samples",
               "scripts",
               "tests",
               "CMakeLists.txt",
               "Makefile"
            ],
            sources: ["src/whisper.cpp"],
            cSettings: cSettings
        ),
        .target(
            name: "WhisperCoreML",
            path: "src/coreml",
            publicHeadersPath: "."
        ),
        .target(
            name: "GGML",
            path: "ggml",
            sources: [
                "src/ggml.c",
                "src/ggml-aarch64.c",
                "src/ggml-alloc.c",
                "src/ggml-backend.cpp",
                "src/ggml-quants.c",
                "src/ggml-metal.m",
            ],
            resources: [.process("src/ggml-metal.metal")],
            cSettings: cSettings,
            linkerSettings: [.linkedFramework("Accelerate")]
        )
    ],
    cxxLanguageStandard: .cxx11
)
