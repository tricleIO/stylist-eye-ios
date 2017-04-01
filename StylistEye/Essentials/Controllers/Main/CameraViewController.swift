    //
//  CameraViewController.swift
//  StylistEye
//
//  Created by Michal Severín on 16.10.16.
//  Copyright © 2016 Michal Severín. All rights reserved.
//

import SnapKit
import UIKit
import AVFoundation
    
typealias CameraPickerHandler = ( (UIImage, (() -> Void) ) -> Void )

class CameraViewController: AbstractViewController, AVCaptureMetadataOutputObjectsDelegate {

    // MARK: - Properties
  
    var imagePicked: CameraPickerHandler?
  
    // MARK: < private
    fileprivate lazy var leftBarButton: UIBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "cross_icon").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(closeButtonTapped))
    fileprivate lazy var rightBarbutton: UIBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "torch_icon").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(torchButtonTapped))

    fileprivate let captureSession = AVCaptureSession()
    fileprivate let qrCodeFrameView = UIView()
    fileprivate let videoPreviewLayer = AVCaptureVideoPreviewLayer()
    fileprivate let stillImageOutput = AVCaptureStillImageOutput()

    fileprivate let actionBox = View()

    fileprivate let captureButton = Button(type: .system)

    // MARK: - Life cycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        captureSession.startRunning()
    }

    override func addElements() {
        super.addElements()

        view.addSubview(actionBox)
        actionBox.addSubview(captureButton)
    }

    internal override func initializeElements() {
        super.initializeElements()

        actionBox.backgroundColor = Palette[custom: .purple]

        stillImageOutput.outputSettings = [AVVideoCodecKey:AVVideoCodecJPEG]

        captureButton.addTarget(self, action: #selector(captureButtonTapped), for: .touchUpInside)
        captureButton.setImage(#imageLiteral(resourceName: "eclipse_icon").withRenderingMode(.alwaysOriginal), for: .normal)

        navigationItem.leftBarButtonItem = leftBarButton
        navigationItem.rightBarButtonItem = rightBarbutton

        setQRCamera()
    }
    
    override func setupBackgroundImage() {
    }

    override func setupConstraints() {
        super.setupConstraints()

        videoPreviewLayer.frame = view.bounds

        actionBox.snp.makeConstraints { make in
            make.leading.equalTo(view)
            make.trailing.equalTo(view)
            make.height.equalTo(50)
            make.bottom.equalTo(view)
        }

        captureButton.snp.makeConstraints { make in
            make.centerX.equalTo(actionBox)
            make.centerY.equalTo(actionBox)
            make.width.equalTo(45)
            make.height.equalTo(45)
        }
    }

    // MARK: - User action
    func closeButtonTapped() {
        dismiss(animated: true, completion: nil)
    }

    func captureButtonTapped() {
        captureImage()
    }

    func torchButtonTapped() {
        fireUpFlash()
    }

    // MARK: - Actions
    fileprivate func fireUpFlash() {
        if let device = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo) {
            if (device.hasFlash) {
                do {
                    try device.lockForConfiguration()
                    if device.flashMode == .on {
                        device.flashMode = .off
                    }
                    else {
                        device.flashMode = .on
                    }
                    device.unlockForConfiguration()
                }
                catch {}
            }
        }
    }

    fileprivate func captureImage() {
        if let videoConnection = stillImageOutput.connection(withMediaType: AVMediaTypeVideo) {
            stillImageOutput.captureStillImageAsynchronously(from: videoConnection) { sampleBuffer, error -> Void in
                if let _ = sampleBuffer {
                    if let imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(sampleBuffer) {
                        if let dataProvider = CGDataProvider(data: imageData as CFData) {
                            if let cgImageRef = CGImage(jpegDataProviderSource: dataProvider, decode: nil, shouldInterpolate: true, intent: .defaultIntent) {
                                let image = UIImage(cgImage: cgImageRef, scale: 1.0, orientation: .right)
                                let imageVC = CaptureImageViewController()
                                imageVC.capturedImage = image
                                imageVC.imagePicked = self.imagePicked
                                self.navigationController?.pushViewController(imageVC, animated: true)
                            }
                        }
                    }
                }
            }
        }
    }

    fileprivate func setQRCamera() {
        let captureDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)

        do {
            let input = try AVCaptureDeviceInput(device: captureDevice) as AVCaptureDeviceInput
            captureSession.addInput(input as AVCaptureInput)
            if captureSession.canAddOutput(stillImageOutput) {
                captureSession.addOutput(stillImageOutput)
            }
        }
        catch {
            // TODO: @MS
        }
      
        videoPreviewLayer.session = captureSession
        videoPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        videoPreviewLayer.frame = view.layer.bounds
        backgroundImage.layer.addSublayer(videoPreviewLayer)
    }
}
