//
//  CameraManager.swift
//  PhotoGuide
//
//  Created by Daniel PHAM-LE-THANH on 10/12/2025.
//

import AVFoundation
import UIKit
import Photos

class CameraManager: NSObject, ObservableObject {

    // MARK: - Public API
    let session = AVCaptureSession()

    @Published var capturedImage: UIImage?

    private let sessionQueue = DispatchQueue(label: "camera.session.queue")

    override init() {
        super.init()
        checkPermission()
    }

    // MARK: - Permissions
    private func checkPermission() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            setupSession()

        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                if granted { self.setupSession() }
            }

        default:
            print("❌ Caméra non autorisée")
        }
    }

    // MARK: - Setup
    private func setupSession() {
        sessionQueue.async {

            self.session.beginConfiguration()
            self.session.sessionPreset = .photo

            guard let device = AVCaptureDevice.default(.builtInWideAngleCamera,
                                                       for: .video,
                                                       position: .back)
            else {
                print("❌ Impossible d’obtenir la caméra arrière")
                self.session.commitConfiguration()
                return
            }

            // Input
            guard let input = try? AVCaptureDeviceInput(device: device) else {
                print("❌ Échec création input caméra")
                self.session.commitConfiguration()
                return
            }
            if self.session.canAddInput(input) {
                self.session.addInput(input)
            }

            // Output
            let output = AVCapturePhotoOutput()
            if self.session.canAddOutput(output) {
                self.session.addOutput(output)
            }

            self.session.commitConfiguration()

            self.session.startRunning()
        }
    }

    // MARK: - Save
    func saveToPhotoLibrary(_ image: UIImage) {
        PHPhotoLibrary.requestAuthorization { status in
            guard status == .authorized || status == .limited else { return }

            PHPhotoLibrary.shared().performChanges({
                PHAssetChangeRequest.creationRequestForAsset(from: image)
            })
        }
    }

    // MARK: - Capture
    func takePhoto() {
        guard let output = session.outputs.first as? AVCapturePhotoOutput else { return }

        let settings = AVCapturePhotoSettings()
        output.capturePhoto(with: settings, delegate: self)
    }
}

    // MARK: - Photo Delegate
    extension CameraManager: AVCapturePhotoCaptureDelegate {

    func photoOutput(_ output: AVCapturePhotoOutput,
                     didFinishProcessingPhoto photo: AVCapturePhoto,
                     error: Error?) {

        guard let data = photo.fileDataRepresentation(),
              let image = UIImage(data: data) else { return }

        DispatchQueue.main.async {
            self.capturedImage = image
            self.saveToPhotoLibrary(image)
        }
    }
}
