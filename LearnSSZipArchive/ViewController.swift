//
//  ViewController.swift
//  LearnSSZipArchive
//
//  Created by Minh Tuan Nguyen on 10/28/19.
//  Copyright © 2019 Minh Tuan Nguyen. All rights reserved.
//

import UIKit
import SSZipArchive

class ViewController: UIViewController {

    var samplePath: String!
    var zipPath: String?
    let password = "test"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        samplePath = Bundle.main.bundlePath
        print("Sample bundlePath:", samplePath!)
    }

    // MARK: IBAction
    @IBAction func zipPressed(_: UIButton) {
        zipPath = tempZipPath()
        print("Zip path:", zipPath!)
        
        let fm = FileManager.default
        do{
            let items = try fm.contentsOfDirectory(atPath: samplePath)
            for item in items {
                print("Found \(item)")
            }
        }
        catch{
            
        }
        
        let success = SSZipArchive.createZipFile(atPath: zipPath!,
                                                 withContentsOfDirectory: samplePath,
                                                 keepParentDirectory: false,
                                                 compressionLevel: -1,
                                                 password: !password.isEmpty ? password : nil,
                                                 aes: true,
                                                 progressHandler: nil)
        
    }

    @IBAction func unzipPressed(_: UIButton) {
        guard let zipPath = self.zipPath else {
            return
        }

        guard let unzipPath = tempUnzipPath() else {
            return
        }
        print("Unzip path:", unzipPath)
        
        //let password = passwordField.text ?? ""
        let success: Bool = SSZipArchive.unzipFile(atPath: zipPath,
                                                   toDestination: unzipPath,
                                                   preserveAttributes: true,
                                                   overwrite: true,
                                                   nestedZipLevel: 1,
                                                   password: !password.isEmpty ? password : nil,
                                                   error: nil,
                                                   delegate: nil,
                                                   progressHandler: nil,
                                                   completionHandler: nil)
        var items: [String]
        do {
            items = try FileManager.default.contentsOfDirectory(atPath: unzipPath)
        } catch {
            return
        }
    }
    @IBAction func unZipExistsFile(_ sender: Any) {
        self.zipPath = samplePath + "/test.zip"
        guard let zipPath = self.zipPath else {
            return
        }

        guard let unzipPath = tempUnzipPath() else {
            return
        }
        print("Unzip path:", unzipPath)
        
        //let password = passwordField.text ?? ""
        let success: Bool = SSZipArchive.unzipFile(atPath: zipPath,
                                                   toDestination: unzipPath,
                                                   preserveAttributes: true,
                                                   overwrite: true,
                                                   nestedZipLevel: 1,
                                                   password: !password.isEmpty ? password : nil,
                                                   error: nil,
                                                   delegate: nil,
                                                   progressHandler: nil,
                                                   completionHandler: nil)
        var items: [String]
        do {
            items = try FileManager.default.contentsOfDirectory(atPath: unzipPath)
        } catch {
            return
        }
    }
    
    // MARK: Private
    func tempZipPath() -> String {
        var path = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true)[0]
        path += "/\(UUID().uuidString).zip"
        return path
    }

    func tempUnzipPath() -> String? {
        var path = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true)[0]
        path += "/\(UUID().uuidString)"
        let url = URL(fileURLWithPath: path)

        do {
            try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
        } catch {
            return nil
        }
        return url.path
    }
}

