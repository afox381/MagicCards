import Foundation

enum AsyncState<T> {
    case inactive
    case loading
    case success(T)
    case failure(Error)
}

enum AsyncEquatableState<T> where T: Equatable {
    case inactive
    case loading
    case success(T)
    case failure(Error)
}

extension AsyncEquatableState: Equatable {
    static func == (lhs: AsyncEquatableState<T>, rhs: AsyncEquatableState<T>) -> Bool {
        switch (lhs, rhs) {
        case (.loading, .loading), (.inactive, .inactive):
            return true
        case let (.success(lhsValue), .success(rhsValue)):
            return lhsValue == rhsValue
        case let (.failure(lhsError), .failure(rhsError)):
            return lhsError.localizedDescription == rhsError.localizedDescription
        default:
            return false
        }
    }
}
