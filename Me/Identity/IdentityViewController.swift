//
//  IdentityViewController.swift
//  Me
//
//  Created by Jamal on 27/02/2018.
//  Copyright © 2018 Forus. All rights reserved.
//

import UIKit
import QRCodeReader

var identityVC = IdentityViewController()

class IdentityViewController: UIViewController, QRCodeReaderViewControllerDelegate {

    @IBOutlet weak var qrView: UIImageView!
    @IBOutlet weak var filterView: UIView!
    @IBOutlet weak var scannerView: UIView!
    
    var model: IdentityModel?
    var scannerLoaded = false
    
    func generateQRCode(from string: String) -> UIImage? {
        let data = string.data(using: String.Encoding.ascii)
        
        if let filter = CIFilter(name: "CIQRCodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            let transform = CGAffineTransform(scaleX: 50, y: 50)
            
            if let output = filter.outputImage?.transformed(by: transform) {
                return UIImage(ciImage: output)
            }
        }
        
        return nil
    }
    
    func changeColorByTransparent(imgView: UIImageView, cMask: [CGFloat]) -> UIImage? {
        
        var returnImage: UIImage?
        
        if let capImage = imgView.image {
            
            let sz = capImage.size
            
            UIGraphicsBeginImageContextWithOptions(sz, true, 0.0)
            capImage.draw(in: CGRect(origin: CGPoint.zero, size: sz))
            let noAlphaImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            let noAlphaCGRef = noAlphaImage?.cgImage
            
            if let imgRefCopy = noAlphaCGRef?.copy(maskingColorComponents: cMask) {
                
                returnImage = UIImage(cgImage: imgRefCopy)
                
            }
            
        }
        
        return returnImage
        
    }
    
    lazy var reader: QRCodeReader = QRCodeReader()
    func reader(_ reader: QRCodeReaderViewController, didScanResult result: QRCodeReaderResult) {
        print("yo1")
//        reader.stopScanning()
//
//        dismiss(animated: true) { [weak self] in
////            self?.model?.scanResult = result.value
//        }
    }
    
    func readerDidCancel(_ reader: QRCodeReaderViewController) {
        print("yo2")
//        reader.stopScanning()
        
//        dismiss(animated: true, completion: nil)
    }
    
    func loadScanner() {
        guard (model?.checkScanPermissions())!, !reader.isRunning else { return }
        
        reader.previewLayer.frame = scannerView.bounds
        scannerView.layer.addSublayer(reader.previewLayer)
        
        reader.startScanning()
        reader.didFindCode = { result in
            print(result.value)
            self.expand()
            walletVC.sendEther(to: result.value)
//            self.reader.startScanning()
        }
    }
    
    func openIdentityView() {
//        print("open idenity view")
    }
    
    func expand() {
        if !scannerLoaded {loadScanner(); scannerLoaded = true}
        
        UIView.animate(withDuration: 0.2) {
            if let expanded = identityVC.model?.expanded {
                if expanded {
                    identityVC.reader.previewLayer.frame = CGRect(x: 0.0, y: 0.0, width: 75, height: 75)
                    identityVC.filterView.alpha = 0.0
                    
                    mainVC.identityHeight.constant = 75
                    mainVC.identityCenterY.constant = 244
                    identityVC.model?.expanded = false
                } else {
                    identityVC.reader.previewLayer.frame = CGRect(x: 0.0, y: 0.0, width: 200, height: 200)
                    identityVC.filterView.alpha = 0.5
                    
                    mainVC.identityHeight.constant = 200
                    mainVC.identityCenterY.constant = 0
                    identityVC.model?.expanded = true
                    self.reader.startScanning()
                }
                
                mainVC.view.layoutIfNeeded()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tokenQR = self.generateQRCode(from: "0xC2D7CF95645D33006175B78989035C7c9061d3F9")
        self.qrView.image = tokenQR
        
        var cMask : [CGFloat] = []
        
        cMask = [222, 255, 222, 255, 222, 255]
        
        let newImage = changeColorByTransparent(imgView: qrView, cMask: cMask)
        qrView.image = newImage
        
        identityVC = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        model = IdentityModel(viewController: self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
//        loadScanner()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
