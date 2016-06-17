//
//  NotificationBannerController.swift
//  NotificationBanners
//
//  Created by Alexander Kolov on 17/6/16.
//  Copyright © 2016 Alexander Kolov. All rights reserved.
//

import UIKit

public class NotificationBannerController: UIViewController {

  public override func viewDidLoad() {
    super.viewDidLoad()
  }

  public override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  public private(set) static var window: UIWindow?
  public static let sharedInstance = NotificationBannerController()

}

public extension NotificationBannerController {

  public static func showNotification(title: String, text: String, image: UIImage) {
    let height = notificationHeight

    if window == nil {
      let screen = UIScreen.mainScreen()
      window = UIWindow(frame: CGRect(x: 0, y: 0, width: screen.bounds.width, height: height))
      window?.windowLevel = UIWindowLevelStatusBar
      window?.rootViewController = sharedInstance
    }

    window?.makeKeyAndVisible()

    let notificationView = NotificationBannerView(title: title, text: text, image: image)
    notificationView.translatesAutoresizingMaskIntoConstraints = false
    sharedInstance.view.addSubview(notificationView)

    notificationView.heightAnchor.constraintEqualToConstant(height).active = true
    sharedInstance.view.leadingAnchor.constraintEqualToAnchor(notificationView.leadingAnchor).active = true
    sharedInstance.view.trailingAnchor.constraintEqualToAnchor(notificationView.trailingAnchor).active = true

    let bottom1 = notificationView.bottomAnchor.constraintEqualToAnchor(sharedInstance.view.topAnchor)
    bottom1.active = true
    let bottom2 = notificationView.bottomAnchor.constraintEqualToAnchor(sharedInstance.view.bottomAnchor)
    bottom2.active = false

    notificationView.layoutIfNeeded()

    UIView.animateWithDuration(0.2, delay: 0, options: .AllowUserInteraction, animations: {
      bottom1.active = false
      bottom2.active = true
      notificationView.setNeedsLayout()
      notificationView.layoutIfNeeded()
    }, completion: nil)

    UIView.animateWithDuration(0.2, delay: 7, options: .AllowUserInteraction, animations: { 
      bottom1.active = true
      bottom2.active = false
      notificationView.setNeedsLayout()
      notificationView.layoutIfNeeded()
    }, completion: { finished in
      notificationView.removeFromSuperview()
    })
  }

  private static var notificationHeight: CGFloat {
    return UIApplication.sharedApplication().windows.first?.traitCollection.verticalSizeClass == .Compact ? 44 : 64
  }

}
