//
//  NotificationBannerController.swift
//  NotificationBanners
//
//  Created by Alexander Kolov on 17/6/16.
//  Copyright © 2016 Alexander Kolov. All rights reserved.
//

import UIKit

public class NotificationBannerController: UIViewController {

  public override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  public override func prefersStatusBarHidden() -> Bool {
    return statusBarHidden
  }

  public override func preferredStatusBarStyle() -> UIStatusBarStyle {
    return statusBarStyle
  }

  // MARK: Properties

  public var statusBarHidden = false {
    didSet {
      setNeedsStatusBarAppearanceUpdate()
    }
  }

  public var statusBarStyle: UIStatusBarStyle = .Default {
    didSet {
      setNeedsStatusBarAppearanceUpdate()
    }
  }

  public private(set) static var window: UIWindow?
  public static let sharedInstance = NotificationBannerController()

}

public extension NotificationBannerController {

  public static func showNotification(title: String, text: String, image: UIImage, action: (() -> Void)? = nil) {
    let height = notificationHeight

    if window == nil {
      let screen = UIScreen.mainScreen()
      window = UIWindow(frame: CGRect(x: 0, y: 0, width: screen.bounds.width, height: height))
      window?.windowLevel = UIWindowLevelStatusBar
      window?.rootViewController = sharedInstance
    }

    window?.makeKeyAndVisible()

    let notificationView = NotificationBannerView(title: title, text: text, image: image)
    notificationView.action = action
    notificationView.delegate = sharedInstance
    notificationView.translatesAutoresizingMaskIntoConstraints = false
    notificationView.userInteractionEnabled = true
    sharedInstance.view.addSubview(notificationView)

    notificationView.heightAnchor.constraintEqualToConstant(height).active = true
    notificationView.leadingConstraint?.active = true
    notificationView.trailingConstraint?.active = true
    notificationView.initialBottomConstraint?.active = true
    notificationView.finalBottomConstraint?.active = false
    notificationView.layoutIfNeeded()

    UIView.animateWithDuration(0.2, delay: 0, options: .AllowUserInteraction, animations: {
      notificationView.initialBottomConstraint?.active = false
      notificationView.finalBottomConstraint?.active = true
      notificationView.setNeedsLayout()
      notificationView.layoutIfNeeded()
    }, completion: { finished in
      let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(7 * Double(NSEC_PER_SEC)))
      dispatch_after(delayTime, dispatch_get_main_queue()) { [weak notificationView] in
        notificationView?.dismiss(animated: true)
      }
    })

    let swipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(didRecognizeSwipeGesture(_:)))
    swipeGestureRecognizer.direction = .Up
    notificationView.addGestureRecognizer(swipeGestureRecognizer)
  }

  @objc
  public static func didRecognizeSwipeGesture(sender: UISwipeGestureRecognizer) {
    guard sender.state == .Ended else {
      return
    }

    guard let notificationView = sender.view as? NotificationBannerView else {
      return
    }

    notificationView.dismiss(animated: true)
  }

  private static var notificationHeight: CGFloat {
    return UIApplication.sharedApplication().windows.first?.traitCollection.verticalSizeClass == .Compact ? 44 : 64
  }

}

extension NotificationBannerController: NotificationBannerViewDelegate {

  func notificationBannerViewWasRemovedFromSuperview(view: NotificationBannerView) {
    if NotificationBannerController.sharedInstance.view.subviews.count == 0 {
      NotificationBannerController.window?.hidden = true
      NotificationBannerController.window = nil
    }
  }

}
