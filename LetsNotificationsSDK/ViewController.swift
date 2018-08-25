//
//  ViewController.swift
//  LetsNotificationsSDK
//
//  Created by LN-MCBK-004 on 22/08/18.
//  Copyright © 2018 LetsNurture. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func showTextNotification(_ sender: Any) {
        let notification = LetsNotification.sharedInstance
        notification.notificationType = .Video
        notification.initNotificationDialog()
        notification.webPageURL = "<h1 style=\"color: #5e9ca0;\">Let's Nurture transforming your idea into businesses. We are offering many kind of <a href='https://www.letsnurture.com/services.html'>services</a>. Feel free to talk <a href='https://www.letsnurture.com/contact.html'>us</a>.</h1>"
        notification.notificationTitle = "Let's Nurture Team"
    }
}

