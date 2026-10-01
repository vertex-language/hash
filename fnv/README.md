# hash/fnv

Fowler-Noll-Vo hash functions (FNV-1 and FNV-1a, 32-bit & 64-bit)

```vertex
import "hash/fnv"
```

## Types

- **`Digest32`** (struct): Digest32 implements 32-bit FNV-1.
- **`Digest32a`** (struct): Digest32a implements 32-bit FNV-1a.
- **`Digest64`** (struct): Digest64 implements 64-bit FNV-1.
- **`Digest64a`** (struct): Digest64a implements 64-bit FNV-1a.

## Functions

- `func New32() -> Digest32`: Creates a new Hasher calculating 32-bit FNV-1.
- `func New32a() -> Digest32a`: Creates a new Hasher calculating 32-bit FNV-1a.
- `func New64() -> Digest64`: Creates a new Hasher calculating 64-bit FNV-1.
- `func New64a() -> Digest64a`: Creates a new Hasher calculating 64-bit FNV-1a.
- `func Sum32(_ data: [uint8]) -> uint32`: Calculates 32-bit FNV-1 hash of data.
- `func Sum32a(_ data: [uint8]) -> uint32`: Calculates 32-bit FNV-1a hash of data.
- `func Sum64(_ data: [uint8]) -> uint64`: Calculates 64-bit FNV-1 hash of data.
- `func Sum64a(_ data: [uint8]) -> uint64`: Calculates 64-bit FNV-1a hash of data.
- `func Sum32String(_ s: string) -> uint32`: Calculates 32-bit FNV-1 hash of a string.
- `func Sum32aString(_ s: string) -> uint32`: Calculates 32-bit FNV-1a hash of a string.
- and 2 more

Part of the [`hash`](https://github.com/vertex-language/hash) repository.
