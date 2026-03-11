import SwiftUI
import Combine

class NavigationState: ObservableObject {
    @Published var path = NavigationPath()

    func navigate(to route: some Hashable) {
        self.path.append(route)
    }

    func goBack() {
        guard !self.path.isEmpty else { return }
        self.path.removeLast()
    }

    func goHome() {
        self.path = NavigationPath()
    }
}
