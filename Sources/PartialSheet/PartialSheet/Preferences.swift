import SwiftUI

enum ExplicitBox<Value> {
    case `default`
    case explicit(Value)

    var value: Value? {
        guard case .explicit(let value) = self else {
            return nil
        }

        return value
    }

    mutating func reduce(using nextValue: () -> Self) {
        let next = nextValue()
        switch next {
        case .explicit:
            self = next
        case .default:
            break
        }
    }
}

extension ExplicitBox: Equatable where Value: Equatable { }

enum ClippingPreferenceKey: PreferenceKey {
    typealias Value = ExplicitBox<Bool>

    static var defaultValue = ExplicitBox<Bool>.default

    static func reduce(value: inout Value, nextValue: () -> Value) {
        value.reduce(using: nextValue)
    }
}

extension View {
    public func partialSheetClipsContent(_ clipsContent: Bool) -> some View {
        preference(key: ClippingPreferenceKey.self, value: .explicit(clipsContent))
    }
}

enum OverlayInteractionPolicyPreferenceKey: PreferenceKey {
    typealias Value = ExplicitBox<OverlayInteractionPolicy>
    
    static var defaultValue = ExplicitBox<OverlayInteractionPolicy>.default

    static func reduce(value: inout Value, nextValue: () -> Value) {
        value.reduce(using: nextValue)
    }
}

public enum OverlayInteractionPolicy {
    case dismiss
    case none

    static let `default` = dismiss
}

extension View {
    public func partialSheetOverlayInteractionPolicy(
        _ policy: OverlayInteractionPolicy
    ) -> some View {
        preference(
            key: OverlayInteractionPolicyPreferenceKey.self,
            value: .explicit(policy)
        )
    }
}
