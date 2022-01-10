// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 04/03/2019.
//  All code (c) 2019 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import Foundation
import AVFoundation
import Vision

protocol CaptureDelegate: AnyObject {
    func detected(barcode: String)
    func attach(layer: CALayer)
}

/// Controller which manages an AVCaptureSession.
/// Currently this session is dedicated to scanning for barcodes, but it could be broadened
/// out to perform other capture-related work.
///
/// The controller is implemented at the Core Animation level, so it's not tied to UIKit or AppKit.
/// It uses a delegate to pass a CALayer which the user interface code should then embed in a view.

public final class CaptureController: NSObject, AVCaptureVideoDataOutputSampleBufferDelegate {
    let session: AVCaptureSession
    let device: AVCaptureDevice
    weak var delegate: CaptureDelegate?
    
    var requests = [VNRequest]()
    
    init?(delegate: CaptureDelegate? = nil) {
        
        guard let device = AVCaptureDevice.default(for: AVMediaType.video) else {
            return nil
        }
        
        self.delegate = delegate
        self.session = AVCaptureSession()
        self.device = device
    }
    
    func run() {
        setupVideo()
        startDetection()
    }
    
    func shutdown() {
        session.stopRunning()
        session.inputs.forEach { session.removeInput($0) }
        session.outputs.forEach{ session.removeOutput($0) }
        requests.removeAll()
        delegate = nil
    }
    
    fileprivate func setupVideo() {
        session.sessionPreset = AVCaptureSession.Preset.photo
        let deviceInput = try! AVCaptureDeviceInput(device: device)
        
        let deviceOutput = AVCaptureVideoDataOutput()
        deviceOutput.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String: Int(kCVPixelFormatType_32BGRA)]
        deviceOutput.setSampleBufferDelegate(self, queue: DispatchQueue.global(qos: DispatchQoS.QoSClass.default))
        
        session.addInput(deviceInput)
        session.addOutput(deviceOutput)
        let imageLayer = AVCaptureVideoPreviewLayer(session: session)
        imageLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        delegate?.attach(layer: imageLayer)
        session.startRunning()
    }
    
    func startDetection() {
        weak var delegate = self.delegate
        let request = VNDetectBarcodesRequest(completionHandler: { (request: VNRequest, error: Error?) in
            if let observations = request.results {
                let barcodes = observations.compactMap({ ($0 as? VNBarcodeObservation)?.payloadStringValue })
                for barcode in barcodes {
                    delegate?.detected(barcode: barcode)
                }
            }
        })
        
        request.symbologies = [.EAN13]
        self.requests = [request]
    }
    
    public func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            return
        }
        var requestOptions:[VNImageOption:Any] = [:]
        if let camData = CMGetAttachment(sampleBuffer, key: kCMSampleBufferAttachmentKey_CameraIntrinsicMatrix, attachmentModeOut: nil) {
            requestOptions = [.cameraIntrinsics:camData]
        }
        let imageRequestHandler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, orientation: CGImagePropertyOrientation(rawValue: 6)!, options: requestOptions)
        do {
            try imageRequestHandler.perform(self.requests)
        } catch {
            print(error)
        }
    }
}
