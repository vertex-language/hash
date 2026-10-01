# hash/xxh3

Modern ultra-fast non-cryptographic hash (64-bit and 128-bit)

```vertex
import "hash/xxh3"
```

## Types

- **`Digest64`** (struct): Digest64 provides a streaming 64-bit XXH3 hasher.

## Functions

- `func Hash64(_ data: [uint8], seed: uint64 = 0) -> uint64`: Computes 64-bit XXH3 hash of input data.
- `func Hash64String(_ s: string, seed: uint64 = 0) -> uint64`: Computes 64-bit XXH3 hash of a string.
- `func Hash128(_ data: [uint8], seed: uint64 = 0) -> (low: uint64, high: uint64)`: Computes 128-bit XXH3 hash of input data.
- `func Hash128String(_ s: string, seed: uint64 = 0) -> (low: uint64, high: uint64)`: Computes 128-bit XXH3 hash of a string.
- `func New64(seed: uint64 = 0) -> Digest64`: Creates a new Digest64 streaming hasher.

Part of the [`hash`](https://github.com/vertex-language/hash) repository.
