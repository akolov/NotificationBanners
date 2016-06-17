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

    let vibrancyEffect = UIVibrancyEffect(forBlurEffect: blurEffect)
    let vibrancyView = UIVisualEffectView(effect: vibrancyEffect)
    vibrancyView.translatesAutoresizingMaskIntoConstraints = false

    blurView.addSubview(vibrancyView)
    blurView.leadingAnchor.constraintEqualToAnchor(vibrancyView.leadingAnchor).active = true
    blurView.trailingAnchor.constraintEqualToAnchor(vibrancyView.trailingAnchor).active = true
    blurView.topAnchor.constraintEqualToAnchor(vibrancyView.topAnchor).active = true
    blurView.bottomAnchor.constraintEqualToAnchor(vibrancyView.bottomAnchor).active = true

    return blurView
  }()

}

// MARK: Private methods

private extension NotificationBannerView {

  private func initialize() {
    addSubview(effectView)
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
    addSubview(stackView)

    effectView.layoutMarginsGuide.leadingAnchor.constraintEqualToAnchor(stackView.leadingAnchor).active = true
    stackView.trailingAnchor.constraintEqualToAnchor(effectView.layoutMarginsGuide.trailingAnchor).active = true
    effectView.layoutMarginsGuide.topAnchor.constraintEqualToAnchor(stackView.topAnchor).active = true
    stackView.bottomAnchor.constraintEqualToAnchor(effectView.layoutMarginsGuide.bottomAnchor).active = true

    imageView.image = image
    titleLabel.text = title
    textLabel.text = text
  }

}