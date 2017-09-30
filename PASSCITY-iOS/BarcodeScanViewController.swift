//
//  BarcodeScanViewController.swift
//  PASSCITY-iOS
//
//  Created by Алексей on 28.09.17.
//  Copyright © 2017 PASSCITY-iOS-TEST. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
import EasyPeasy

class BarcodeScanViewController: UIViewController {
  var captureSession:AVCaptureSession?
  var videoPreviewLayer:AVCaptureVideoPreviewLayer?
  let qrCodeContainerView = UIView()
  let qrCodeFrameView = UIView()
  let titleLabel = UILabel()
  let headerView = UIView()
  let frameImageView = UIImageView(image: #imageLiteral(resourceName: "iconScanCode").withRenderingMode(.alwaysTemplate))
  let closeButton = GoButton(image: #imageLiteral(resourceName: "circleCloseRedIcon"))

  let supportedCodeTypes = [AVMetadataObjectTypeUPCECode,
                            AVMetadataObjectTypeCode39Code,
                            AVMetadataObjectTypeCode39Mod43Code,
                            AVMetadataObjectTypeCode93Code,
                            AVMetadataObjectTypeCode128Code,
                            AVMetadataObjectTypeEAN8Code,
                            AVMetadataObjectTypeEAN13Code,
                            AVMetadataObjectTypeAztecCode,
                            AVMetadataObjectTypePDF417Code,
                            AVMetadataObjectTypeQRCode]

  var codeDidPickHandler: ((String) -> Void)? = nil

  var pickedCode: String? = nil {
    didSet {
      guard let pickedCode = pickedCode, !pickedCode.isEmpty else {
        frameImageView.tintColor = UIColor.black
        return
      }
      frameImageView.tintColor = UIColor.green
      codeDidPickHandler?(pickedCode)
    }
  }

  override func viewDidLoad() {

    setupView()
    addConstraints()
    setupCodeScan()
  }

  func setupCodeScan() {
    let captureDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
    do {
      let input = try AVCaptureDeviceInput(device: captureDevice)

      captureSession = AVCaptureSession()

      captureSession?.addInput(input)

      let captureMetadataOutput = AVCaptureMetadataOutput()
      captureSession?.addOutput(captureMetadataOutput)

      captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
      captureMetadataOutput.metadataObjectTypes = supportedCodeTypes

      videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
      videoPreviewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
      qrCodeFrameView.layer.addSublayer(videoPreviewLayer!)

      captureSession?.startRunning()

    } catch let error {
      debugPrint("CAMERA ERROR : \(error)")
    }

  }

  func setupView() {
    view.backgroundColor = UIColor.backgroundGrey
    headerView.backgroundColor = UIColor.white
    titleLabel.font = UIFont.systemFont(ofSize: 20, weight: UIFontWeightLight)
    titleLabel.text = "Наведите камеру на штрих-код на оборотной стороне карты"
    titleLabel.textAlignment = .center
    titleLabel.numberOfLines = 0
    closeButton.tintColor = .red
    closeButton.addTarget(self, action: #selector(closeButtonAction), for: .touchUpInside)

    qrCodeFrameView.clipsToBounds = true
    qrCodeContainerView.clipsToBounds = true
    qrCodeFrameView.cornerRadius = 10

    qrCodeContainerView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(codeContainerDidTap)))

    frameImageView.tintColor = .black
  }

  func codeContainerDidTap() {
    guard let pickedCode = pickedCode, !pickedCode.isEmpty else { return }
    codeDidPickHandler?(pickedCode)
  }

  func closeButtonAction() {
    dismiss(animated: true, completion: nil)
  }

  func addConstraints() {
    view.addSubview(headerView)

    headerView <- [
      Top(),
      Left(),
      Right()
    ]

    headerView.addSubview(titleLabel)

    titleLabel <- Edges(30)

    view.addSubview(qrCodeContainerView)

    qrCodeContainerView <- [
      Top(60).to(headerView, .bottom),
      CenterX()
    ]

    qrCodeContainerView.addSubview(qrCodeFrameView)
    qrCodeContainerView.addSubview(frameImageView)
    qrCodeFrameView <- Edges(10)
    frameImageView <- Edges()

    view.addSubview(closeButton)

    closeButton <- [
      Bottom(60),
      CenterX()
    ]
  }

  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    guard videoPreviewLayer?.frame != qrCodeFrameView.bounds else { return }
    videoPreviewLayer?.frame = qrCodeFrameView.bounds
  }

}

extension BarcodeScanViewController: AVCaptureMetadataOutputObjectsDelegate {
  func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {
    guard let metadataObjects = metadataObjects, !metadataObjects.isEmpty else {
      pickedCode = nil
      frameImageView.tintColor = UIColor.black
      return
    }
    let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject

    if let code = metadataObj.stringValue, !code.onlyDigits.isEmpty {
      pickedCode = code.onlyDigits
    } else {
      pickedCode = nil
    }

  }
}
