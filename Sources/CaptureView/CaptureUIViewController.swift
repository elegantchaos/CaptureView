// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 09/03/21.
//  All code (c) 2021 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

#if canImport(UIKit)

import UIKit

/// A UIKit-specific view controller which embeds a CaptureController,
/// and acts as the delegate for it.
///
/// Accepts a callback block which it calls whenever a barcode
/// has been detected.

public final class CaptureUIViewController: UIViewController {
    var captureController: CaptureController?
    var callback: BarcodeCallback?
    var captureLayer: CALayer?
    
    public override func loadView() {
        captureController = CaptureController(delegate: self)
        
        if captureController == nil {
            print("Couldn't get capture controller.")
        }

        view = UIView()
        view.backgroundColor = .lightGray
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        captureController?.run()
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        captureLayer?.removeFromSuperlayer()
        captureLayer = nil
        captureController?.shutdown()
        super.viewWillDisappear(animated)
    }
    
    public override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        resizeCaptureLayer()
    }
    
    func resizeCaptureLayer() {
        captureLayer?.frame = CGRect(origin: .zero, size: view.frame.size)
    }
}

extension CaptureUIViewController: CaptureDelegate {
    func detected(barcode: String) {
        callback?(barcode)
    }
    
    func attach(layer: CALayer) {
        layer.anchorPoint = .zero
        layer.position = .zero
        view.layer.addSublayer(layer)

        captureLayer = layer
        resizeCaptureLayer()
    }
}

#endif
