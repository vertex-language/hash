// The 'hash' repository: non-cryptographic hash functions and checksums for Vertex.
import PackageDescription

let package = Package(
    name: "hash",
    platforms: [
        .macOS(.v13),
    ],
    products: [
        .library(name: "hash/crc32", targets: ["crc32"]),
        .library(name: "hash/crc64", targets: ["crc64"]),
        .library(name: "hash/adler32", targets: ["adler32"]),
        .library(name: "hash/fnv", targets: ["fnv"]),
        .library(name: "hash/xxh3", targets: ["xxh3"]),
        .executable(name: "check", targets: ["check"]),
    ],
    targets: [
        // CRC-32 checksums: IEEE 802.3, Castagnoli (CRC-32C), and Koopman.
        .target(
            name: "crc32",
            path: "crc32"
        ),
        // CRC-64 checksums: ISO 3309 and ECMA-182.
        .target(
            name: "crc64",
            path: "crc64"
        ),
        // Adler-32 rolling checksum (RFC 1950).
        .target(
            name: "adler32",
            path: "adler32"
        ),
        // Fowler-Noll-Vo hash functions: FNV-1 and FNV-1a (32-bit and 64-bit).
        .target(
            name: "fnv",
            path: "fnv"
        ),
        // XXH3: Modern ultra-fast 64-bit and 128-bit non-cryptographic hash.
        .target(
            name: "xxh3",
            path: "xxh3"
        ),
        // Comprehensive test suite.
        .executableTarget(
            name: "check",
            dependencies: ["crc32", "crc64", "adler32", "fnv", "xxh3"],
            path: "tests/check"
        ),
    ]
)
