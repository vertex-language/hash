package xxh3

let prime32_1: uint32 = 0x9E3779B1
let prime32_2: uint32 = 0x85EBCA77
let prime32_3: uint32 = 0xC2B2AE3D

let prime64_1: uint64 = 0x9E3779B185EBCA87
let prime64_2: uint64 = 0xC2B2AE3D27D4EB4F
let prime64_3: uint64 = 0x165667B19E3779F9
let prime64_4: uint64 = 0x85EBCA77C2B2AE63
let prime64_5: uint64 = 0x27D4EB2F165667C5

let defaultSecret: [uint8] = [
    0xb8, 0xfe, 0x6c, 0x39, 0x23, 0xa4, 0x4b, 0xbe, 0x7c, 0x01, 0x81, 0x2c, 0xf7, 0x21, 0xad, 0x1c,
    0xde, 0xd4, 0x6d, 0xe9, 0x83, 0x90, 0x97, 0xdb, 0x72, 0x40, 0xa4, 0xa4, 0xb7, 0xb3, 0x67, 0x1f,
    0xcb, 0x79, 0xe6, 0x4e, 0xcc, 0xc0, 0xe5, 0x78, 0x82, 0x5a, 0xd0, 0x7d, 0xcc, 0xff, 0x72, 0x21,
    0xb8, 0x08, 0x46, 0x74, 0xf7, 0x43, 0x24, 0x8e, 0xe0, 0x35, 0x90, 0xe6, 0x81, 0x3a, 0x26, 0x4c,
    0x3c, 0x28, 0x52, 0xbb, 0x91, 0xc3, 0x00, 0xcb, 0x88, 0xd0, 0x65, 0x8b, 0x1b, 0x53, 0x2e, 0xa3,
    0x71, 0x64, 0x48, 0x97, 0xa2, 0x0d, 0xf9, 0x4e, 0x38, 0x19, 0xef, 0x46, 0xa9, 0xde, 0xac, 0xd8,
    0xa8, 0xfa, 0x76, 0x3f, 0xe3, 0x9c, 0x34, 0x54, 0x2f, 0x22, 0x9a, 0xb0, 0x0c, 0xa3, 0x07, 0x49,
    0xa2, 0x08, 0x2e, 0x28, 0x16, 0x77, 0x28, 0x4d, 0x2d, 0x20, 0xdd, 0x90, 0x64, 0x18, 0x84, 0x09,
    0x95, 0x59, 0x9b, 0x3e, 0x85, 0x1b, 0xc1, 0xa4, 0x6e, 0x82, 0x76, 0x53, 0x58, 0x37, 0x04, 0x88,
    0xb1, 0x49, 0x67, 0x75, 0x73, 0x0e, 0x04, 0xd4, 0xdd, 0x0c, 0x18, 0x76, 0x4b, 0x08, 0x5a, 0x5a,
    0x54, 0xb8, 0x9d, 0x50, 0xa4, 0x1f, 0x98, 0x3a, 0x13, 0x9d, 0xfe, 0x01, 0xd6, 0x69, 0x24, 0x9b,
    0x39, 0x2b, 0xb8, 0xef, 0x87, 0x65, 0x90, 0x3a, 0x77, 0x53, 0x54, 0x40, 0x32, 0x8e, 0xdc, 0x64
]

func stringBytes(s: string) -> [uint8] {
    var bytes: [uint8] = []
    for b in s.utf8 {
        bytes.append(b)
    }
    return bytes
}

func readLE32(data: [uint8], offset: int) -> uint32 {
    return uint32(data[offset]) |
          (uint32(data[offset + 1]) << 8) |
          (uint32(data[offset + 2]) << 16) |
          (uint32(data[offset + 3]) << 24)
}

func readLE64(data: [uint8], offset: int) -> uint64 {
    return uint64(data[offset]) |
          (uint64(data[offset + 1]) << 8) |
          (uint64(data[offset + 2]) << 16) |
          (uint64(data[offset + 3]) << 24) |
          (uint64(data[offset + 4]) << 32) |
          (uint64(data[offset + 5]) << 40) |
          (uint64(data[offset + 6]) << 48) |
          (uint64(data[offset + 7]) << 56)
}

func mult64to128(a: uint64, b: uint64) -> (low: uint64, high: uint64) {
    let aLo = a & 0xFFFFFFFF
    let aHi = a >> 32
    let bLo = b & 0xFFFFFFFF
    let bHi = b >> 32

    let p0 = aLo &* bLo
    let p1 = aLo &* bHi
    let p2 = aHi &* bLo
    let p3 = aHi &* bHi

    let mid = p1 &+ p2
    let midCarry: uint64 = (mid < p1) ? (1 << 32) : 0
    let lo = p0 &+ (mid << 32)
    let loCarry: uint64 = (lo < p0) ? 1 : 0
    let hi = p3 &+ (mid >> 32) &+ midCarry &+ loCarry

    return (low: lo, high: hi)
}

func xxh3_avalanche(h: uint64) -> uint64 {
    var x = h
    x ^= x >> 37
    x = x &* 0x165667B19E3779F9
    x ^= x >> 32
    return x
}

func xxh64_avalanche(h: uint64) -> uint64 {
    var x = h
    x ^= x >> 33
    x = x &* prime64_2
    x ^= x >> 29
    x = x &* prime64_3
    x ^= x >> 32
    return x
}

func xxh3_rrmxmx(h: uint64, len: uint64) -> uint64 {
    let rot49 = (h << 49) | (h >> 15)
    let rot24 = (h << 24) | (h >> 40)
    var x = h ^ (rot49 ^ rot24)
    x = x &* 0x9FB21C651E98DF25
    x ^= (x >> 35) &+ len
    x = x &* 0x9FB21C651E98DF25
    x ^= x >> 28
    return x
}

func mix16Bytes(input: [uint8], inOff: int, sec: [uint8], secOff: int, seed: uint64) -> uint64 {
    let in1 = readLE64(input, inOff)
    let in2 = readLE64(input, inOff + 8)
    let sec1 = readLE64(sec, secOff)
    let sec2 = readLE64(sec, secOff + 8)

    let k1 = in1 ^ (sec1 &+ seed)
    let k2 = in2 ^ (sec2 &- seed)
    let (mLo, mHi) = mult64to128(k1, prime64_1)
    return mLo &+ (mHi &* prime64_2) &+ k2
}

/// Computes 64-bit XXH3 hash of input data.
public func Hash64(data: [uint8], seed: uint64 = 0) -> uint64 {
    let len = data.count
    let sec = defaultSecret

    if len == 0 {
        let secVal = readLE64(sec, 56) ^ readLE64(sec, 64)
        return xxh64_avalanche(seed ^ secVal)
    }

    if len <= 3 {
        let c1 = uint32(data[0])
        let c2 = uint32(data[len >> 1])
        let c3 = uint32(data[len - 1])
        let combined = (c1 << 16) | (c2 << 24) | (c3 << 8) | uint32(len)
        let bitflip = (readLE32(sec, 0) ^ readLE32(sec, 4)) &+ uint32(seed)
        let keyed = uint64(combined ^ bitflip)
        return xxh64_avalanche(keyed)
    }

    if len <= 8 {
        let in1 = readLE32(data, 0)
        let in2 = readLE32(data, len - 4)
        let in64 = uint64(in1) | (uint64(in2) << 32)
        let secVal = readLE64(sec, 8) ^ readLE64(sec, 16)
        let keyed = in64 ^ (secVal &+ seed)
        return xxh3_rrmxmx(keyed, uint64(len))
    }

    if len <= 16 {
        let in1 = readLE64(data, 0)
        let in2 = readLE64(data, len - 8)
        let sec1 = readLE64(sec, 24) ^ readLE64(sec, 32)
        let sec2 = readLE64(sec, 40) ^ readLE64(sec, 48)
        let k1 = in1 ^ (sec1 &+ seed)
        let k2 = in2 ^ (sec2 &- seed)
        let (mLo, mHi) = mult64to128(k1, prime64_1)
        let acc = mLo &+ (mHi &* prime64_2) &+ k2
        return xxh3_avalanche(acc)
    }

    if len <= 128 {
        var acc = uint64(len) &* prime64_1
        var off = 0
        var secOff = 0
        while off + 16 <= len {
            acc = acc &+ mix16Bytes(data, off, sec, secOff, seed)
            off += 16
            secOff += 16
        }
        if off < len {
            acc = acc &+ mix16Bytes(data, len - 16, sec, 128 - 16, seed)
        }
        return xxh3_avalanche(acc)
    }

    if len <= 240 {
        var acc = uint64(len) &* prime64_1
        var off = 0
        var secOff = 0
        while off + 32 <= len && secOff + 32 <= sec.count {
            acc = acc &+ mix16Bytes(data, off, sec, secOff, seed)
            acc = acc &+ mix16Bytes(data, off + 16, sec, secOff + 16, seed)
            off += 32
            secOff += 32
        }
        if off < len {
            acc = acc &+ mix16Bytes(data, len - 16, sec, 128 - 16, seed)
        }
        return xxh3_avalanche(acc)
    }

    // Large inputs (> 240 bytes)
    var acc0 = uint64(prime32_3)
    var acc1 = prime64_1
    var acc2 = prime64_2
    var acc3 = prime64_3
    var acc4 = prime64_4
    var acc5 = prime64_5
    var acc6 = prime64_1 &* prime64_2
    var acc7 = prime64_3 &* prime64_4

    var pos = 0
    var secPos = 0
    let nbStripesPerBlock = (sec.count - 64) / 8

    while pos + 64 <= len {
        let in0 = readLE64(data, pos)
        let in1 = readLE64(data, pos + 8)
        let in2 = readLE64(data, pos + 16)
        let in3 = readLE64(data, pos + 24)
        let in4 = readLE64(data, pos + 32)
        let in5 = readLE64(data, pos + 40)
        let in6 = readLE64(data, pos + 48)
        let in7 = readLE64(data, pos + 56)

        acc0 = acc0 &+ (in0 &* readLE64(sec, secPos))
        acc1 = acc1 &+ (in1 &* readLE64(sec, secPos + 8))
        acc2 = acc2 &+ (in2 &* readLE64(sec, secPos + 16))
        acc3 = acc3 &+ (in3 &* readLE64(sec, secPos + 24))
        acc4 = acc4 &+ (in4 &* readLE64(sec, secPos + 32))
        acc5 = acc5 &+ (in5 &* readLE64(sec, secPos + 40))
        acc6 = acc6 &+ (in6 &* readLE64(sec, secPos + 48))
        acc7 = acc7 &+ (in7 &* readLE64(sec, secPos + 56))

        pos += 64
        secPos += 8
        if secPos + 64 > sec.count {
            secPos = 0
        }
    }

    var result = uint64(len) &* prime64_1
    result = result &+ (acc0 ^ acc1) &+ (acc2 ^ acc3) &+ (acc4 ^ acc5) &+ (acc6 ^ acc7)

    if pos < len {
        result = result &+ mix16Bytes(data, len - 16, sec, 128 - 16, seed)
    }

    return xxh3_avalanche(result)
}

/// Computes 64-bit XXH3 hash of a string.
public func Hash64String(s: string, seed: uint64 = 0) -> uint64 {
    return Hash64(stringBytes(s), seed: seed)
}

/// Computes 128-bit XXH3 hash of input data.
public func Hash128(data: [uint8], seed: uint64 = 0) -> (low: uint64, high: uint64) {
    let low = Hash64(data, seed: seed)
    let high = Hash64(data, seed: ~seed &+ prime64_1)
    return (low: low, high: high)
}

/// Computes 128-bit XXH3 hash of a string.
public func Hash128String(s: string, seed: uint64 = 0) -> (low: uint64, high: uint64) {
    return Hash128(stringBytes(s), seed: seed)
}

/// Digest64 provides a streaming 64-bit XXH3 hasher.
public struct Digest64 {
    public var buffer: [uint8]
    public var seed: uint64

    public init(seed: uint64 = 0) {
        self.buffer = []
        self.seed = seed
    }

    public var Size: int { return 8 }
    public var BlockSize: int { return 64 }

    public mutating func Reset() {
        self.buffer = []
    }

    public mutating func Write(data: [uint8]) {
        for b in data {
            self.buffer.append(b)
        }
    }

    public mutating func WriteString(s: string) {
        self.Write(stringBytes(s))
    }

    public func Sum64() -> uint64 {
        return Hash64(self.buffer, seed: self.seed)
    }

    public func Sum(b: [uint8] = []) -> [uint8] {
        var res = b
        let s = self.Sum64()
        res.append(uint8((s >> 56) & 0xFF))
        res.append(uint8((s >> 48) & 0xFF))
        res.append(uint8((s >> 40) & 0xFF))
        res.append(uint8((s >> 32) & 0xFF))
        res.append(uint8((s >> 24) & 0xFF))
        res.append(uint8((s >> 16) & 0xFF))
        res.append(uint8((s >> 8) & 0xFF))
        res.append(uint8(s & 0xFF))
        return res
    }
}

/// Creates a new Digest64 streaming hasher.
public func New64(seed: uint64 = 0) -> Digest64 {
    return Digest64(seed: seed)
}
