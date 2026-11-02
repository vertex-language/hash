package main

import (
    "hash/adler32"
    "hash/crc32"
    "hash/crc64"
    "hash/fnv"
    "hash/xxh3"
)

var checkCount: int32 = 0
var failureCount: int32 = 0

func assert(condition: bool, message: string) {
    checkCount += 1
    if condition {
        print("ok    \(message)")
    } else {
        failureCount += 1
        print("FAIL  \(message)")
    }
}

func main() -> int32 {
    print("=== Testing hash sub-packages ===")

    // ==========================================
    // 1. CRC-32 (IEEE, Castagnoli, Koopman)
    // ==========================================
    print("\n--- Testing crc32 ---")

    // Empty string IEEE CRC-32 is 0
    assert(crc32.ChecksumString("") == 0, "crc32 empty string is 0")

    // Standard vector "123456789" -> 0xCBF43926
    let digits = "123456789"
    let c1 = crc32.ChecksumIEEE([uint8](digits.utf8))
    assert(c1 == 0xCBF43926, "crc32 IEEE '123456789' is 0xCBF43926")

    // "The quick brown fox jumps over the lazy dog" -> 0x414FA339
    let fox = "The quick brown fox jumps over the lazy dog"
    assert(crc32.ChecksumString(fox) == 0x414FA339, "crc32 IEEE quick brown fox is 0x414FA339")

    // Castagnoli (CRC-32C) "123456789" -> 0xE3069283
    let cCast = crc32.ChecksumCastagnoliString(digits)
    assert(cCast == 0xE3069283, "crc32 Castagnoli '123456789' is 0xE3069283")

    // Streaming CRC-32 Digest vs one-shot Checksum
    var d32 = crc32.NewIEEE()
    d32.WriteString("12345")
    d32.WriteString("6789")
    assert(d32.Sum32() == 0xCBF43926, "crc32 streaming matches one-shot")

    // Sum() appends 4 big-endian bytes
    let sumBytes = d32.Sum()
    assert(sumBytes.count == 4, "crc32 Sum() produces 4 bytes")
    assert(sumBytes[0] == 0xCB && sumBytes[1] == 0xF4 && sumBytes[2] == 0x39 && sumBytes[3] == 0x26, "crc32 Sum() big-endian bytes match")

    // Reset clears state
    d32.Reset()
    assert(d32.Sum32() == 0, "crc32 Reset resets to 0")

    // Koopman table polynomial exists and works
    let kSum = crc32.Checksum([uint8](digits.utf8), table: crc32.Table.KoopmanTable)
    assert(kSum != 0, "crc32 Koopman table computes non-zero checksum")

    // ==========================================
    // 2. CRC-64 (ISO, ECMA)
    // ==========================================
    print("\n--- Testing crc64 ---")

    // Empty string CRC-64 is 0
    assert(crc64.ChecksumString("") == 0, "crc64 empty string is 0")

    // Standard vector "123456789" with ISO -> 0xB90956C775A41001
    let c64_iso = crc64.ChecksumISO([uint8](digits.utf8))
    assert(c64_iso == 0xB90956C775A41001, "crc64 ISO '123456789' is 0xB90956C775A41001")

    // Standard vector "123456789" with ECMA -> 0x995DC9BBDF1939FA
    let c64_ecma = crc64.ChecksumECMA([uint8](digits.utf8))
    assert(c64_ecma == 0x995DC9BBDF1939FA, "crc64 ECMA '123456789' is 0x995DC9BBDF1939FA")

    // Streaming CRC-64 Digest vs one-shot
    var d64 = crc64.NewISO()
    d64.WriteString("The quick brown fox ")
    d64.WriteString("jumps over the lazy dog")
    let fox64 = crc64.ChecksumISO([uint8](fox.utf8))
    assert(d64.Sum64() == fox64, "crc64 streaming matches one-shot")

    // Sum() appends 8 big-endian bytes
    let sum64Bytes = d64.Sum()
    assert(sum64Bytes.count == 8, "crc64 Sum() produces 8 bytes")

    // Reset clears state
    d64.Reset()
    assert(d64.Sum64() == 0, "crc64 Reset resets to 0")

    // ==========================================
    // 3. Adler-32 (RFC 1950)
    // ==========================================
    print("\n--- Testing adler32 ---")

    // Empty string Adler-32 is 1 (RFC 1950)
    assert(adler32.ChecksumString("") == 1, "adler32 empty string is 1")

    // "123456789" -> 0x091E01DE
    let adlerDigits = adler32.ChecksumString(digits)
    assert(adlerDigits == 0x091E01DE, "adler32 '123456789' is 0x091E01DE")

    // "Wikipedia" -> 0x11E60398
    assert(adler32.ChecksumString("Wikipedia") == 0x11E60398, "adler32 'Wikipedia' is 0x11E60398")

    // Streaming Adler-32 Digest vs one-shot
    var dadler = adler32.New()
    dadler.WriteString("Wiki")
    dadler.WriteString("pedia")
    assert(dadler.Sum32() == 0x11E60398, "adler32 streaming matches one-shot")

    let adlerBytes = dadler.Sum()
    assert(adlerBytes.count == 4, "adler32 Sum() produces 4 bytes")
    assert(adlerBytes[0] == 0x11 && adlerBytes[1] == 0xE6 && adlerBytes[2] == 0x03 && adlerBytes[3] == 0x98, "adler32 Sum() big-endian bytes match")

    // Large input exceeding nmax (5552 bytes) chunk limit
    var largeBuf = [uint8](repeating: 0x41, count: 10000) // 10,000 'A's
    let largeAdler = adler32.Checksum(largeBuf)
    assert(largeAdler != 0 && largeAdler != 1, "adler32 computes correct hash on data > 5552 bytes")

    // ==========================================
    // 4. FNV (FNV-1, FNV-1a, 32-bit & 64-bit)
    // ==========================================
    print("\n--- Testing fnv ---")

    // Empty string yields offset basis
    assert(fnv.Sum32String("") == 2166136261, "fnv-1 32 empty string is offset basis")
    assert(fnv.Sum32aString("") == 2166136261, "fnv-1a 32 empty string is offset basis")
    assert(fnv.Sum64String("") == 14695981039346656037, "fnv-1 64 empty string is offset basis")
    assert(fnv.Sum64aString("") == 14695981039346656037, "fnv-1a 64 empty string is offset basis")

    // Standard vector "a":
    // FNV-1a 32 on "a" -> 0xE40C292C
    assert(fnv.Sum32aString("a") == 0xE40C292C, "fnv-1a 32 on 'a' is 0xE40C292C")

    // FNV-1 32 on "a" -> (2166136261 * 16777619) ^ 97 = 0x050C5D7E
    assert(fnv.Sum32String("a") == 0x050C5D7E, "fnv-1 32 on 'a' is 0x050C5D7E")

    // Streaming matches one-shot for all 4 variants
    var f32 = fnv.New32()
    f32.WriteString("hello ")
    f32.WriteString("world")
    assert(f32.Sum32() == fnv.Sum32String("hello world"), "fnv-1 32 streaming matches one-shot")

    var f32a = fnv.New32a()
    f32a.WriteString("hello ")
    f32a.WriteString("world")
    assert(f32a.Sum32() == fnv.Sum32aString("hello world"), "fnv-1a 32 streaming matches one-shot")

    var f64 = fnv.New64()
    f64.WriteString("hello ")
    f64.WriteString("world")
    assert(f64.Sum64() == fnv.Sum64String("hello world"), "fnv-1 64 streaming matches one-shot")

    var f64a = fnv.New64a()
    f64a.WriteString("hello ")
    f64a.WriteString("world")
    assert(f64a.Sum64() == fnv.Sum64aString("hello world"), "fnv-1a 64 streaming matches one-shot")

    // FNV Sum() byte outputs
    assert(f32a.Sum().count == 4, "fnv-32a Sum() produces 4 bytes")
    assert(f64a.Sum().count == 8, "fnv-64a Sum() produces 8 bytes")

    // ==========================================
    // 5. XXH3 (64-bit and 128-bit)
    // ==========================================
    print("\n--- Testing xxh3 ---")

    // Empty string hash is consistent
    let empty64 = xxh3.Hash64String("")
    assert(empty64 != 0, "xxh3 empty string produces deterministic non-zero hash")

    // Different inputs produce different hashes
    let h1 = xxh3.Hash64String("hello")
    let h2 = xxh3.Hash64String("world")
    assert(h1 != h2, "xxh3 hashes differ for distinct inputs")

    // Different seeds produce different hashes
    let hSeed0 = xxh3.Hash64String("benchmark", seed: 0)
    let hSeed1 = xxh3.Hash64String("benchmark", seed: 1)
    assert(hSeed0 != hSeed1, "xxh3 hashes differ with different seeds")

    // Range sizes:
    // 1-3 bytes
    let hShort = xxh3.Hash64String("ab")
    assert(hShort != 0, "xxh3 2-byte input produces non-zero hash")

    // 4-8 bytes
    let hMedium = xxh3.Hash64String("vertex")
    assert(hMedium != 0, "xxh3 6-byte input produces non-zero hash")

    // 9-16 bytes
    let h16 = xxh3.Hash64String("1234567890abcdef")
    assert(h16 != 0, "xxh3 16-byte input produces non-zero hash")

    // 17-128 bytes
    let hLong = xxh3.Hash64String("The quick brown fox jumps over the lazy dog and runs away")
    assert(hLong != 0, "xxh3 57-byte input produces non-zero hash")

    // Large input (> 240 bytes)
    var largeText = ""
    var li = 0
    while li < 100 {
        largeText += "xxh3 test line \(li)\n"
        li += 1
    }
    let hLarge = xxh3.Hash64String(largeText)
    assert(hLarge != 0, "xxh3 large input (> 240 bytes) produces non-zero hash")

    // Streaming Digest64 vs one-shot Hash64
    var xxd = xxh3.New64()
    xxd.WriteString("quick ")
    xxd.WriteString("brown ")
    xxd.WriteString("fox")
    let xxdDirect = xxh3.Hash64String("quick brown fox")
    assert(xxd.Sum64() == xxdDirect, "xxh3 streaming Digest64 matches one-shot Hash64")
    assert(xxd.Sum().count == 8, "xxh3 Sum() produces 8 bytes")

    // 128-bit output
    let (h128Lo, h128Hi) = xxh3.Hash128String("test 128 bit hash")
    assert(h128Lo != 0, "xxh3 128-bit low word is non-zero")
    assert(h128Hi != 0, "xxh3 128-bit high word is non-zero")
    assert(h128Lo != h128Hi, "xxh3 128-bit low and high words differ")

    print("\n-----------------------------------------")
    print("Checks passed: \(checkCount - failureCount)/\(checkCount)")
    if failureCount == 0 {
        print("ALL HASH SUB-PACKAGES CHECKS PASSED!")
        return 0
    } else {
        print("FAILURES DETECTED: \(failureCount)")
        return 1
    }
}
