import SwiftUI

enum ClippingPreferenceKey: PreferenceKey {
    enum Value: Equatable {
        case `default`
        case explicit(Bool)

        var isClipping: Bool {
            switch self {
            case .default:
                return true

            case .explicit(let value):
                return value
            }
        }
    }

    static var defaultValue = Value.default

    static func reduce(value: inout Value, nextValue: () -> Value) {
        let next = nextValue()
        switch next {
        case .explicit:
            value = next
        case .default:
            break
        }
    }
}

extension View {
    public func partialSheetClipsContent(_ clipsContent: Bool) -> some View {
        preference(key: ClippingPreferenceKey.self, value: .explicit(clipsContent))
    }
}
