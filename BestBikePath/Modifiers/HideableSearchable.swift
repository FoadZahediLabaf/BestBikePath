import SwiftUI

extension View {
   func searchable(text: Binding<String>, isPresented: Binding<Bool>, prompt: Text, isHidden: Bool) -> some View {
       modifier(HideableSearchable(text: text, isPresented: isPresented, prompt: prompt, isHidden: isHidden))
    }
}

struct HideableSearchable: ViewModifier {
    @Binding var text: String
    @Binding var isPresented: Bool
    var prompt: Text
    var isHidden: Bool

    func body(content: Content) -> some View {
        if isHidden {
            content
        } else {
            content.searchable(text: $text, isPresented: $isPresented, placement: .automatic, prompt: prompt)
        }
    }
}
