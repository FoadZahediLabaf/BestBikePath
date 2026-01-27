import SwiftUI

extension Binding {
    public init<V>(_ base: Binding<V>, default: V) where Value == V? {
        self.init {
            base.wrappedValue
        } set: { value, transaction in
            withTransaction(transaction) {
                base.wrappedValue = value ?? `default`
            }
        }
    }
}
