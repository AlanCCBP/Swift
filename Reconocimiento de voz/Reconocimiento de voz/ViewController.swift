//
//  ViewController.swift
//  Reconocimiento de voz
//
//  Created by Alan Nevot on 14/8/17.
//  Copyright © 2017 Alan Nevot. All rights reserved.
//

import UIKit
import Speech
//import AVFoundation (Ya viene incorporado en iOS10)

class ViewController: UIViewController, AVAudioRecorderDelegate {

    @IBOutlet var textView: UITextView!
    @IBOutlet var remainingTimeLabel: UILabel!
    @IBOutlet var timeTextField: UITextField!

    var recordingTime : Double = 30
    var remainingTime : Double = 30
    var audioFileName : String = "Audio-Recordered.m4a"
    var audioRecorder : AVAudioRecorder!
    var audioRecordingSession : AVAudioSession!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.timeTextField.text = "0"
        //recognizeSpeech()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }

    func dismissKeyboard () {

        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func recognizeSpeech (){

        SFSpeechRecognizer.requestAuthorization { (authStatus) in

            if authStatus == SFSpeechRecognizerAuthorizationStatus.authorized {

                let recognizer = SFSpeechRecognizer()
                let request = SFSpeechURLRecognitionRequest(url: self.directoryURL()!)

                recognizer?.recognitionTask(with: request, resultHandler: { (result, error) in

                    if let error = error {

                        print ("Algo ha ido mal: \(error.localizedDescription).")

                    }
                    else
                    {
                        self.textView.text = String(describing: result?.bestTranscription.formattedString)
                    }
                })
            }
            else
            {
                print("No tengo autorización al SpeechFramework.")
            }
        }
    }

    func recordingAudioSetup () {

        audioRecordingSession = AVAudioSession.sharedInstance()

        do {

            try audioRecordingSession.setCategory(AVAudioSessionCategoryRecord)
            try audioRecordingSession.setActive(true)

            audioRecordingSession.requestRecordPermission({ (allowed : Bool) in
                if allowed {

                    //Hay que comenzar a grabar porque nos ha dado permisos.
                    self.startRecording()

                }
                else
                {
                    print("Necesitamos permiso para utilizar el micrófono.")
                }
            })

        } catch {
            print ("Ha habido un error al configurar el Audio Recorder.")
        }
    }

    func directoryURL () -> URL? {

        let fileManager = FileManager.default
        let urls = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = urls[0] as URL

        return documentsDirectory.appendingPathComponent(audioFileName)
    }

    func startRecording () {

        let settings = [AVFormatIDKey : Int(kAudioFormatMPEG4AAC),
                        AVSampleRateKey : 12000.0,
                        AVNumberOfChannelsKey : 1 as NSNumber,
                        AVEncoderAudioQualityKey : AVAudioQuality.high.rawValue] as [String : Any]

        do {

            audioRecorder = try AVAudioRecorder(url: directoryURL()!, settings: settings)
            audioRecorder.delegate = self
            audioRecorder.record()

            Timer.scheduledTimer(timeInterval: self.recordingTime, target: self, selector: #selector(self.stopRecording), userInfo: nil, repeats: false)

        } catch {
            print ("No se ha podido grabar el audio correctamente.")
        }
    }

    func stopRecording () {

        audioRecorder.stop()
        audioRecorder = nil

        Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.recognizeSpeech), userInfo: nil, repeats: false)

    }

    func updateRemainingTime () {

        if self.remainingTime > 1 {
            
            Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.updateRemainingTime), userInfo: nil, repeats: true)

            self.remainingTime -= 1
        }
        
        self.remainingTimeLabel.text = String(self.remainingTime)
        
    }
    
    @IBAction func recordButtonPressed(_ sender: UIButton) {
        
        if let auxTimeRemaining : Double = Double(self.timeTextField.text!) {
            
            self.recordingTime = 30
            
            if auxTimeRemaining <= 30 {
                self.recordingTime = auxTimeRemaining
            }
            
            self.remainingTime = self.recordingTime
            self.updateRemainingTime()
            
        }
        
        recordingAudioSetup()
        
    }
}
