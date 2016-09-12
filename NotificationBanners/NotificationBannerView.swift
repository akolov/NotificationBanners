//
//  NotificationBannerView.swift
//  NotificationBanners
//
//  Created by Alexander Kolov on 17/6/16.
//  Copyright © 2016 Alexander Kolov. All rights reserved.
//

import UIKit

final class NotificationBannerView: UIView {

  init(title: String, text: String, image: UIImage?) {
    self.title = title
    self.text = text
    self.image = image
    super.init(frame: CGRect.zero)
    initialize()
  }

  override init(frame: CGRect) {
    title = ""
    text = ""
    super.init(frame: frame)
    initialize()
  }
  
  required init?(coder aDecoder: NSCoder) {
    title = ""
    text = ""
    super.init(coder: aDecoder)
    initialize()
  }

  override func didMoveToSuperview() {
    super.didMoveToSuperview()
    if superview == nil {
      delegate?.notificationBannerViewWasRemovedFromSuperview(self)
    }
  }

  // MARK: Properties

  fileprivate var title: String
  fileprivate var text: String?
  fileprivate var image: UIImage?
  var action: (() -> Void)?
  weak var delegate: NotificationBannerViewDelegate?

  fileprivate lazy var titleLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.boldSystemFont(ofSize: 13)
    label.textColor = UIColor.white
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()

  fileprivate lazy var textLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.systemFont(ofSize: 13)
    label.lineBreakMode = .byTruncatingTail
    label.numberOfLines = 2
    label.textColor = UIColor.white
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()

  fileprivate lazy var imageView: UIImageView = {
    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFit
    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.widthAnchor.constraint(equalToConstant: 20).isActive = true
    imageView.heightAnchor.constraint(equalToConstant: 20).isActive = true
    imageView.backgroundColor = UIColor.red
    return imageView
  }()

  fileprivate lazy var effectView: UIVisualEffectView = {
    let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
    let blurView = UIVisualEffectView(effect: blurEffect)
    blurView.translatesAutoresizingMaskIntoConstraints = false
    return blurView
  }()

  fileprivate lazy var _initialBottomConstraint: NSLayoutConstraint? = {
    return self.bottomAnchor.constraint(equalTo: self.superview!.topAnchor)
  }()

  var initialBottomConstraint: NSLayoutConstraint? {
    guard let _ = superview else {
      return nil
    }

    return _initialBottomConstraint
  }

  fileprivate lazy var _finalBottomConstraint: NSLayoutConstraint? = {
    return self.bottomAnchor.constraint(equalTo: self.superview!.bottomAnchor)
  }()

  var finalBottomConstraint: NSLayoutConstraint? {
    guard let _ = superview else {
      return nil
    }

    return _finalBottomConstraint
  }

  fileprivate lazy var _leadingConstraint: NSLayoutConstraint? = {
    return self.superview!.leadingAnchor.constraint(equalTo: self.leadingAnchor)
  }()

  var leadingConstraint: NSLayoutConstraint? {
    guard let _ = superview else {
      return nil
    }

    return _leadingConstraint
  }

  fileprivate lazy var _trailingConstraint: NSLayoutConstraint? = {
    return self.trailingAnchor.constraint(equalTo: self.superview!.trailingAnchor)
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
  func didRecognizeTapGesture(_ sender: UITapGestureRecognizer) {
    guard sender.state == .ended else {
      return
    }

    action?()
    dismiss(animated: true)
  }

  func dismiss(animated: Bool) {
    if animated {
      layoutIfNeeded()
      UIView.animate(withDuration: 0.2, delay: 0, options: .allowUserInteraction, animations: {
        self.finalBottomConstraint?.isActive = false
        self.initialBottomConstraint?.isActive = true
        self.setNeedsLayout()
        self.layoutIfNeeded()
      }, completion: { finished in
        self.removeFromSuperview()
      })
    }
    else {
      removeFromSuperview()
    }
  }

}

// MARK: Private methods

private extension NotificationBannerView {

  func initialize() {
    addSubview(effectView)
    effectView.isUserInteractionEnabled = true
    effectView.layoutMargins = UIEdgeInsets(top: 8, left: 15, bottom: 8, right: 15)
    leadingAnchor.constraint(equalTo: effectView.leadingAnchor).isActive = true
    trailingAnchor.constraint(equalTo: effectView.trailingAnchor).isActive = true
    topAnchor.constraint(equalTo: effectView.topAnchor).isActive = true
    bottomAnchor.constraint(equalTo: effectView.bottomAnchor).isActive = true

    let labelsStackView = UIStackView(arrangedSubviews: [titleLabel, textLabel])
    labelsStackView.axis = .vertical
    labelsStackView.alignment = .leading
    labelsStackView.distribution = .fill
    labelsStackView.translatesAutoresizingMaskIntoConstraints = false

    let stackView = UIStackView(arrangedSubviews: [imageView, labelsStackView])
    stackView.axis = .horizontal
    stackView.alignment = .leading
    stackView.distribution = .fill
    stackView.spacing = 11
    stackView.translatesAutoresizingMaskIntoConstraints = false
    effectView.addSubview(stackView)

    effectView.layoutMarginsGuide.leadingAnchor.constraint(equalTo: stackView.leadingAnchor).isActive = true
    stackView.trailingAnchor.constraint(equalTo: effectView.layoutMarginsGuide.trailingAnchor).isActive = true
    effectView.layoutMarginsGuide.topAnchor.constraint(equalTo: stackView.topAnchor).isActive = true
    stackView.bottomAnchor.constraint(equalTo: effectView.layoutMarginsGuide.bottomAnchor).isActive = true

    imageView.image = image
    titleLabel.text = title
    textLabel.text = text

    let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didRecognizeTapGesture(_:)))
    addGestureRecognizer(tapGestureRecognizer)
  }

}

protocol NotificationBannerViewDelegate: class {

  func notificationBannerViewWasRemovedFromSuperview(_ view: NotificationBannerView)

}
