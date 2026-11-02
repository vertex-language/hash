package adler32

let modAdler: uint32 = 65521
let nmax: int = 5552

func stringBytes(s: string) -> [uint8] {
    var bytes: [uint8] = []
    for b in s.utf8 {
        bytes.append(b)
    }
    return bytes
}

/// Digest calculates a streaming Adler-32 checksum (RFC 1950).
public struct Digest {
    public var s1: uint32
    public var s2: uint32

    public init() {
        self.s1 = 1
        self.s2 = 0
    }

    public var Size: int { return 4 }
    public var BlockSize: int { return 4 }

    public mutating func Reset() {
        self.s1 = 1
        self.s2 = 0
    }

    public mutating func Write(data: [uint8]) {
        let res = Update(self.Sum32(), data)
        self.s1 = res & 0xFFFF
        self.s2 = (res >> 16) & 0xFFFF
    }

    public mutating func WriteString(s: string) {
        self.Write(stringBytes(s))
    }

    public func Sum32() -> uint32 {
        return (self.s2 << 16) | self.s1
    }

    public func Sum(b: [uint8] = []) -> [uint8] {
        var res = b
        let s = self.Sum32()
        res.append(uint8((s >> 24) & 0xFF))
        res.append(uint8((s >> 16) & 0xFF))
        res.append(uint8((s >> 8) & 0xFF))
        res.append(uint8(s & 0xFF))
        return res
    }
}

/// Creates a new streaming Adler-32 Digest.
public func New() -> Digest {
    return Digest()
}

/// Update updates the running Adler-32 checksum with data.
public func Update(d: uint32, data: [uint8]) -> uint32 {
    var s1 = d & 0xFFFF
    var s2 = (d >> 16) & 0xFFFF

    var i = 0
    while i < data.count {
        let chunkEnd = (i + nmax < data.count) ? (i + nmax) : data.count
        while i < chunkEnd {
            s1 += uint32(data[i])
            s2 += s1
            i += 1
        }
        s1 = s1 % modAdler
        s2 = s2 % modAdler
    }

    return (s2 << 16) | s1
}

/// Checksum returns the Adler-32 checksum of data.
public func Checksum(data: [uint8]) -> uint32 {
    return Update(1, data)
}

/// ChecksumString returns the Adler-32 checksum of a string.
public func ChecksumString(s: string) -> uint32 {
    return Checksum(stringBytes(s))
}
