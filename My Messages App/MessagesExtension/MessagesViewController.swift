//
//  MessagesViewController.swift
//  MessagesExtension
//
//  Created by Alan Nevot on 21/8/17.
//  Copyright © 2017 Alan Nevot. All rights reserved.
//

import UIKit
import Messages

class MessagesViewController: MSMessagesAppViewController {
    
    @IBAction func sendGreetingsPressed(_ sender: UIButton) {

        /*let message = "Hola! Cómo estás?"

        activeConversation?.insertText(message, completionHandler: nil)*/

        /*let path = Bundle.main.url(forResource: "audio", withExtension: "mp3")

        activeConversation?.insertAttachment(path!, withAlternateFilename: "Saludo de Alan.", completionHandler: nil)*/

        let layout = MSMessageTemplateLayout.init()

        //layout.image = UIImage(named: "SAAB.jpg")

        layout.image = #imageLiteral(resourceName: "SAAB")
        layout.imageTitle = "SAVE SAAB"
        layout.imageSubtitle = "Born from jets"
        layout.caption = "Svenska Aeroplane AB"
        layout.trailingCaption = "Trailing caption"
        layout.trailingSubcaption = "Trailing subcaption"
        layout.mediaFileURL = URL(string: "http://www.saab-central.com")

        let message = MSMessage()

        message.layout = layout

        activeConversation?.insert(message, completionHandler: nil)
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Conversation Handling
    
    override func willBecomeActive(with conversation: MSConversation) {
        // Called when the extension is about to move from the inactive to active state.
        // This will happen when the extension is about to present UI.
        
        // Use this method to configure the extension and restore previously stored state.

        print("Nuestra app está a punto de activarse.")
    }
    
    override func didResignActive(with conversation: MSConversation) {
        // Called when the extension is about to move from the active to inactive state.
        // This will happen when the user dissmises the extension, changes to a different
        // conversation or quits Messages.
        
        // Use this method to release shared resources, save user data, invalidate timers,
        // and store enough state information to restore your extension to its current state
        // in case it is terminated later.

        print("Nuestra app va a dejar de mostrarse.")
    }
   
    override func didReceive(_ message: MSMessage, conversation: MSConversation) {
        // Called when a message arrives that was generated by another instance of this
        // extension on a remote device.
        
        // Use this method to trigger UI updates in response to the message.

        print("El usuario ha recibido un mensaje.")
    }
    
    override func didStartSending(_ message: MSMessage, conversation: MSConversation) {
        // Called when the user taps the send button.

        print("El usuario está mandando un mensaje.")
    }
    
    override func didCancelSending(_ message: MSMessage, conversation: MSConversation) {
        // Called when the user deletes the message without sending it.
    
        // Use this to clean up state related to the deleted message.

        print("El usuario ha dejado de enviar el mensaje (cuando deseamos cancelar).")
    }
    
    override func willTransition(to presentationStyle: MSMessagesAppPresentationStyle) {
        // Called before the extension transitions to a new presentation style.
    
        // Use this method to prepare for the change in presentation style.
    }
    
    override func didTransition(to presentationStyle: MSMessagesAppPresentationStyle) {
        // Called after the extension transitions to a new presentation style.
    
        // Use this method to finalize any behaviors associated with the change in presentation style.
    }

}
