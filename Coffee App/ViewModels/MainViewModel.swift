import Foundation
import FirebaseAuth

class MainViewModel: ObservableObject {
    @Published var currentUserId: String = ""
    private var handler: AuthStateDidChangeListenerHandle?
    
    init() {
        self.handler = Auth.auth().addStateDidChangeListener { [weak self] _, user in
            DispatchQueue.main.async {
                self?.currentUserId = user?.uid ?? ""
                if user == nil {
                    self?.signInAnonymously()
                }
            }
        }
    }
    
    private func signInAnonymously() {
        Auth.auth().signInAnonymously { [weak self] authResult, error in
            guard let strongSelf = self else { return }
            if let error = error {
                print("Error signing in anonymously: \(error.localizedDescription)")
                return
            }
            DispatchQueue.main.async {
                strongSelf.currentUserId = authResult?.user.uid ?? ""
            }
        }
    }
    
    public var isSignedIn: Bool {
        return Auth.auth().currentUser != nil
    }
}
