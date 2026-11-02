package fnv

let offset32: uint32 = 2166136261
let prime32: uint32 = 16777619

let offset64: uint64 = 14695981039346656037
let prime64: uint64 = 1099511628211

func stringBytes(s: string) -> [uint8] {
    var bytes: [uint8] = []
    for b in s.utf8 {
        bytes.append(b)
    }
    return bytes
}

/// Digest32 implements 32-bit FNV-1.
public struct Digest32 {
    public var hash: uint32

    public init() {
        self.hash = offset32
    }

    public var Size: int { return 4 }
    public var BlockSize: int { return 1 }

    public mutating func Reset() {
        self.hash = offset32
    }

    public mutating func Write(data: [uint8]) {
        for b in data {
            self.hash = (self.hash &* prime32) ^ uint32(b)
        }
    }

    public mutating func WriteString(s: string) {
        self.Write(stringBytes(s))
    }

    public func Sum32() -> uint32 {
        return self.hash
    }

    public func Sum(b: [uint8] = []) -> [uint8] {
        var res = b
        let s = self.hash
        res.append(uint8((s >> 24) & 0xFF))
        res.append(uint8((s >> 16) & 0xFF))
        res.append(uint8((s >> 8) & 0xFF))
        res.append(uint8(s & 0xFF))
        return res
    }
}

/// Digest32a implements 32-bit FNV-1a.
public struct Digest32a {
    public var hash: uint32

    public init() {
        self.hash = offset32
    }

    public var Size: int { return 4 }
    public var BlockSize: int { return 1 }

    public mutating func Reset() {
        self.hash = offset32
    }

    public mutating func Write(data: [uint8]) {
        for b in data {
            self.hash = (self.hash ^ uint32(b)) &* prime32
        }
    }

    public mutating func WriteString(s: string) {
        self.Write(stringBytes(s))
    }

    public func Sum32() -> uint32 {
        return self.hash
    }

    public func Sum32a() -> uint32 {
        return self.hash
    }

    public func Sum(b: [uint8] = []) -> [uint8] {
        var res = b
        let s = self.hash
        res.append(uint8((s >> 24) & 0xFF))
        res.append(uint8((s >> 16) & 0xFF))
        res.append(uint8((s >> 8) & 0xFF))
        res.append(uint8(s & 0xFF))
        return res
    }
}

/// Digest64 implements 64-bit FNV-1.
public struct Digest64 {
    public var hash: uint64

    public init() {
        self.hash = offset64
    }

    public var Size: int { return 8 }
    public var BlockSize: int { return 1 }

    public mutating func Reset() {
        self.hash = offset64
    }

    public mutating func Write(data: [uint8]) {
        for b in data {
            self.hash = (self.hash &* prime64) ^ uint64(b)
        }
    }

    public mutating func WriteString(s: string) {
        self.Write(stringBytes(s))
    }

    public func Sum64() -> uint64 {
        return self.hash
    }

    public func Sum(b: [uint8] = []) -> [uint8] {
        var res = b
        let s = self.hash
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

/// Digest64a implements 64-bit FNV-1a.
public struct Digest64a {
    public var hash: uint64

    public init() {
        self.hash = offset64
    }

    public var Size: int { return 8 }
    public var BlockSize: int { return 1 }

    public mutating func Reset() {
        self.hash = offset64
    }

    public mutating func Write(data: [uint8]) {
        for b in data {
            self.hash = (self.hash ^ uint64(b)) &* prime64
        }
    }

    public mutating func WriteString(s: string) {
        self.Write(stringBytes(s))
    }

    public func Sum64() -> uint64 {
        return self.hash
    }

    public func Sum64a() -> uint64 {
        return self.hash
    }

    public func Sum(b: [uint8] = []) -> [uint8] {
        var res = b
        let s = self.hash
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

/// Creates a new Hasher calculating 32-bit FNV-1.
public func New32() -> Digest32 {
    return Digest32()
}

/// Creates a new Hasher calculating 32-bit FNV-1a.
public func New32a() -> Digest32a {
    return Digest32a()
}

/// Creates a new Hasher calculating 64-bit FNV-1.
public func New64() -> Digest64 {
    return Digest64()
}

/// Creates a new Hasher calculating 64-bit FNV-1a.
public func New64a() -> Digest64a {
    return Digest64a()
}

/// Calculates 32-bit FNV-1 hash of data.
public func Sum32(data: [uint8]) -> uint32 {
    var d = Digest32()
    d.Write(data)
    return d.Sum32()
}

/// Calculates 32-bit FNV-1a hash of data.
public func Sum32a(data: [uint8]) -> uint32 {
    var d = Digest32a()
    d.Write(data)
    return d.Sum32a()
}

/// Calculates 64-bit FNV-1 hash of data.
public func Sum64(data: [uint8]) -> uint64 {
    var d = Digest64()
    d.Write(data)
    return d.Sum64()
}

/// Calculates 64-bit FNV-1a hash of data.
public func Sum64a(data: [uint8]) -> uint64 {
    var d = Digest64a()
    d.Write(data)
    return d.Sum64a()
}

/// Calculates 32-bit FNV-1 hash of a string.
public func Sum32String(s: string) -> uint32 {
    return Sum32(stringBytes(s))
}

/// Calculates 32-bit FNV-1a hash of a string.
public func Sum32aString(s: string) -> uint32 {
    return Sum32a(stringBytes(s))
}

/// Calculates 64-bit FNV-1 hash of a string.
public func Sum64String(s: string) -> uint64 {
    return Sum64(stringBytes(s))
}

/// Calculates 64-bit FNV-1a hash of a string.
public func Sum64aString(s: string) -> uint64 {
    return Sum64a(stringBytes(s))
}
