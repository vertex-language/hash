# hash/adler32

Adler-32 rolling checksum (RFC 1950)

```vertex
import "hash/adler32"
```

## Types

- **`Digest`** (struct): Digest calculates a streaming Adler-32 checksum (RFC 1950).

## Functions

- `func New() -> Digest`: Creates a new streaming Adler-32 Digest.
- `func Update(_ d: uint32, _ data: [uint8]) -> uint32`: Update updates the running Adler-32 checksum with data.
- `func Checksum(_ data: [uint8]) -> uint32`: Checksum returns the Adler-32 checksum of data.
- `func ChecksumString(_ s: string) -> uint32`: ChecksumString returns the Adler-32 checksum of a string.

Part of the [`hash`](https://github.com/vertex-language/hash) repository.
