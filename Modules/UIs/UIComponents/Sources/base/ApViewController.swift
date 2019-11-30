//
//  ApViewController.swift
//  UIComponents
//
//  Created by Alexander Ivlev on 26/10/2019.
//  Copyright © 2019 ApostleLife. All rights reserved.
//

import UIKit
import Design

open class ApViewController: UIViewController {
    public private(set) lazy var style: Style = styleMaker.makeStyle(for: self)

    private let styleMaker: StyleMaker = StyleMaker()

    private let stylizingViewsContainer = StylizingViewsContainer()

    public init() {
        super.init(nibName: nil, bundle: nil)
    }

    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func addViewForStylizing(_ view: StylizingView, immediately: Bool = true) {
        stylizingViewsContainer.addView(view, immediately: immediately)
    }

    open func styleDidChange(_ style: Style) {
        view.backgroundColor = style.colors.background

        navigationController?.navigationBar.barStyle = style.colors.barStyle
        navigationController?.navigationBar.tintColor = style.colors.tint

        stylizingViewsContainer.styleDidChange(style)
    }

    open override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)

        styleDidChange(style)

        if nil != navigationController?.presentingViewController {
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(tapDoneButton))
        }
    }

    open override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        style = styleMaker.makeStyle(for: self)
        styleDidChange(style)
    }

    @objc
    private func tapDoneButton() {
        navigationController?.dismiss(animated: true)
    }
}
