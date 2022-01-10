// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 09/03/21.
//  All code (c) 2021 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

#if canImport(SwiftUI)
#if canImport(UIKit)

import SwiftUI

public typealias BarcodeCallback = (String) -> ()

/// SwiftUI View which wraps a CaptureUIViewController.
/// Could easily be adapted to work with an AppKit variant too.
///
/// Accepts a callback block which it calls whenever a barcode
/// has been detected.

public struct CaptureView : UIViewControllerRepresentable {
    let callback: BarcodeCallback

    public init(callback: @escaping BarcodeCallback) {
        self.callback = callback
    }
    
    public func makeUIViewController(context: UIViewControllerRepresentableContext<CaptureView>) -> CaptureUIViewController {
        let controller = CaptureUIViewController()
        controller.callback = callback
        return controller
    }
    
    public func updateUIViewController(_ uiViewController: CaptureUIViewController, context: UIViewControllerRepresentableContext<CaptureView>) {
        
    }
    
    public static func dismantleUIViewController(_ uiViewController: CaptureUIViewController, coordinator: ()) {
        uiViewController.cleanup()
    }
}

#endif
#endif
