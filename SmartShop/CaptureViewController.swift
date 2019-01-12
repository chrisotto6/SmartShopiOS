//  Converted to Swift 4 by Swiftify v4.2.20229 - https://objectivec2swift.com/
//
//  CaptureViewController.swift
//  SmartShop
//
//  Created by Chris on 12/14/14.
//  Copyright (c) 2014 ChrisOtto. All rights reserved.
//

import AVFoundation
import UIKit

class CaptureViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate, ItemManagerDelegate {
    private var session: AVCaptureSession?
    private var device: AVCaptureDevice?
    private var input: AVCaptureDeviceInput?
    private var output: AVCaptureMetadataOutput?
    private var prevLayer: AVCaptureVideoPreviewLayer?
    private var highlightView: UIView?
    private var label: UILabel?
    private var items: [Any] = []
    private var manager: ItemManager?

    var recordIDToView: Int = 0
    private var dbManager: DBManager?

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        // Custom initialization
    
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.

        // capture load
        highlightView = UIView()
        highlightView?.autoresizingMask = [.flexibleTopMargin, .flexibleLeftMargin, .flexibleRightMargin, .flexibleBottomMargin]
        highlightView?.layer.borderColor = UIColor.green.cgColor
        highlightView?.layer.borderWidth = 3
        if let highlightView = highlightView {
            view.addSubview(highlightView)
        }

        label = UILabel()
        label?.frame = CGRect(x: 0, y: view.bounds.size.height - 40, width: view.bounds.size.width, height: 40)
        label?.autoresizingMask = .flexibleTopMargin
        label?.backgroundColor = UIColor(white: 0.15, alpha: 0.65)
        label?.textColor = UIColor.white
        label?.textAlignment = .center
        label?.text = "(none)"
        if let label = label {
            view.addSubview(label)
        }

        session = AVCaptureSession()
        device = AVCaptureDevice.default(for: .video)
        var error: Error? = nil

        if let device = device {
            input = try? AVCaptureDeviceInput(device: device)
        }
        if input != nil {
            if let input = input {
                session?.addInput(input)
            }
        } else {
            if let error = error {
                print("Error: \(error)")
            }
        }

        output = AVCaptureMetadataOutput()
        output?.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        if let output = output {
            session?.addOutput(output)
        }

        if let available = output?.availableMetadataObjectTypes {
            output?.metadataObjectTypes = available
        }

        if let session = session {
            prevLayer = AVCaptureVideoPreviewLayer(session: session)
        }
        prevLayer?.frame = view.bounds
        prevLayer?.videoGravity = .resizeAspectFill
        if let prevLayer = prevLayer {
            view.layer.addSublayer(prevLayer)
        }

        session?.startRunning()

        if let highlightView = highlightView {
            view.bringSubviewToFront(highlightView)
        }
        if let label = label {
            view.bringSubviewToFront(label)
        }

        //JSON
        manager = ItemManager()
        manager?.communicator = ItemCommunicator()
        manager?.communicator?.delegate = manager
        manager?.delegate = self

        // Database manager
        // Initialize the dbManager object.
        dbManager = DBManager(databaseFilename: "smartShop.db")
    }

    func startFetchingItem(_ barcode: String?) {
        manager?.fetchItems(barcode)
    }

    func didReceiveItems(_ items: [Any]?) {
        self.items = items
    }

    func fetchingItemsFailed() throws {
        if let error = error {
            print("Error \(error), \(error?.localizedDescription ?? "")")
        }
    }

    func metadataOutput(_ captureOutput: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        var highlightViewRect = CGRect.zero
        var barCodeObject: AVMetadataMachineReadableCodeObject?
        var detectionString: String? = nil
        let barCodeTypes = [
            .upce,
            .code39,
            .code39Mod43,
            .ean13,
            .ean8,
            .code93,
            .code128,
            .pdf417,
            .qr,
            .aztec
        ] as? [Any]

        for metadata: AVMetadataObject in metadataObjects {
            for type: String? in barCodeTypes as? [String?] ?? [] {
                if (metadata.type == type) {
                    barCodeObject = prevLayer?.transformedMetadataObject(for: metadata as? AVMetadataMachineReadableCodeObject) as? AVMetadataMachineReadableCodeObject
                    highlightViewRect = barCodeObject?.bounds ?? CGRect.zero
                    detectionString = (metadata as? AVMetadataMachineReadableCodeObject)?.stringValue
                    break
                }
            }

            if detectionString != nil {
                label?.text = detectionString
                session?.stopRunning()

                let alert = UIAlertView(title: "Barcode", message: "Barcode Captured", delegate: self, cancelButtonTitle: "Add", otherButtonTitles: "")
                alert.alertViewStyle = .plainTextInput
                let alertTextField: UITextField? = alert.textField(at: 0)
                alertTextField?.text = detectionString
                alert.show()
            } else {
                label?.text = "(none)"
            }
        }

        highlightView?.frame = highlightViewRect
    }

    func alertView(_ alertView: UIAlertView, clickedButtonAt buttonIndex: Int) {
        let barcode = alertView.textField(at: 0)?.text
        startFetchingItem(barcode)

        let item = items as? Item
        let name = item?.name
        let attributes = item?.attributes

        let query = "insert into items values (null, \(recordIDToView), '\(barcode ?? "")', '\(name ?? "")', null, null, '\(attributes ?? "")')"

        // Execute the query.
        dbManager?.executeQuery(query)

        // If the query was successfully executed then pop the view controller.
        if dbManager?.affectedRows != 0 {
            print("Query was executed successfully. Affected rows = \(dbManager?.affectedRows ?? 0)")

            // Pop the view controller.
            navigationController?.popViewController(animated: true)
        } else {
            print("Could not execute the query.")
        }

    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}