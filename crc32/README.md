# hash/crc32

32-bit Cyclic Redundancy Check (IEEE 802.3, Castagnoli / CRC-32C, Koopman)

## Example

```vertex
import "hash/crc32"

print(crc32.ChecksumString("hello"))
```

## Types

- **`Table`** (struct): Table is a 256-word CRC-32 lookup table.
- **`Digest`** (struct): Digest calculates a streaming CRC-32 checksum.

## Functions

- `func New(table: Table = Table.IEEETable) -> Digest`: Creates a new Digest calculating CRC-32 using the provided table.
- `func NewIEEE() -> Digest`: Creates a new Digest calculating CRC-32 using the IEEE polynomial.
- `func NewCastagnoli() -> Digest`: Creates a new Digest calculating CRC-32C using the Castagnoli polynomial.
- `func Update(_ crc: uint32, _ table: Table, _ data: [uint8]) -> uint32`: Update updates the running crc with data using the given table.
- `func Checksum(_ data: [uint8], table: Table = Table.IEEETable) -> uint32`: Checksum returns the CRC-32 checksum of data using the specified table.
- `func ChecksumIEEE(_ data: [uint8]) -> uint32`: ChecksumIEEE returns the CRC-32 checksum of data using the IEEE table.
- `func ChecksumCastagnoli(_ data: [uint8]) -> uint32`: ChecksumCastagnoli returns the CRC-32C checksum of data using the Castagnoli table.
- `func ChecksumString(_ s: string, table: Table = Table.IEEETable) -> uint32`: ChecksumString returns the CRC-32 checksum of a string using the specified table.
- `func ChecksumCastagnoliString(_ s: string) -> uint32`: ChecksumCastagnoliString returns the CRC-32C checksum of a string using Castagnoli table.

Part of the [`hash`](https://github.com/vertex-language/hash) repository.
