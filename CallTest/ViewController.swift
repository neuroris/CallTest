//
//  ViewController.swift
//  CallTest
//
//  Created by 유재욱 on 2023/11/08.
//

import UIKit
import MessageUI

class ViewController: UIViewController, MFMessageComposeViewControllerDelegate {
    @IBOutlet var txtDial: UITextField!
    @IBOutlet var txtView: UITextView!
    @IBOutlet var btnCall: UIButton!
    @IBOutlet var btnSendMessage: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        txtDial.text = "100"
        txtView.text = "Test Message has been delivered"
        
        NotificationCenter.default.addObserver(self, selector: #selector(didEnterBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }

    @IBAction func callDial(_ sender: UIButton) {
        print("call start")
        
        if let url = NSURL(string: "tel://" + "\(txtDial.text!)"), UIApplication.shared.canOpenURL(url as URL) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url as URL)
            }
        } else {
            print("call failed")
        }
        
        print("call executed")
    }
    
    @objc func didEnterBackground() {
        print("did enter background")
        
//        let AfterCallingVC = self.storyboard?.instantiateViewController(identifier: "AfterCallingVC") as! AfterCallingVC
//        self.modalPresentationStyle = .fullScreen
//        self.present(AfterCallinVC, animated: true, completion:)
        //
    }

    @IBAction func sendMessage(_ sender: UIButton) {
        print("send executed")
        
        let messageComposer = MFMessageComposeViewController()
        messageComposer.messageComposeDelegate = self
        if MFMessageComposeViewController.canSendText() {
            messageComposer.recipients = [txtDial.text!]
            messageComposer.body = txtView.text
            self.present(messageComposer, animated: true, completion: nil)
        }
    }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        switch result {
        case MessageComposeResult.sent:
            print("Send complete")
            break
        case MessageComposeResult.cancelled:
            print("Canceled")
            break
        case MessageComposeResult.failed:
            print("Failed")
            break
        default:
            print("Something wrong")
        }
        
        controller.dismiss(animated: true, completion: nil)
    }
}
