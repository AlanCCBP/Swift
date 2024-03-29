//
//  MemoriesCollectionViewController.swift
//  Glory Days
//
//  Created by Alan Nevot on 16/8/17.
//  Copyright © 2017 Alan Nevot. All rights reserved.
//

import UIKit
import AVFoundation
import Photos
import Speech
import CoreSpotlight
import MobileCoreServices


private let reuseIdentifier = "cell"

class MemoriesCollectionViewController: UICollectionViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, AVAudioRecorderDelegate, UISearchBarDelegate {

    var memories : [URL] = []
    var filteredMemories : [URL] = []
    var currentMemory : URL!
    var audioRecorder : AVAudioRecorder?
    var recordingURL : URL!
    var audioPlayer : AVAudioPlayer?
    var searchQuery : CSSearchQuery?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.recordingURL = getDocumentsDirectory().appendingPathComponent("memory-recording.m4a")
        self.loadMemories()

        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self.addImagePressed))

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        //self.collectionView!.register(MemoryCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewDidAppear(_ animated: Bool) {

        super.viewDidAppear(animated)

        self.checkForGrantedPermissions()

    }

    func checkForGrantedPermissions () {

        let photosAuth : Bool = PHPhotoLibrary.authorizationStatus() == .authorized
        let recordingAuth : Bool = AVAudioSession.sharedInstance().recordPermission() == .granted
        let transcriptionAuth : Bool = SFSpeechRecognizer.authorizationStatus() == .authorized
        let authorized : Bool = photosAuth && recordingAuth && transcriptionAuth


        if !authorized {

            if let vc = storyboard?.instantiateViewController(withIdentifier: "showTerms") {

                navigationController?.present(vc, animated: true, completion: nil)

            }
        }
    }

    func loadMemories () {

        self.memories.removeAll()

        guard let files = try? FileManager.default.contentsOfDirectory(at: getDocumentsDirectory(), includingPropertiesForKeys: nil, options: []) else {
            return
        }

        for file in files {

            let fileName : String = file.lastPathComponent

            if fileName.hasSuffix(".thumb") {

                let noExtension = fileName.replacingOccurrences(of: ".thumb", with: "")

                let memoryPath = getDocumentsDirectory().appendingPathComponent(noExtension)

                memories.append(memoryPath)

            }
        }

        self.filteredMemories = self.memories

        collectionView?.reloadSections(IndexSet(integer: 1))

    }

    func getDocumentsDirectory() -> URL {

        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)

        let documentsDirectory = paths[0]

        return documentsDirectory

    }

    func addImagePressed () {

        let vc = UIImagePickerController()

        vc.modalPresentationStyle = .formSheet
        vc.delegate = self
        navigationController?.present(vc, animated: true)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {

        if let theImage = info[UIImagePickerControllerOriginalImage] as? UIImage {

            self.addNewMemory(image: theImage)
            self.loadMemories()

            dismiss(animated: true)

        }
    }

    func addNewMemory (image : UIImage) {

        let memoryName : String = "Memory-\(Date().timeIntervalSince1970)"

        let imageName : String = "\(memoryName).jpg"
        let thumbName : String = "\(memoryName).thumb"

        do {

            let imagePath = getDocumentsDirectory().appendingPathComponent(imageName)

            if let jpegData = UIImageJPEGRepresentation(image, 80){

                try jpegData.write(to: imagePath, options: [.atomicWrite])

            }

            if let thumb = resizeImage(image: image, toWidth: 200) {

                let thumbPath = getDocumentsDirectory().appendingPathComponent(thumbName)

                if let jpegData = UIImageJPEGRepresentation(thumb, 80) {

                    try jpegData.write(to: thumbPath, options: [.atomicWrite])

                }
            }

        } catch {
            print("Ha fallado la escritura en disco")
        }

    }

    func resizeImage (image : UIImage, toWidth: CGFloat) -> UIImage? {

        let scaleFactor = toWidth / image.size.width
        let height = image.size.height * scaleFactor

        UIGraphicsBeginImageContextWithOptions(CGSize(width: toWidth, height: height), false, 0)

        image.draw(in: CGRect(x: 0, y: 0, width: toWidth, height: height))

        let newImage = UIGraphicsGetImageFromCurrentImageContext()

        UIGraphicsEndImageContext()

        return newImage

    }

    func imageURL (for memory : URL) -> URL {
        return memory.appendingPathExtension("jpg")
    }

    func thumbnailImageURL (for memory : URL) -> URL {
        return memory.appendingPathExtension("thumb")
    }

    func audioURL (for memory : URL) -> URL {
        return memory.appendingPathExtension("m4a")
    }

    func transcriptionImageURL (for memory : URL) -> URL {
        return memory.appendingPathExtension("txt")
    }

    /*
     // MARK: - Navigation

     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using [segue destinationViewController].
     // Pass the selected object to the new view controller.
     }
     */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        if section == 0 {
            return 0
        }
        else {
            return self.filteredMemories.count
        }
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! MemoryCollectionViewCell

        // Configure the cell

        let memory = self.filteredMemories[indexPath.row]
        let memoryName = self.thumbnailImageURL(for: memory).path
        let image = UIImage(contentsOfFile: memoryName)

        cell.imageView.image = image

        if cell.gestureRecognizers == nil {

            let recognizer = UILongPressGestureRecognizer(target: self, action: #selector(self.memoryLongPressed))
            recognizer.minimumPressDuration = 0.3
            cell.addGestureRecognizer(recognizer)

            cell.layer.borderColor = UIColor.white.cgColor
            cell.layer.borderWidth = 4
            cell.layer.cornerRadius = 10

        }

        return cell
    }

    func memoryLongPressed (sender : UILongPressGestureRecognizer) {

        if sender.state == .began {

            let cell = sender.view as! MemoryCollectionViewCell

            if let index = collectionView?.indexPath(for: cell) {

                self.currentMemory = self.filteredMemories[index.row]
                self.startRecordingMemory()

            }
        }

        if sender.state == .ended {

            self.finishRecordingMemory(success: true)

        }
    }

    func startRecordingMemory () {

        audioPlayer?.stop()

        collectionView?.backgroundColor = UIColor(colorLiteralRed: 0.6, green: 0.0, blue: 0.0, alpha: 1.0)

        let recordingSession : AVAudioSession = AVAudioSession.sharedInstance()

        do {

            try recordingSession.setCategory(AVAudioSessionCategoryPlayAndRecord, with: .defaultToSpeaker)
            try recordingSession.setActive(true)

            let recordingSettings = [ AVFormatIDKey : Int(kAudioFormatMPEG4AAC),
                                      AVSampleRateKey : 44100,
                                      AVNumberOfChannelsKey : 2,
                                      AVEncoderAudioQualityKey : AVAudioQuality.high.rawValue]

            audioRecorder = try AVAudioRecorder(url: recordingURL, settings: recordingSettings)
            audioRecorder?.delegate = self
            audioRecorder?.record()

        } catch let error {

            print(error)
            self.finishRecordingMemory(success: false)

        }
    }

    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {

        if !flag {

            self.finishRecordingMemory(success: flag)

        }
    }

    func finishRecordingMemory (success : Bool) {

        collectionView?.backgroundColor = UIColor(colorLiteralRed: 255.0, green: 102.0, blue: 102.0, alpha: 1.0)
        audioRecorder?.stop()

        if success {

            do {

                let memoryAudioURL = self.currentMemory.appendingPathExtension("m4a")
                let fileManager = FileManager.default

                if fileManager.fileExists(atPath: memoryAudioURL.path) {

                    try fileManager.removeItem(at: memoryAudioURL)

                }

                try fileManager.moveItem(at: recordingURL, to: memoryAudioURL)

                self.transcribeAudioToText(memory: self.currentMemory)

            } catch let error {

                print ("Ha habido un error: \(error).")

            }
        }
        else
        {

        }
    }

    func transcribeAudioToText (memory : URL) {

        let audio = self.audioURL(for: memory)
        let transcription = self.transcriptionImageURL(for: memory)
        let recognizer = SFSpeechRecognizer()
        let request = SFSpeechURLRecognitionRequest(url: audio)

        recognizer?.recognitionTask(with: request, resultHandler: { [unowned self] (result, error) in

            guard let result = result else {

                print("Ha ocurrido el siguiente error: \(String(describing: error)).")
                return

            }

            if result.isFinal {

                let text = result.bestTranscription.formattedString

                do {

                    try text.write(to: transcription, atomically: true, encoding: String.Encoding.utf8)
                    self.indexMemory(memory : memory, text : text)

                } catch {

                    print("Ha ocurrido un error al grabar la transcripción.")
                }

            }
        })
    }

    func indexMemory(memory : URL, text : String) {

        let attributeSet = CSSearchableItemAttributeSet(itemContentType: kUTTypeText as String)


        attributeSet.title = "Recuerdo de Glory Days"
        attributeSet.contentDescription = text
        attributeSet.thumbnailURL = thumbnailImageURL(for: memory)

        let item = CSSearchableItem(uniqueIdentifier: memory.path, domainIdentifier: "com.glorydays", attributeSet: attributeSet)

        item.expirationDate = Date.distantFuture

        CSSearchableIndex.default().indexSearchableItems([item]) { (error) in
            if let error = error {

                print ("Ha habido un problema al indexar: \(error).")

            }
            else
            {
                print ("Hemos podido indexar correctamente el texto: \(text).")
            }
        }
    }

    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {

        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath)

        return header
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) ->CGSize {

        if section == 0 {
            return CGSize(width: 0, height: 50)
        }
        else
        {
            return CGSize.zero
        }
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let memory = self.filteredMemories[indexPath.row]
        let fileManager = FileManager.default

        do {
            let audioName = self.audioURL(for: memory)
            let transcriptionName = self.transcriptionImageURL(for: memory)

            if fileManager.fileExists(atPath: audioName.path) {

                self.audioPlayer = try AVAudioPlayer(contentsOf: audioName)
                self.audioPlayer?.play()

            }

            if fileManager.fileExists(atPath: transcriptionName.path) {

                let contents = try String(contentsOf: transcriptionName)
                print (contents)
            }

        } catch {
            print ("Ha ocurrido un error al reproducir el audio")
        }
    }

    func filterMemories (text : String) {

        guard text.characters.count > 0 else {

            self.filteredMemories = self.memories

            UIView.performWithoutAnimation{collectionView?.reloadSections(IndexSet(integer: 1))}

            return
        }

        var allTheItems : [CSSearchableItem] = []
        let queryString = "contentDescription == \"*\(text)*\"c"

        searchQuery?.cancel()

        self.searchQuery = CSSearchQuery(queryString: queryString, attributes: nil)

        self.searchQuery?.foundItemsHandler = { items in
            allTheItems.append(contentsOf: items)
        }

        self.searchQuery?.completionHandler = { error in

            DispatchQueue.main.async {

                [ unowned self ] in

                self.activateFilter(matches : allTheItems)

            }
        }

        self.searchQuery?.start()

    }

    func activateFilter (matches : [CSSearchableItem]) {

        self.filteredMemories = matches.map({ item in
            let uniqueId = item.uniqueIdentifier
            let url = URL(fileURLWithPath: uniqueId)

            return url
        })

        UIView.performWithoutAnimation{collectionView?.reloadSections(IndexSet(integer: 1))}

    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

        self.filterMemories(text: searchText)

    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {

        //Ocultar el teclado ;)

        searchBar.resignFirstResponder()

    }
    
    // MARK: UICollectionViewDelegate
    
    /*
     // Uncomment this method to specify if the specified item should be highlighted during tracking
     override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
     return true
     }
     */
    
    /*
     // Uncomment this method to specify if the specified item should be selected
     override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
     return true
     }
     */
    
    /*
     // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
     override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
     return false
     }
     
     override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
     return false
     }
     
     override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
     
     }
     */
    
}
