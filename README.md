# hash

[![package: vs-package](https://img.shields.io/badge/package-vs--package-f4f4f5?style=flat-square&labelColor=e4e4e7&color=18181b)](https://github.com/vertex-language)
[![algorithms: crc32 | crc64 | adler32 | fnv | xxh3](https://img.shields.io/badge/algorithms-crc32%20%7C%20crc64%20%7C%20adler32%20%7C%20fnv%20%7C%20xxh3-f4f4f5?style=flat-square&labelColor=e4e4e7&color=18181b)](https://github.com/vertex-language/hash)

Collection of non-cryptographic hash functions, checksums, and streaming digest algorithms.

---

## Sub-Packages

| Package | Description | Common Uses |
| --- | --- | --- |
| [`hash/crc32`](#hashcrc32) | 32-bit Cyclic Redundancy Check (IEEE 802.3, Castagnoli / CRC-32C, Koopman) | Ethernet, gzip, PNG, SCTP, iSCSI, Btrfs |
| [`hash/crc64`](#hashcrc64) | 64-bit Cyclic Redundancy Check (ISO 3309, ECMA-182) | HDLC, filesystem metadata, storage checksums |
| [`hash/adler32`](#hashadler32) | Adler-32 rolling checksum (RFC 1950) | zlib stream verification, fast rolling checksums |
| [`hash/fnv`](#hashfnv) | Fowler-Noll-Vo hash functions (FNV-1 and FNV-1a, 32-bit & 64-bit) | Hash tables, hash sets, fast in-memory key hashing |
| [`hash/xxh3`](#hashxxh3) | Modern ultra-fast non-cryptographic hash (64-bit and 128-bit) | Content-addressed caches, deduplication, hash joins |

---

## Quick Start

Run the test suite in `cmd/` directly with `vsc run`:

```bash
vsc run check
```

### CRC-32 (`hash/crc32`)

```swift
package main

import "hash/crc32"

func main() -> int32 {
    let data = [uint8]("123456789".utf8)

    // IEEE 802.3 (gzip, PNG, Ethernet)
    let ieee = crc32.ChecksumIEEE(data)
    print("IEEE: 0x\(ieee)") // 0xCBF43926

    // Castagnoli / CRC-32C (SCTP, iSCSI)
    let c32c = crc32.ChecksumCastagnoli(data)
    print("CRC-32C: 0x\(c32c)") // 0xE3069283

    // Streaming Digest
    var d = crc32.NewIEEE()
    d.WriteString("12345")
    d.WriteString("6789")
    print("Streaming: 0x\(d.Sum32())")

    return 0
}
```

---

### Adler-32 (`hash/adler32`)

```swift
package main

import "hash/adler32"

func main() -> int32 {
    let sum = adler32.ChecksumString("Wikipedia")
    print("Adler-32: 0x\(sum)") // 0x11E60398

    // Streaming
    var d = adler32.New()
    d.WriteString("Wiki")
    d.WriteString("pedia")
    print("Streaming: 0x\(d.Sum32())")

    return 0
}
```

---

### CRC-64 (`hash/crc64`)

```swift
package main

import "hash/crc64"

func main() -> int32 {
    let data = [uint8]("123456789".utf8)

    // ISO 3309
    let iso = crc64.ChecksumISO(data)
    print("ISO: 0x\(iso)") // 0xB90956C775A41001

    // ECMA-182
    let ecma = crc64.ChecksumECMA(data)
    print("ECMA: 0x\(ecma)") // 0x995DC9BBDF1939FA

    return 0
}
```

---

### FNV (`hash/fnv`)

```swift
package main

import "hash/fnv"

func main() -> int32 {
    // FNV-1a 32-bit & 64-bit
    let h32 = fnv.Sum32aString("hello world")
    let h64 = fnv.Sum64aString("hello world")

    print("FNV-1a 32: \(h32)")
    print("FNV-1a 64: \(h64)")

    // Streaming
    var d = fnv.New64a()
    d.WriteString("hello ")
    d.WriteString("world")
    print("Streaming: \(d.Sum64())")

    return 0
}
```

---

### XXH3 (`hash/xxh3`)

```swift
package main

import "hash/xxh3"

func main() -> int32 {
    // 64-bit hash
    let h64 = xxh3.Hash64String("fast non-crypto hash")
    print("XXH3 64: 0x\(h64)")

    // 128-bit hash
    let (lo, hi) = xxh3.Hash128String("fast non-crypto hash")
    print("XXH3 128: 0x\(hi):0x\(lo)")

    // Streaming
    var d = xxh3.New64()
    d.WriteString("chunk 1, ")
    d.WriteString("chunk 2")
    print("Streaming 64: 0x\(d.Sum64())")

    return 0
}
```

---

## Testing

Run the test suite:

```bash
vsc run check
```

---

## License

[MIT](LICENSE)
