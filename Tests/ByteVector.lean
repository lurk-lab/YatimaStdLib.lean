import LSpec
import YatimaStdLib.ByteVector

open LSpec

def nats : List Nat := [
  0, 1,
  UInt16.size / 2, UInt16.size-2, UInt16.size-1, UInt16.size, UInt16.size+1,
  UInt32.size / 2, UInt32.size-2, UInt32.size-1, UInt32.size, UInt32.size+1,
  UInt64.size / 2, UInt64.size-2, UInt64.size-1, UInt64.size, UInt64.size+1
]

def correct16 (x y : ByteVector 2) : Bool :=
  List.foldr (. && .) true
    [ByteVector.toUInt16 x + ByteVector.toUInt16 y == ByteVector.toUInt16 (x + y),
    ByteVector.toUInt16 x * ByteVector.toUInt16 y == ByteVector.toUInt16 (x * y),
    ByteVector.toUInt16 x - ByteVector.toUInt16 y == ByteVector.toUInt16 (x - y)
    ]

def correct32 (x y : ByteVector 4) : Bool :=
  List.foldr (. && .) true
    [ByteVector.toUInt32 x + ByteVector.toUInt32 y == ByteVector.toUInt32 (x + y),
    ByteVector.toUInt32 x * ByteVector.toUInt32 y == ByteVector.toUInt32 (x * y),
    ByteVector.toUInt32 x - ByteVector.toUInt32 y == ByteVector.toUInt32 (x - y)
    ]

def correct64 (x y : ByteVector 8) : Bool :=
  List.foldr (. && .) true
    [ByteVector.toUInt64 x + ByteVector.toUInt64 y == ByteVector.toUInt64 (x + y),
    ByteVector.toUInt64 x * ByteVector.toUInt64 y == ByteVector.toUInt64 (x * y),
    ByteVector.toUInt64 x - ByteVector.toUInt64 y == ByteVector.toUInt64 (x - y)
    ]

def main := lspecIO $
  nats.foldl (init := .done) fun tSeq n =>
    let u16 : UInt16 := .ofNat n
    let u32 : UInt32 := .ofNat n
    let u64 : UInt64 := .ofNat n
    let x  : ByteVector 2 := ⟨u16.toByteArray, UInt16.toByteArray_size_2⟩
    let y  : ByteVector 4 := ⟨u32.toByteArray, UInt32.toByteArray_size_4⟩
    let z  : ByteVector 8 := ⟨u64.toByteArray, UInt64.toByteArray_size_8⟩
    tSeq ++
      (test s!"{n}₁₆ roundtrips" $ x.toUInt16 == u16) ++
      (test s!"{n}₃₂ roundtrips" $ y.toUInt32 == u32) ++
      (test s!"{n}₆₄ roundtrips" $ z.toUInt64 == u64)
