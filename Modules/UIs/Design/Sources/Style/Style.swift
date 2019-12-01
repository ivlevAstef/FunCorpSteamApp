//
//  Style.swift
//  Design
//
//  Created by Alexander Ivlev on 19/11/2019.
//  Copyright © 2019 ApostleLife. All rights reserved.
//

import UIKit

/// Style - it's collection of properties with colors, fonts, layouts and animation settings
public struct Style
{
    // MARK: - Colors
    public struct Colors {
        /// background.
        public let background: UIColor
        /// used for cell background or accent views on background
        public let accent: UIColor
        /// used for separate cell or other views. Also used for select cell
        public let separator: UIColor

        /// use for show skeleton loading
        public let skeleton: Gradient
        /// use for show skeleton failed loading
        public let skeletonFailed: UIColor

        /// used for navigation bar
        public let barStyle: UIBarStyle
        /// used for navigation bar buttons, or other small elements. for example icons
        public let tint: UIColor

        // MARK: - text
        /// main text
        public let mainText: UIColor
        /// not accent text
        public let notAccentText: UIColor
        /// more content text
        public let contentText: UIColor
        /// for blured views
        public let blurStyle: UIBlurEffect.Style

        public let shadowColor: UIColor
        public let shadowOpacity: Float
    }

    // MARK: - Fonts
    public struct Fonts {
        /// use for navigation bar large style
        public let navLarge: UIFont
        /// use for navigation bar default style
        public let navDefault: UIFont

        /// use into main cells into front gradient view
        public let large: UIFont

        /// use into generated avatar
        public let avatar: UIFont

        /// use into normal cells, title for articles and other accent
        public let title: UIFont
        /// used for additional information into cell
        public let subtitle: UIFont
        /// used for more text
        public let content: UIFont
    }

    // MARK: - Animation
    public struct Animation {
        public let animationTime: TimeInterval
        public let transitionTime: TimeInterval
    }

    // MARK: - Layout
    public struct Layout {
        public let safeAreaInsets: UIEdgeInsets
        public let innerInsets: UIEdgeInsets
        public let cellInnerInsets: UIEdgeInsets

        public let statusBarHeight: CGFloat
        public let navigationBarDefaultHeight: CGFloat
        /// Can be 0.0 - if this rotation or screen size not support larget height
        public let navigationBarLargeHeight: CGFloat
    }

    // MARK: -
    public let colors: Colors
    public let fonts: Fonts
    public let animation: Animation
    public let layout: Layout

    init(colors: Colors, fonts: Fonts, animation: Animation, layout: Layout) {
        self.colors = colors
        self.fonts = fonts
        self.animation = animation
        self.layout = layout
    }
}
