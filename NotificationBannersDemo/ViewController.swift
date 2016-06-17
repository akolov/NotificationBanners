//
//  ViewController.swift
//  NotificationBannersDemo
//
//  Created by Alexander Kolov on 17/6/16.
//  Copyright © 2016 Alexander Kolov. All rights reserved.
//

import NotificationBanners
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

  // MARK: Actions

  @IBAction func didTapNotifyButton(sender: UIButton) {
    NotificationBannerController.showNotification("Boxcar", text: "This is a test message x123 x123 x123 abc abc 45678 ---- abcdefgh ----- xxx *** $$$$ 123 more more more text text text", image: UIImage())
  }

}
