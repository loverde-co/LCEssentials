//  
// Copyright (c) 2023 Loverde Co.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
 


public extension BinaryInteger {
    /// The raw bytes of the integer.
    ///
    ///     var number = Int16(-128)
    ///     print(number.bytes)
    ///     // prints "[255, 128]"
    ///
    var bytes: [UInt8] {
        var result = [UInt8]()
        result.reserveCapacity(MemoryLayout<Self>.size)
        var value = self
        for _ in 0..<MemoryLayout<Self>.size {
            result.append(UInt8(truncatingIfNeeded: value))
            value >>= 8
        }
        return result.reversed()
    }
}

// MARK: - Initializers

public extension BinaryInteger {
    /// Creates a `BinaryInteger` from a raw byte representation.
    ///
    ///     var number = Int16(bytes: [0xFF, 0b1111_1101])
    ///     print(number!)
    ///     // prints "-3"
    ///
    /// - Parameter bytes: An array of bytes representing the value of the integer.
    init?(bytes: [UInt8]) {
        // https://stackoverflow.com/a/43518567/9506784
        precondition(bytes.count <= MemoryLayout<Self>.size,
                     "Integer with a \(bytes.count) byte binary representation of '\(bytes.map { String($0, radix: 2) }.joined(separator: " "))' overflows when stored into a \(MemoryLayout<Self>.size) byte '\(Self.self)'")
        var value: Self = 0
        for byte in bytes {
            value <<= 8
            value |= Self(byte)
        }
        self.init(exactly: value)
    }
}
