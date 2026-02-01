import SwiftUI
import SwiftUIIntrospect

extension View {
    func safeAreaInsetsSheet<Content: View>(
        isPresented: Binding<Bool>,
        isAppliedToMap: Bool = false,
        onDismiss: (() -> Void)? = nil,
        @ViewBuilder content: @escaping () -> Content
    ) -> some View {
        safeAreaInsetsSheet(
            item: Binding {
                isPresented.wrappedValue ? PresentedItem() : .none
            } set: { item in
                isPresented.wrappedValue = item != nil
            },
            isAppliedToMap: isAppliedToMap,
            onDismiss: onDismiss
        ) { _ in
            content()
        }
    }

    func safeAreaInsetsSheet<Item: Identifiable, Content: View>(
        item: Binding<Item?>,
        isAppliedToMap: Bool = false,
        onDismiss: (() -> Void)? = nil,
        @ViewBuilder content: @escaping (Item) -> Content
    ) -> some View {
        modifier(
            SafeAreaInsetsSheetViewModifier(
                item: item,
                onDismiss: onDismiss,
                sheetContent: content,
                isAppliedToMap: isAppliedToMap
            )
        )
    }
}

private struct PresentedItem: Identifiable {

    let id = true
}

private struct SafeAreaInsetsSheetViewModifier<Item: Identifiable, SheetContent: View>: ViewModifier {

    @Binding var item: Item?

    let onDismiss: (() -> (Void))?

    let sheetContent: (Item) -> SheetContent

    @State private var resolvedItem: Item?

    var interceptedResolvedItem: Binding<Item?> {
        Binding {
            resolvedItem
        } set: { newValue in
            if !coordinator.isSwitching {
                coordinator.isInternallyDismissed = newValue == nil
                item = newValue
            }
        }
    }

    @State private var updatesBottomPaddingOnInitialCoordinatorSet = false

    @State private var updatesBottomPaddingOnNextCoordinatorSet = false

    @State private var coordinator = Coordinator()

    @State private var bottomPadding: CGFloat = 0

    var isAppliedToMap:Bool

    init(item: Binding<Item?>, onDismiss: (() -> Void)?, sheetContent: @escaping (Item) -> SheetContent, isAppliedToMap: Bool) {
        self._item = item
        self.onDismiss = onDismiss
        self.sheetContent = sheetContent
        self._resolvedItem = State(initialValue: item.wrappedValue)
        self.isAppliedToMap = isAppliedToMap
        self._updatesBottomPaddingOnInitialCoordinatorSet = State(initialValue: item.wrappedValue != nil)
    }

    func setNewBottomPaddingIfNeeded(_ newBottomPadding: CGFloat, disablesAnimation: Bool = false) {
        let oldBottomPadding = self.bottomPadding
        guard oldBottomPadding != newBottomPadding else { return }
        let animation: Animation? = (isAppliedToMap && oldBottomPadding > newBottomPadding) ? .none : .default
        withAnimation(disablesAnimation ? .none : animation) {
            bottomPadding = newBottomPadding
        }
    }

    func handleItemIdChange(oldId: Item.ID?, newId: Item.ID?) {
        if oldId == nil, let item {
            coordinator.nextOnDismiss = onDismiss
            resolvedItem = item
            DispatchQueue.main.async {
                guard let sheetPresentationController = coordinator.sheetPresentationController else { return }
                updateBottomPaddingIfNeeded(controller: sheetPresentationController)
            }
        } else if oldId != nil, newId == nil {
            coordinator.nextOnDismiss = onDismiss
            resolvedItem = nil
            setNewBottomPaddingIfNeeded(0)
        } else if oldId != nil, oldId != newId, let item {
            if coordinator.isInternallyDismissed {
                coordinator.nextOnDismiss = onDismiss
                resolvedItem = item
                updatesBottomPaddingOnNextCoordinatorSet = true
            } else {
                coordinator.isSwitching = true
                coordinator.nextOnDismiss = {
                    coordinator.nextOnDismiss = onDismiss
                    resolvedItem = item
                    coordinator.isSwitching = false
                    updatesBottomPaddingOnNextCoordinatorSet = true
                }
                resolvedItem = nil
            }
        }
        coordinator.isInternallyDismissed = false
    }

    func resolvedOnDismiss() {
        coordinator.nextOnDismiss?()
    }

    func body(content: Content) -> some View {
        VStack {
            content
        }
        .onChange(of: item?.id, initial: true, handleItemIdChange)
        .safeAreaPadding(.bottom, bottomPadding)
        .sheet(item: interceptedResolvedItem, onDismiss: resolvedOnDismiss) { item in
            sheetContent(item)
                .introspect(.sheet, on: .iOS(.v18, .v26)) { (presentationController: UIPresentationController) in
                    guard let presentationController = presentationController as? UISheetPresentationController else {
                        return
                    }
                    coordinator.sheetPresentationController = presentationController
                    coordinator.onSelectedDetentIdentifierChange = { controller in updateBottomPaddingIfNeeded(controller: controller)
                    }
                    presentationController.delegate = coordinator
                    if updatesBottomPaddingOnNextCoordinatorSet {
                        updatesBottomPaddingOnNextCoordinatorSet = false
                        updateBottomPaddingIfNeeded(controller: presentationController)
                    }

                    if updatesBottomPaddingOnInitialCoordinatorSet {
                        updatesBottomPaddingOnInitialCoordinatorSet = false
                        updateBottomPaddingIfNeeded(controller: presentationController, disablesAnimation: true)
                    }
                }
        }
    }

    func updateBottomPaddingIfNeeded(controller: UISheetPresentationController, disablesAnimation: Bool = false) {
        DispatchQueue.main.async {
            guard
                let presentedView = controller.presentedView,
                let containerView = controller.containerView// ?? containerView
            else {
                return
            }

            let resolutionContext = DetentResolutionContext(
                containerTraitCollection: controller.traitCollection,
                maximumDetentValue: containerView.bounds.height,
                containerBounds: containerView.bounds
            )
            let sortedDetents = controller.detents.sorted {
                $0.resolvedValue(in: resolutionContext) ?? 0 < $1.resolvedValue(in: resolutionContext) ?? 0
            }

            guard let largestUndimmedDetentIdentifier = controller.largestUndimmedDetentIdentifier else {
                setNewBottomPaddingIfNeeded(0, disablesAnimation: disablesAnimation)
                return
            }

            guard
                let largestUndimmedDetent = controller.detents.first(where: { $0.identifier == largestUndimmedDetentIdentifier }),
                let largestUndimmedDetentHeight = largestUndimmedDetent.resolvedValue(in: resolutionContext),
                let selectedDetentIdentifier = controller.selectedDetentIdentifier ?? sortedDetents.first?.identifier,
                let selectedDetent = controller.detents.first(where: { $0.identifier == selectedDetentIdentifier }),
                let selectedDetentHeight = selectedDetent.resolvedValue(in: resolutionContext),
                selectedDetentHeight <= largestUndimmedDetentHeight
            else {
                return
            }

            let height = containerView.frame.maxY - presentedView.frame.minY
            let newBottomPadding = max(0, height - containerView.safeAreaInsets.bottom)
            setNewBottomPaddingIfNeeded(newBottomPadding, disablesAnimation: disablesAnimation)
        }
    }
}

private class DetentResolutionContext: NSObject, UISheetPresentationControllerDetentResolutionContext {
    let containerTraitCollection: UITraitCollection
    let maximumDetentValue: CGFloat
    let containerBounds: CGRect

    init(containerTraitCollection: UITraitCollection, maximumDetentValue: CGFloat, containerBounds: CGRect) {
        self.containerTraitCollection = containerTraitCollection
        self.maximumDetentValue = maximumDetentValue
        self.containerBounds = containerBounds
    }

    @objc var _containerBounds: CGRect {
        CGRect(
            x: containerBounds.origin.x,
            y: containerBounds.origin.y,
            width: containerBounds.width,
            height: containerBounds.height
        )
    }
}

private class Coordinator: NSObject, UISheetPresentationControllerDelegate {

    var sheetPresentationController: UISheetPresentationController?

    var onSelectedDetentIdentifierChange: (UISheetPresentationController) -> Void = { _ in }

    var isSwitching: Bool = false

    var isInternallyDismissed: Bool = false

    var nextOnDismiss: (() -> (Void))?

    func sheetPresentationControllerDidChangeSelectedDetentIdentifier(_ sheetPresentationController: UISheetPresentationController) {
        onSelectedDetentIdentifierChange(sheetPresentationController)
    }
}

private struct Item: Identifiable, Hashable {
    let id: Int

    static let a = Item(id: 0)
    static let b = Item(id: 1)
}

#Preview {
    @Previewable @State var isTestSheetPresented = false
    @Previewable @State var isTestSheetBPresented = false
    @Previewable @State var testSheetItem: Item? = .a

    VStack {
        Button("Show sheet") {
            testSheetItem = .a
        }
        .buttonStyle(.borderedProminent)
        .controlSize(.extraLarge)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)

        Text("____TEST____" as String)
            .font(.largeTitle.bold())
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
            .scenePadding()
    }
    .background(.teal)
    .safeAreaInsetsSheet(item: $testSheetItem) { item in
        if item == .a {
            Button("Show sheet B") {
                testSheetItem = .b
            }
            .presentationDetents([.fraction(0.4),.fraction(0.6),.fraction(0.8), .large])
            .presentationBackgroundInteraction(.enabled(upThrough: .fraction(0.8)))
        } else {
            Text("TestB")
                .presentationDetents([.medium, .large])
        }
    }
}
