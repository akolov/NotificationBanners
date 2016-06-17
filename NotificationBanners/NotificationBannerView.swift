//
//  NotificationBannerView.swift
//  NotificationBanners
//
//  Created by Alexander Kolov on 17/6/16.
//  Copyright © 2016 Alexander Kolov. All rights reserved.
//

import UIKit

public class NotificationBannerView: UIView {

  public init(title: String, text: String, image: UIImage?) {
    self.title = title
    self.text = text
    self.image = image
    super.init(frame: CGRect.zero)
    initialize()
  }

  public override init(frame: CGRect) {
    title = ""
    text = ""
    super.init(frame: frame)
    initialize()
  }
  
  public required init?(coder aDecoder: NSCoder) {
    title = ""
    text = ""
    super.init(coder: aDecoder)
    initialize()
  }

  // MARK: Properties

  private var title: String
  private var text: String?
  private var image: UIImage?

  private lazy var titleLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.boldSystemFontOfSize(13)
    label.textColor = UIColor.whiteColor()
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()

  private lazy var textLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.systemFontOfSize(13)
    label.lineBreakMode = .ByTruncatingTail
    label.numberOfLines = 2
    label.textColor = UIColor.whiteColor()
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()

  private lazy var imageView: UIImageView = {
    let imageView = UIImageView()
    imageView.contentMode = .ScaleAspectFit
    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.widthAnchor.constraintEqualToConstant(20).active = true
    imageView.heightAnchor.constraintEqualToConstant(20).active = true
    imageView.backgroundColor = UIColor.redColor()
    return imageView
  }()

  private lazy var effectView: UIVisualEffectView = {
    let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.Dark)
    let blurView = UIVisualEffectView(effect: blurEffect)
    blurView.translatesAutoresizingMaskIntoConstraints = false
    return blurView
  }()

  private lazy var _initialBottomConstraint: NSLayoutConstraint? = {
    return self.bottomAnchor.constraintEqualToAnchor(self.superview!.topAnchor)
  }()

  var initialBottomConstraint: NSLayoutConstraint? {
    guard let _ = superview else {
      return nil
    }

    return _initialBottomConstraint
  }

  private lazy var _finalBottomConstraint: NSLayoutConstraint? = {
    return self.bottomAnchor.constraintEqualToAnchor(self.superview!.bottomAnchor)
  }()

  var finalBottomConstraint: NSLayoutConstraint? {
    guard let _ = superview else {
      return nil
    }

    return _finalBottomConstraint
  }

  private lazy var _leadingConstraint: NSLayoutConstraint? = {
    return self.superview!.leadingAnchor.constraintEqualToAnchor(self.leadingAnchor)
  }()

  var leadingConstraint: NSLayoutConstraint? {
    guard let _ = superview else {
      return nil
    }

    return _leadingConstraint
  }

  private lazy var _trailingConstraint: NSLayoutConstraint? = {
    return self.trailingAnchor.constraintEqualToAnchor(self.superview!.trailingAnchor)
  }()

  var trailingConstraint: NSLayoutConstraint? {
    guard let _ = superview else {
      return nil
    }

    return _trailingConstraint
  }

}

// MARK: Internal methods

extension NotificationBannerView {

  @objc
  func didRecognizeSwipeGesture(sender: UISwipeGestureRecognizer) {
    guard sender.state == .Ended else {
      return
    }

    guard let notificationView = sender.view else {
      return
    }

    let bottom1 = notificationView.constraints.filter { $0.identifier == "bottom1" }.first
    let bottom2 = notificationView.constraints.filter { $0.identifier == "bottom2" }.first

    UIView.animateWithDuration(0.2, delay: 0, options: .AllowUserInteraction, animations: {
      bottom1?.active = true
      bottom2?.active = false
      notificationView.setNeedsLayout()
      notificationView.layoutIfNeeded()
      }, completion: { finished in
        notificationView.removeFromSuperview()
    })
  }

}

// MARK: Private methods

private extension NotificationBannerView {

  private func initialize() {
    addSubview(effectView)
    effectView.userInteractionEnabled = true
    effectView.layoutMargins = UIEdgeInsets(top: 8, left: 15, bottom: 8, right: 15)
    leadingAnchor.constraintEqualToAnchor(effectView.leadingAnchor).active = true
    trailingAnchor.constraintEqualToAnchor(effectView.trailingAnchor).active = true
    topAnchor.constraintEqualToAnchor(effectView.topAnchor).active = true
    bottomAnchor.constraintEqualToAnchor(effectView.bottomAnchor).active = true

    let labelsStackView = UIStackView(arrangedSubviews: [titleLabel, textLabel])
    labelsStackView.axis = .Vertical
    labelsStackView.alignment = .Leading
    labelsStackView.distribution = .Fill
    labelsStackView.translatesAutoresizingMaskIntoConstraints = false

    let stackView = UIStackView(arrangedSubviews: [imageView, labelsStackView])
    stackView.axis = .Horizontal
    stackView.alignment = .Leading
    stackView.distribution = .Fill
    stackView.spacing = 11
    stackView.translatesAutoresizingMaskIntoConstraints = false
    effectView.addSubview(stackView)

    effectView.layoutMarginsGuide.leadingAnchor.constraintEqualToAnchor(stackView.leadingAnchor).active = true
    stackView.trailingAnchor.constraintEqualToAnchor(effectView.layoutMarginsGuide.trailingAnchor).active = true
    effectView.layoutMarginsGuide.topAnchor.constraintEqualToAnchor(stackView.topAnchor).active = true
    stackView.bottomAnchor.constraintEqualToAnchor(effectView.layoutMarginsGuide.bottomAnchor).active = true

    imageView.image = image
    titleLabel.text = title
    textLabel.text = text

    let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didRecognizeSwipeGesture(_:)))
    tapGestureRecognizer.delegate = self
    addGestureRecognizer(tapGestureRecognizer)
  }

}

extension NotificationBannerView: UIGestureRecognizerDelegate {

  public func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {
    return true
  }

}
