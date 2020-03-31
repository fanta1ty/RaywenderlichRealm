//
//  StatsViewController.swift
//  Chatter
//
//  Created by User on 3/27/20.
//  Copyright © 2020 ThinhNguyen. All rights reserved.
//

import Foundation
import RealmSwift

class StatsViewController: UIViewController {

    @IBOutlet var statsLabel: UILabel!
    private var messagesToken: NotificationToken?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        let realm = try! Realm()
        let messages = realm.objects(Message.self)
        
        messagesToken = messages.observe({ [weak self] _ in
            guard let this = self else {
                return
            }
            
            UIView.transition(with: this.statsLabel, duration: 0.3, options: [.transitionFlipFromTop], animations: {
                this.statsLabel.text = "Total messages: \(messages.count)"
            }, completion: nil)
        })
    }
}
