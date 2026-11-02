package crc64

// ISO 3309 polynomial.
public let ISO: uint64 = 0xD800000000000000

// ECMA-182 polynomial.
public let ECMA: uint64 = 0xC96C5795D7870F42

func stringBytes(s: string) -> [uint8] {
    var bytes: [uint8] = []
    for b in s.utf8 {
        bytes.append(b)
    }
    return bytes
}

/// Table is a 256-word CRC-64 lookup table.
public struct Table {
    public var entries: [uint64]

    public init(entries: [uint64]) {
        self.entries = entries
    }

    /// Makes a 256-word table using the specified polynomial.
    public static func Make(poly: uint64) -> Table {
        var tab = [uint64](repeating: 0, count: 256)
        var i: uint64 = 0
        while i < 256 {
            var c = i
            var j = 0
            while j < 8 {
                if (c & 1) != 0 {
                    c = poly ^ (c >> 1)
                } else {
                    c = c >> 1
                }
                j += 1
            }
            tab[int(i)] = c
            i += 1
        }
        return Table(entries: tab)
    }

    public static let ISOTable: Table = Table.Make(ISO)
    public static let ECMATable: Table = Table.Make(ECMA)
}

/// Digest calculates a streaming CRC-64 checksum.
public struct Digest {
    public var crc: uint64
    public var table: Table

    public init(table: Table = Table.ISOTable) {
        self.crc = 0
        self.table = table
    }

    public var Size: int { return 8 }
    public var BlockSize: int { return 1 }

    public mutating func Reset() {
        self.crc = 0
    }

    public mutating func Write(data: [uint8]) {
        self.crc = Update(self.crc, self.table, data)
    }

    public mutating func WriteString(s: string) {
        self.Write(stringBytes(s))
    }

    public func Sum64() -> uint64 {
        return self.crc
    }

    public func Sum(b: [uint8] = []) -> [uint8] {
        var res = b
        let s = self.crc
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

/// Creates a new Digest calculating CRC-64 using the provided table.
public func New(table: Table = Table.ISOTable) -> Digest {
    return Digest(table: table)
}

/// Creates a new Digest calculating CRC-64 using the ISO polynomial.
public func NewISO() -> Digest {
    return Digest(table: Table.ISOTable)
}

/// Creates a new Digest calculating CRC-64 using the ECMA polynomial.
public func NewECMA() -> Digest {
    return Digest(table: Table.ECMATable)
}

/// Update updates the running crc with data using the given table.
public func Update(crc: uint64, table: Table, data: [uint8]) -> uint64 {
    var c = ~crc
    var i = 0
    while i < data.count {
        let idx = int((c ^ uint64(data[i])) & 0xFF)
        c = table.entries[idx] ^ (c >> 8)
        i += 1
    }
    return ~c
}

/// Checksum returns the CRC-64 checksum of data using the specified table.
public func Checksum(data: [uint8], table: Table = Table.ISOTable) -> uint64 {
    return Update(0, table, data)
}

/// ChecksumISO returns the CRC-64 checksum of data using the ISO table.
public func ChecksumISO(data: [uint8]) -> uint64 {
    return Checksum(data, table: Table.ISOTable)
}

/// ChecksumECMA returns the CRC-64 checksum of data using the ECMA table.
public func ChecksumECMA(data: [uint8]) -> uint64 {
    return Checksum(data, table: Table.ECMATable)
}

/// ChecksumString returns the CRC-64 checksum of a string using the specified table.
public func ChecksumString(s: string, table: Table = Table.ISOTable) -> uint64 {
    return Checksum(stringBytes(s), table: table)
}
