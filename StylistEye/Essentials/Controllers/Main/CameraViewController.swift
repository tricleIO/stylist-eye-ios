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
    
typealias CameraPickerHandler = ( (UIImage) -> Void )

class CameraViewController: AbstractViewController, AVCaptureMetadataOutputObjectsDelegate {

    // MARK: - Properties
  
    var imagePicked: CameraPickerHandler?
  
    // MARK: < private
    fileprivate lazy var leftBarButton: UIBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "cross_icon").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(closeButtonTapped))
    fileprivate lazy var rightBarbutton: UIBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "torch_off"), style: .plain, target: self, action: #selector(torchButtonTapped))
    fileprivate lazy var rotateCameraButton = UIButton(type: .custom)

    fileprivate var captureSession = AVCaptureSession()
    fileprivate let qrCodeFrameView = UIView()
    fileprivate let videoPreviewLayer = AVCaptureVideoPreviewLayer()
    fileprivate let stillImageOutput = AVCaptureStillImageOutput()

    fileprivate let videoView = UIView()
    fileprivate let actionBox = View()

    fileprivate let captureButton = Button(type: .system)
    
    fileprivate var cameraDirection = AVCaptureDevicePosition.back
    
    // MARK: - Life cycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        captureSession.startRunning()
    }

    override func addElements() {
        super.addElements()

        view.addSubview(videoView)
        view.addSubview(actionBox)
        actionBox.addSubview(captureButton)
        actionBox.addSubview(rotateCameraButton)
    }

    internal override func initializeElements() {
        super.initializeElements()

        actionBox.backgroundColor = Palette[custom: .purple]

        stillImageOutput.outputSettings = [AVVideoCodecKey:AVVideoCodecJPEG]

        captureButton.addTarget(self, action: #selector(captureButtonTapped), for: .touchUpInside)
        captureButton.setImage(#imageLiteral(resourceName: "eclipse_icon").withRenderingMode(.alwaysOriginal), for: .normal)
        
        rotateCameraButton.addTarget(self, action: #selector(rotateButtonTapped), for: .touchUpInside)
        rotateCameraButton.setImage(#imageLiteral(resourceName: "cameraRotate_icon").withRenderingMode(.alwaysOriginal), for: .normal)

        navigationItem.leftBarButtonItem = leftBarButton
        navigationItem.rightBarButtonItem = rightBarbutton
        
        backgroundImage.image = nil
        backgroundImage.backgroundColor = UIColor.black
        videoView.backgroundColor = UIColor.black
        
        setCamera()
    }
    
    override func setupBackgroundImage() {
    }

    override func setupConstraints() {
        super.setupConstraints()

        videoView.snp.makeConstraints { make in
            make.leading.equalTo(view)
            make.trailing.equalTo(view)
            make.top.equalTo(view.snp.top)
            make.height.equalTo(view.snp.width).multipliedBy(4.0/3.0)
        }
        
        actionBox.snp.makeConstraints { make in
            make.leading.equalTo(view)
            make.trailing.equalTo(view)
            make.top.equalTo(videoView.snp.bottom)
            make.bottom.equalTo(view)
        }

        captureButton.snp.makeConstraints { make in
            make.centerX.equalTo(actionBox)
            make.centerY.equalTo(actionBox)
            make.width.equalTo(45)
            make.height.equalTo(45)
        }
        
        rotateCameraButton.snp.makeConstraints { make in
            make.leading.equalTo(40)
            make.centerY.equalTo(actionBox)
            make.width.equalTo(45)
            make.height.equalTo(45)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        videoPreviewLayer.frame = videoView.bounds
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
    
    func rotateButtonTapped() {
        switchCamera()
    }

    // MARK: - Actions
    fileprivate func fireUpFlash() {
        if let device = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo) {
            if (device.hasFlash) {
                do {
                    try device.lockForConfiguration()
                    if device.flashMode == .on || device.flashMode == .auto {
                        device.flashMode = .off
                        rightBarbutton.image = #imageLiteral(resourceName: "torch_off")
                    }
                    else {
                        device.flashMode = .on
                        rightBarbutton.image = #imageLiteral(resourceName: "torch_icon")
                    }
                    device.unlockForConfiguration()
                }
                catch {}
            }
        }
    }

    fileprivate func captureImage() {
        guard let videoConnection = stillImageOutput.connection(withMediaType: AVMediaTypeVideo) else {
            return
        }
        if videoConnection.isVideoOrientationSupported {
            videoConnection.videoOrientation = .portrait
        }
        self.captureButton.isEnabled = false
        stillImageOutput.captureStillImageAsynchronously(from: videoConnection) { sampleBuffer, error -> Void in
            defer {
                self.captureButton.isEnabled = true
            }
            if let _ = sampleBuffer {
                if let imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(sampleBuffer) {
                    if let dataProvider = CGDataProvider(data: imageData as CFData) {
                        if let cgImageRef = CGImage(jpegDataProviderSource: dataProvider, decode: nil, shouldInterpolate: true, intent: .defaultIntent) {
                            // need to rotate the image using fixedOrientation(), because the server ignores EXIF rotation
                            let image = UIImage(cgImage: cgImageRef, scale: 1.0, orientation: .right).fixedOrientation()
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

    fileprivate func setCamera() {
//        let captureDevice = AVCaptureDevice.defaultDevice(withDeviceType: .builtInWideAngleCamera, mediaType: AVMediaTypeVideo, position: self.cameraDirection)
        
        var captureDevice: AVCaptureDevice? = nil
        
        let devices = AVCaptureDevice.devices(withMediaType: AVMediaTypeVideo)
        for device in devices ?? [] {
            if let device = device as? AVCaptureDevice {
                if device.position == cameraDirection {
                    captureDevice = device
                    break
                }
            }
        }
        
        if captureDevice == nil {
            captureDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        }
        
        do {
            captureSession.sessionPreset = AVCaptureSessionPresetPhoto
            
            // remove previous inputs
            for input in captureSession.inputs {
                if let input = input as? AVCaptureInput {
                    captureSession.removeInput(input)
                }
            }
            
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
        videoPreviewLayer.frame = videoView.layer.bounds
        videoView.layer.addSublayer(videoPreviewLayer)
    }
    
    fileprivate func switchCamera() {
        if (cameraDirection == .front) {
            cameraDirection = .back
        } else {
            cameraDirection = .front
        }
        setCamera()
    }
}
