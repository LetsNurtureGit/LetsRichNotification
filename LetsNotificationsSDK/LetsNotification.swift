//
//  LetsNotification.swift
//  LetsNotificationsSDK
//
//  Created by LN-MCBK-004 on 22/08/18.
//  Copyright © 2018 LetsNurture. All rights reserved.
//

import UIKit
import WebKit
import AVFoundation

/**
 NotiticationType: This will allow user to set notification type.
 */
enum NotiticationType {
    case Text
    case Image
    case Video
    case Web
}

/**
 LetsNotification: This class will allow user to present Rich Notification in App itself.
 */
class LetsNotification: NSObject {
    /**
     instance: This will return sharedInstance of LetsNotification class.
     */
    static private var instance : LetsNotification {
        return sharedInstance
    }
    
    /**
     sharedInstance: This will allow to access LetsNotification class variables and functions.
     */
    public static let sharedInstance = LetsNotification()
    
    /**
     notificationType: This is a Enum type of Notifications. Default will be Text with URL or Description text.
     */
    var notificationType = NotiticationType.Text
    
    /**
     mainView: This is private variable which will contain LetsTextNotification class main view.
     */
    private var mainView: UIView {
        return letsTextNotificationVC!.view
    }
    
    /**
    demonastrationView: This is private variable which will contain LetsTextNotification class inner view. This view will contain Image, Video, Text or WebPage.
     */
    private var demonastrationView: UIView {
        return letsTextNotificationVC!.demonastrationView
    }
    
    /**
     passthroughWindow: This is UIWindow main class.
     */
    private var passthroughWindow: UIWindow?
    
    /**
     letsTextNotificationVC: This class will show as notification layout.
     */
    private var letsTextNotificationVC: LetsTextNotification?
    
    /**
     webPageURL: If any URL pass, then it will showing webview. If any text pass then it will load as HTML context.
    */
    public var webPageURL: String?{
        didSet{
            letsTextNotificationVC!.webPageURL = webPageURL!
        }
    }
    
    /**
     notificationTitle: This is notification main title. User can set their own notification title.
     */
    public var notificationTitle: String?{
        didSet{
            letsTextNotificationVC!.notificationTitle = notificationTitle
        }
    }
    
    /**
     init: This will allocate LetsNotification class. This class will define notification view and its type.
     */
    private override init() {
        super.init()
        let passthroughWindow = UIWindow(frame: UIScreen.main.bounds)
        passthroughWindow.backgroundColor = UIColor.clear
        passthroughWindow.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        passthroughWindow.windowLevel = UIWindowLevelAlert
        self.passthroughWindow = passthroughWindow
        let storyBoard = UIStoryboard(name: "LetsNotification", bundle: nil)
        self.letsTextNotificationVC = (storyBoard.instantiateViewController(withIdentifier: "LetsTextNotification") as! LetsTextNotification)
    }
    
    /**
     initNotificationDialog: This function will be called after initilized LetsNotification. User has to set notificationType before calling this function or else it will consider as TEXT type of notification.
     */
    public func initNotificationDialog() {
        switch  notificationType{
        case .Text:
            showTextNotification()
            print("Notification for TEXT")
            break
        case .Image:
            
            print("Notification for Image")
            break
        case .Video:
            showVideoNotification()
            print("Notification for Video")
            break
        case .Web:
            print("Notification for Web")
            break
        default:
            break
        }
    }
    
    /**
     showTextNotification: This will present LetsTextNotification class with TEXT Notification Type.
     */
    func showTextNotification(){
        
        passthroughWindow!.isHidden = false
        passthroughWindow!.rootViewController = self.letsTextNotificationVC
        passthroughWindow!.windowLevel = UIWindowLevelNormal + 1
        passthroughWindow!.rootViewController?.view.frame = passthroughWindow!.frame
        
        letsTextNotificationVC?.didCancelAction = { [weak self] in
            self?.cleanUp()
        }
    }
    
    /**
     showVideoNotification: This will present LetsTextNotification class with Video Notification Type.
     */
    func showVideoNotification(){
        passthroughWindow!.isHidden = false
        passthroughWindow!.rootViewController = self.letsTextNotificationVC
        passthroughWindow!.windowLevel = UIWindowLevelNormal + 1
        passthroughWindow!.rootViewController?.view.frame = passthroughWindow!.frame
        letsTextNotificationVC!.setupMoviePlayer(url: "https://www.rmp-streaming.com/media/bbb-360p.mp4")
        letsTextNotificationVC?.didCancelAction = { [weak self] in
            self?.cleanUp()
        }
    }
    
    /**
     cleanUp: This will clear passthroughWindow when user click on Close button.
     */
    private func cleanUp() {
        passthroughWindow!.isHidden = true
        passthroughWindow!.rootViewController = nil
        
    }
}
