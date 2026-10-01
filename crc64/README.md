# hash/crc64

64-bit Cyclic Redundancy Check (ISO 3309, ECMA-182)

```vertex
import "hash/crc64"
```

## Types

- **`Table`** (struct): Table is a 256-word CRC-64 lookup table.
- **`Digest`** (struct): Digest calculates a streaming CRC-64 checksum.

## Functions

- `func New(table: Table = Table.ISOTable) -> Digest`: Creates a new Digest calculating CRC-64 using the provided table.
- `func NewISO() -> Digest`: Creates a new Digest calculating CRC-64 using the ISO polynomial.
- `func NewECMA() -> Digest`: Creates a new Digest calculating CRC-64 using the ECMA polynomial.
- `func Update(_ crc: uint64, _ table: Table, _ data: [uint8]) -> uint64`: Update updates the running crc with data using the given table.
- `func Checksum(_ data: [uint8], table: Table = Table.ISOTable) -> uint64`: Checksum returns the CRC-64 checksum of data using the specified table.
- `func ChecksumISO(_ data: [uint8]) -> uint64`: ChecksumISO returns the CRC-64 checksum of data using the ISO table.
- `func ChecksumECMA(_ data: [uint8]) -> uint64`: ChecksumECMA returns the CRC-64 checksum of data using the ECMA table.
- `func ChecksumString(_ s: string, table: Table = Table.ISOTable) -> uint64`: ChecksumString returns the CRC-64 checksum of a string using the specified table.

Part of the [`hash`](https://github.com/vertex-language/hash) repository.
