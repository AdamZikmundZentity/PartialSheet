//
//  EnvironmentValues+SafeAreaInsets.swift
//
//  Created by Andrea Miotto on 15/09/21.
//  Copyright © 2021 Swift. All rights reserved.
//

import SwiftUI

extension EnvironmentValues {
    var safeAreaInsets: EdgeInsets {
        self[SafeAreaInsetsKey.self]
    }
}

private struct SafeAreaInsetsKey: EnvironmentKey {
    static var defaultValue: EdgeInsets {
        var insets = UIApplication.shared.keyWindow?.safeAreaInsets.swiftUiInsets ?? EdgeInsets()
        if UIApplication.shared.statusBarHeightOverlap == 0 {
            insets.top = 0
        }
        return insets
    }
}

private extension UIApplication {
    var keyWindow: UIWindow? {
        connectedScenes
            .compactMap {  $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first { $0.isKeyWindow }
    }

    var statusBarHeightOverlap: CGFloat {
        guard let topViewController = topViewController,
              let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first(where: \.isKeyWindow),
              let statusBarManager = windowScene.statusBarManager else {
            return 0
        }

        let statusBarFrame = statusBarManager.statusBarFrame
        let convertedViewFrame = topViewController.view.convert(topViewController.view.bounds, to: window)
        return statusBarFrame.intersection(convertedViewFrame).height
    }

    var topViewController: UIViewController? {
        guard let window = topWindow else {
            return nil
        }

        var top = window.rootViewController
        while top?.presentedViewController != nil {
            top = top?.presentedViewController
        }
        return top
    }

    var topWindow: UIWindow? {
        guard let scene = connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene,
              let window = scene.windows.first(where: \.isKeyWindow) else {
            return nil
        }

        return window
    }
}

private extension UIEdgeInsets {
    var swiftUiInsets: EdgeInsets {
        EdgeInsets(top: top, leading: left, bottom: bottom, trailing: right)
    }
}
