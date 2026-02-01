import AsyncButton

extension AsyncButtonOperation{

    var isLoading: Bool {
        if case .loading = self {
            true
        } else {
            false
        }
    }
}
