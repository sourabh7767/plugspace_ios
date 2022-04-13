//
//  BadgeButton.swift
//  AtU
//
//  Created by MAC on 17/04/20.
//  Copyright © 2020 Mayank. All rights reserved.
//

import UIKit

class BadgeButton: UIButton {

    var badgeLabel = UILabel()

    var badge: String? {
        didSet {
            addBadgetoButton(badge: badge)
        }
    }

    public var badgeBackgroundColor = UIColor.red {
        didSet {
            badgeLabel.backgroundColor = badgeBackgroundColor
        }
    }

    public var badgeTextColor = UIColor.white {
        didSet {
            badgeLabel.textColor = badgeTextColor
        }
    }

    public var badgeFont = UIFont.systemFont(ofSize: 12.0) {
        didSet {
            badgeLabel.font = badgeFont
        }
    }

    public var badgeEdgeInsets: UIEdgeInsets? {
        didSet {
            addBadgetoButton(badge: badge)
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        addBadgetoButton(badge: nil)
    }

    func addBadgetoButton(badge: String?) {
        badgeLabel.text = badge
        badgeLabel.textColor = badgeTextColor
        badgeLabel.backgroundColor = badgeBackgroundColor
        badgeLabel.font = badgeFont
        badgeLabel.sizeToFit()
        badgeLabel.textAlignment = .center
        let badgeSize = badgeLabel.frame.size

        let height = max(5, Double(badgeSize.height) + 5.0)
        let width = height //max(height, Double(badgeSize.width) + 5.0)

        var vertical: Double?, horizontal: Double?
        if let badgeInset = self.badgeEdgeInsets {
            vertical = Double(badgeInset.top) - Double(badgeInset.bottom)
            horizontal = Double(badgeInset.left) - Double(badgeInset.right)

            let x = (Double(bounds.size.width) - 10 + horizontal!)
            let y = -(Double(badgeSize.height) / 2) - 10 + vertical!
            badgeLabel.frame = CGRect(x: x, y: y, width: width, height: height)
        } else {
            let x = self.frame.width - CGFloat(35)
            let y: CGFloat = CGFloat(-(height / 3.0))
            badgeLabel.frame = CGRect(x: x, y: y, width: CGFloat(width), height: CGFloat(height))
        }

        badgeLabel.layer.cornerRadius = badgeLabel.frame.height/2
        badgeLabel.layer.masksToBounds = true
        addSubview(badgeLabel)
        badgeLabel.isHidden = badge != nil ? false : true
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.addBadgetoButton(badge: nil)
//        fatalError("init(coder:) is not implemented")
    }
}
