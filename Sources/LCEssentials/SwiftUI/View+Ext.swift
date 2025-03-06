//  
// Copyright (c) 2025 Loverde Co.
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
 

import SwiftUI

extension View {
    func getTag<TagType: Hashable>() throws -> TagType {
        // Mirror this view
        let mirror = Mirror(reflecting: self)

        // Get tag modifier
        guard let realTag = mirror.descendant("modifier", "value") else {
            // Not found tag modifier here, this could be composite
            // view. Check for modifier directly on the `body` if
            // not a primitive view type.
            guard Body.self != Never.self else {
                throw TagError.notFound
            }
            return try body.getTag()
        }

        // Bind memory to extract tag's value
        let fakeTag = try withUnsafeBytes(of: realTag) { ptr -> FakeTag<TagType> in
            let binded = ptr.bindMemory(to: FakeTag<TagType>.self)
            guard let mapped = binded.first else {
                throw TagError.other
            }
            return mapped
        }

        // Return tag's value
        return fakeTag.value
    }

    func extractTag<TagType: Hashable>(_ closure: (() throws -> TagType) -> Void) -> Self {
        closure(getTag)
        return self
    }
}

enum TagError: Error, CustomStringConvertible {
    case notFound
    case other

    public var description: String {
        switch self {
        case .notFound: return "Not found"
        case .other: return "Other"
        }
    }
}

enum FakeTag<TagType: Hashable> {
    case tagged(TagType)

    var value: TagType {
        switch self {
        case let .tagged(value): return value
        }
    }
}
