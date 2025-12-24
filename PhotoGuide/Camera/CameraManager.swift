//
//  CameraManager.swift
//  PhotoGuide
//
//  Created by Daniel PHAM-LE-THANH on 10/12/2025.
//

import AVFoundation
import UIKit
import Photos

final class CameraManager: NSObject, ObservableObject {

    // MARK: - Public API
    let session = AVCaptureSession()

    /// Dernière photo capturée (pour thumbnail / preview)
    @Published var capturedImage: UIImage?

    /// Ratio réel du flux caméra (capteur / format actif) -> utilisé pour caler les overlays
    @Published var videoAspectRatio: CGFloat = 4.0 / 3.0

    // MARK: - Private
    private let sessionQueue = DispatchQueue(label: "camera.session.queue")
    private var photoOutput = AVCapturePhotoOutput()

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
            AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
                guard let self else { return }
                if granted {
                    self.setupSession()
                } else {
                    print("❌ Caméra non autorisée (user denied)")
                }
            }

        default:
            print("❌ Caméra non autorisée")
        }
    }

    // MARK: - Setup
    private func setupSession() {
        sessionQueue.async { [weak self] in
            guard let self else { return }

            self.session.beginConfiguration()
            self.session.sessionPreset = .photo

            // Device
            guard let device = AVCaptureDevice.default(.builtInWideAngleCamera,
                                                      for: .video,
                                                      position: .back)
            else {
                print("❌ Impossible d’obtenir la caméra arrière")
                self.session.commitConfiguration()
                return
            }

            // ✅ IMPORTANT : on calcule le ratio APRÈS avoir device
            self.updateVideoAspectRatio(from: device)

            // Input
            do {
                let input = try AVCaptureDeviceInput(device: device)
                if self.session.canAddInput(input) {
                    self.session.addInput(input)
                } else {
                    print("❌ Impossible d'ajouter l'input caméra")
                    self.session.commitConfiguration()
                    return
                }
            } catch {
                print("❌ Échec création input caméra: \(error)")
                self.session.commitConfiguration()
                return
            }

            // Output
            if self.session.canAddOutput(self.photoOutput) {
                self.session.addOutput(self.photoOutput)
            } else {
                print("❌ Impossible d'ajouter AVCapturePhotoOutput")
                self.session.commitConfiguration()
                return
            }

            self.session.commitConfiguration()
            self.session.startRunning()
        }
    }

    /// ✅ Calcule le ratio du format actif (dims width/height)
    private func updateVideoAspectRatio(from device: AVCaptureDevice) {
        let formatDesc = device.activeFormat.formatDescription
        let dims = CMVideoFormatDescriptionGetDimensions(formatDesc)

        // Sécurise : éviter division par zéro
        guard dims.height != 0 else { return }

        let ratio = CGFloat(dims.width) / CGFloat(dims.height)

        DispatchQueue.main.async { [weak self] in
            self?.videoAspectRatio = ratio
        }
    }

    // MARK: - Save
    func saveToPhotoLibrary(_ image: UIImage) {
        PHPhotoLibrary.requestAuthorization { status in
            guard status == .authorized || status == .limited else { return }

            PHPhotoLibrary.shared().performChanges {
                PHAssetChangeRequest.creationRequestForAsset(from: image)
            }
        }
    }

    // MARK: - Capture
    func takePhoto() {
        let settings = AVCapturePhotoSettings()
        photoOutput.capturePhoto(with: settings, delegate: self)
    }
}

// MARK: - Photo Delegate
extension CameraManager: AVCapturePhotoCaptureDelegate {

    func photoOutput(_ output: AVCapturePhotoOutput,
                     didFinishProcessingPhoto photo: AVCapturePhoto,
                     error: Error?) {

        if let error {
            print("❌ Erreur capture photo: \(error)")
            return
        }

        guard let data = photo.fileDataRepresentation(),
              let image = UIImage(data: data)
        else { return }

        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            self.capturedImage = image
            self.saveToPhotoLibrary(image)
        }
    }
}
