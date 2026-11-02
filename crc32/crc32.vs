package crc32

// IEEE 802.3 polynomial (Ethernet, gzip, PNG, STUN, etc.).
public let IEEE: uint32 = 0xEDB88320

// Castagnoli polynomial (CRC-32C, RFC 3309 / RFC 4960, used by SCTP, iSCSI, ext4, Btrfs).
public let Castagnoli: uint32 = 0x82F63B78

// Koopman polynomial.
public let Koopman: uint32 = 0xEB31D82E

func stringBytes(s: string) -> [uint8] {
    var bytes: [uint8] = []
    for b in s.utf8 {
        bytes.append(b)
    }
    return bytes
}

/// Table is a 256-word CRC-32 lookup table.
public struct Table {
    public var entries: [uint32]

    public init(entries: [uint32]) {
        self.entries = entries
    }

    /// Makes a 256-word table using the specified polynomial.
    public static func Make(poly: uint32) -> Table {
        var tab = [uint32](repeating: 0, count: 256)
        var i: uint32 = 0
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

    public static let IEEETable: Table = Table.Make(IEEE)
    public static let CastagnoliTable: Table = Table.Make(Castagnoli)
    public static let KoopmanTable: Table = Table.Make(Koopman)
}

/// Digest calculates a streaming CRC-32 checksum.
public struct Digest {
    public var crc: uint32
    public var table: Table

    public init(table: Table = Table.IEEETable) {
        self.crc = 0
        self.table = table
    }

    public var Size: int { return 4 }
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

    public func Sum32() -> uint32 {
        return self.crc
    }

    public func Sum(b: [uint8] = []) -> [uint8] {
        var res = b
        let s = self.crc
        res.append(uint8((s >> 24) & 0xFF))
        res.append(uint8((s >> 16) & 0xFF))
        res.append(uint8((s >> 8) & 0xFF))
        res.append(uint8(s & 0xFF))
        return res
    }
}

/// Creates a new Digest calculating CRC-32 using the provided table.
public func New(table: Table = Table.IEEETable) -> Digest {
    return Digest(table: table)
}

/// Creates a new Digest calculating CRC-32 using the IEEE polynomial.
public func NewIEEE() -> Digest {
    return Digest(table: Table.IEEETable)
}

/// Creates a new Digest calculating CRC-32C using the Castagnoli polynomial.
public func NewCastagnoli() -> Digest {
    return Digest(table: Table.CastagnoliTable)
}

/// Update updates the running crc with data using the given table.
public func Update(crc: uint32, table: Table, data: [uint8]) -> uint32 {
    var c = ~crc
    var i = 0
    while i < data.count {
        let idx = int((c ^ uint32(data[i])) & 0xFF)
        c = table.entries[idx] ^ (c >> 8)
        i += 1
    }
    return ~c
}

/// Checksum returns the CRC-32 checksum of data using the specified table.
public func Checksum(data: [uint8], table: Table = Table.IEEETable) -> uint32 {
    return Update(0, table, data)
}

/// ChecksumIEEE returns the CRC-32 checksum of data using the IEEE table.
public func ChecksumIEEE(data: [uint8]) -> uint32 {
    return Checksum(data, table: Table.IEEETable)
}

/// ChecksumCastagnoli returns the CRC-32C checksum of data using the Castagnoli table.
public func ChecksumCastagnoli(data: [uint8]) -> uint32 {
    return Checksum(data, table: Table.CastagnoliTable)
}

/// ChecksumString returns the CRC-32 checksum of a string using the specified table.
public func ChecksumString(s: string, table: Table = Table.IEEETable) -> uint32 {
    return Checksum(stringBytes(s), table: table)
}

/// ChecksumCastagnoliString returns the CRC-32C checksum of a string using Castagnoli table.
public func ChecksumCastagnoliString(s: string) -> uint32 {
    return Checksum(stringBytes(s), table: Table.CastagnoliTable)
}
