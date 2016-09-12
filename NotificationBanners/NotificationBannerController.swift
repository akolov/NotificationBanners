//
//  NotificationBannerController.swift
//  NotificationBanners
//
//  Created by Alexander Kolov on 17/6/16.
//  Copyright © 2016 Alexander Kolov. All rights reserved.
//

import UIKit

open class NotificationBannerController: UIViewController {

  open override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  open override var prefersStatusBarHidden : Bool {
    return statusBarHidden
  }

  open override var preferredStatusBarStyle : UIStatusBarStyle {
    return statusBarStyle
  }

  // MARK: Properties

  open var statusBarHidden = false {
    didSet {
      setNeedsStatusBarAppearanceUpdate()
    }
  }

  open var statusBarStyle: UIStatusBarStyle = .default {
    didSet {
      setNeedsStatusBarAppearanceUpdate()
    }
  }

  open fileprivate(set) static var window: UIWindow?
  open static let sharedInstance = NotificationBannerController()

}

public extension NotificationBannerController {

  public static func showNotification(_ title: String, text: String, image: UIImage, action: (() -> Void)? = nil) {
    let height = notificationHeight

    if window == nil {
      let screen = UIScreen.main
      window = UIWindow(frame: CGRect(x: 0, y: 0, width: screen.bounds.width, height: height))
      window?.windowLevel = UIWindowLevelStatusBar
      window?.rootViewController = sharedInstance
    }

    window?.makeKeyAndVisible()

    let notificationView = NotificationBannerView(title: title, text: text, image: image)
    notificationView.action = action
    notificationView.delegate = sharedInstance
    notificationView.translatesAutoresizingMaskIntoConstraints = false
    notificationView.isUserInteractionEnabled = true
    sharedInstance.view.addSubview(notificationView)

    notificationView.heightAnchor.constraint(equalToConstant: height).isActive = true
    notificationView.leadingConstraint?.isActive = true
    notificationView.trailingConstraint?.isActive = true
    notificationView.initialBottomConstraint?.isActive = true
    notificationView.finalBottomConstraint?.isActive = false
    notificationView.layoutIfNeeded()

    UIView.animate(withDuration: 0.2, delay: 0, options: .allowUserInteraction, animations: {
      notificationView.initialBottomConstraint?.isActive = false
      notificationView.finalBottomConstraint?.isActive = true
      notificationView.setNeedsLayout()
      notificationView.layoutIfNeeded()
    }, completion: { finished in
      let delayTime = DispatchTime.now() + Double(Int64(7 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
      DispatchQueue.main.asyncAfter(deadline: delayTime) { [weak notificationView] in
        notificationView?.dismiss(animated: true)
      }
    })

    let swipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(didRecognizeSwipeGesture(_:)))
    swipeGestureRecognizer.direction = .up
    notificationView.addGestureRecognizer(swipeGestureRecognizer)
  }

  @objc
  public static func didRecognizeSwipeGesture(_ sender: UISwipeGestureRecognizer) {
    guard sender.state == .ended else {
      return
    }

    guard let notificationView = sender.view as? NotificationBannerView else {
      return
    }

    notificationView.dismiss(animated: true)
  }

  fileprivate static var notificationHeight: CGFloat {
    return UIApplication.shared.windows.first?.traitCollection.verticalSizeClass == .compact ? 44 : 64
  }

}

extension NotificationBannerController: NotificationBannerViewDelegate {

  func notificationBannerViewWasRemovedFromSuperview(_ view: NotificationBannerView) {
    if NotificationBannerController.sharedInstance.view.subviews.count == 0 {
      NotificationBannerController.window?.isHidden = true
      NotificationBannerController.window = nil
    }
  }

}
