//
//  LetsTextNotification.swift
//  LetsNotificationsSDK
//
//  Created by LN-MCBK-004 on 22/08/18.
//  Copyright © 2018 LetsNurture. All rights reserved.
//

import UIKit
import WebKit
import AVFoundation

class LetsTextNotification: UIViewController {
    @IBOutlet weak var demonastrationView: UIView!
    @IBOutlet weak var webPage: WKWebView!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var viewForVideo: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var replayVideo: UIButton!
    @IBOutlet weak var notificationTitleLbl: UILabel!
    
    var didCancelAction:(() -> Void)?
    
    var avPlayer: AVPlayer?
    var avPlayerLayer: AVPlayerLayer?
    
    public var webPageURL: String?{
        didSet{
            if webPageURL!.hasPrefix("http://") || webPageURL!.hasPrefix("https://"){
                webPage.load(URLRequest(url: URL(string: webPageURL!)!))
            }
            else{
                webPage.loadHTMLString(webPageURL!, baseURL: nil)
            }
        }
    }
    
    public var notificationTitle: String?{
        didSet{
            self.notificationTitleLbl.text = notificationTitle
            self.notificationTitleLbl.layoutIfNeeded()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.replayVideo.isHidden = true
        closeButton.layer.cornerRadius = 5
        closeButton.layer.borderColor = UIColor(red: 0, green: 0.5, blue: 1, alpha: 1).cgColor
        closeButton.layer.borderWidth = 0.8
        closeButton.setTitleColor(UIColor(red: 0, green: 0.5, blue: 1, alpha: 1), for: .normal)
        
        replayVideo.layer.cornerRadius = 5
        replayVideo.layer.borderColor = UIColor(red: 0, green: 0.5, blue: 1, alpha: 1).cgColor
        replayVideo.layer.borderWidth = 0.8
        replayVideo.setTitleColor(UIColor(red: 0, green: 0.5, blue: 1, alpha: 1), for: .normal)
        
        closeButton.backgroundColor = .white
        closeButton.layer.shadowColor = UIColor.lightGray.cgColor
        closeButton.layer.shadowOffset = CGSize(width: -0.5, height: 0.5)
        closeButton.layer.shadowOpacity = 1.0
        closeButton.layer.shadowRadius = 5
        closeButton.layer.masksToBounds = false
        
        closeButton.layer.cornerRadius = 5
        closeButton.layer.borderColor = UIColor.lightGray.cgColor
        closeButton.layer.borderWidth = 0.8
        
        
        demonastrationView.backgroundColor = .white
        demonastrationView.layer.shadowColor = UIColor.lightGray.cgColor
        demonastrationView.layer.shadowOffset = CGSize(width: -0.5, height: 0.5)
        demonastrationView.layer.shadowOpacity = 1.0
        demonastrationView.layer.shadowRadius = 5
        demonastrationView.layer.masksToBounds = false
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        demonastrationView.layoutIfNeeded()
//        demonastrationView.layer.masksToBounds = true
        self.viewForVideo.layoutIfNeeded()
        if avPlayerLayer != nil {
            avPlayerLayer?.frame = self.viewForVideo.bounds
        }
        
    }
    
    func setupImageView(){
        self.replayVideo.isHidden = true
        self.viewForVideo.isHidden = true
        self.imageView.isHidden = false
    }
    
    func setupMoviePlayer(url: String){
        let videoPlayerItem = AVPlayerItem(url: URL(string: url)!)
        replayVideo.isHidden = true
        self.viewForVideo.isHidden = false
        self.imageView.isHidden = true
        
        self.avPlayer = AVPlayer.init(playerItem: videoPlayerItem)
        avPlayerLayer = AVPlayerLayer(player: avPlayer)
        avPlayerLayer?.videoGravity = AVLayerVideoGravity.resizeAspect
        avPlayerLayer?.name = "test"
        avPlayer?.volume = 3
        avPlayer?.actionAtItemEnd = .none
        self.viewForVideo.backgroundColor = .clear
        self.viewForVideo.layer.insertSublayer(avPlayerLayer!, at: 0)
        self.viewForVideo.layoutIfNeeded()
        // This notification is fired when the video ends, you can handle it in the method.
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.playerItemDidReachEnd(notification:)),
                                               name: NSNotification.Name.AVPlayerItemDidPlayToEndTime,
                                               object: avPlayer?.currentItem)
        self.avPlayer?.play()
    }
    func stopPlayback(){
        if let player = self.avPlayer {
            if player.isPlaying {
                player.pause()
            }
        }
    }
    
    @IBAction func replayVideo(_ sender: Any){
        self.startPlayback()
    }
    
    func startPlayback(){
        self.replayVideo.isHidden = true
        self.avPlayer?.play()
        
    }
    @objc func playerItemDidReachEnd(notification: Notification) {
        //let p: AVPlayerItem = notification.object as! AVPlayerItem
        //p.seek(to: kCMTimeZero)
        self.avPlayer?.currentItem?.seek(to: kCMTimeZero, completionHandler: { (success) in
            if success {
                self.replayVideo.isHidden = false
                self.replayVideo.bringSubview(toFront: self.viewForVideo)
                self.avPlayer?.pause()
            }
        })
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func closeNotification(_ sender: Any){
        self.stopPlayback()
        self.didCancelAction!()
    }

}

extension AVPlayer {
    var isPlaying: Bool {
        return rate != 0 && error == nil
    }
}
