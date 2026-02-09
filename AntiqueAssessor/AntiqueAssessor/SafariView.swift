import SwiftUI
import SafariServices

/// SwiftUI wrapper for SFSafariViewController
/// Opens URLs in an in-app Safari browser
struct SafariView: UIViewControllerRepresentable {
    let url: URL
    
    func makeUIViewController(context: Context) -> SFSafariViewController {
        let configuration = SFSafariViewController.Configuration()
        configuration.entersReaderIfAvailable = false
        configuration.barCollapsingEnabled = true
        
        let safariVC = SFSafariViewController(url: url, configuration: configuration)
        safariVC.preferredControlTintColor = .systemBlue
        safariVC.preferredBarTintColor = .systemBackground
        safariVC.dismissButtonStyle = .done
        
        return safariVC
    }
    
    func updateUIViewController(_ uiViewController: SFSafariViewController, context: Context) {
        // No updates needed
    }
}
