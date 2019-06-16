//
//  ViewController.swift
//  Glory Days
//
//  Created by Alan Nevot on 15/8/17.
//  Copyright © 2017 Alan Nevot. All rights reserved.
//

import UIKit
import AVFoundation
import Photos
import Speech

class ViewController: UIViewController {

    @IBOutlet var infoLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func askForPermissions(_ sender: UIButton) {

        self.askForPhotosPermission()

    }

    func askForPhotosPermission () {

        PHPhotoLibrary.requestAuthorization { [unowned self] (authStatus) in

            DispatchQueue.main.async {

                if authStatus == .authorized {

                    self.askForRecordPermission()

                }
                else
                {
                    self.infoLabel.text = "Nos has denegado el acceso a Fotos. Por favor, activalo en los ajustes de tu dispositivo para continuar."
                }
            }
        }

    }

    func askForRecordPermission () {

        AVAudioSession.sharedInstance().requestRecordPermission({ [unowned self] (allowed) in
            DispatchQueue.main.async {
                if allowed {

                    self.askForTranscriptionPermission()

                }
                else
                {
                    self.infoLabel.text = "Nos has denegado el acceso a Micrófono. Por favor, activalo en los ajustes de tu dispositivo para continuar."
                }
            }
        })
    }
    func askForTranscriptionPermission () {

        SFSpeechRecognizer.requestAuthorization { [unowned self] (authStatus) in
            DispatchQueue.main.async {
                if authStatus == .authorized {

                    self.authorizationCompleted()

                }
                else
                {
                    self.infoLabel.text = "Nos has denegado el acceso a Transcripción de texto. Por favor, activalo en los ajustes de tu dispositivo para continuar."
                }
            }
        }
    }

    func authorizationCompleted () {

        dismiss(animated: true, completion: nil)

    }
}

