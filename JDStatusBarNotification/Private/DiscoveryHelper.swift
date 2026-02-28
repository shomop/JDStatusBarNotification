//
//  DiscoveryHelper.swift
//  JDStatusBarNotification
//
//  Created by Markus on 11/12/23.
//  Copyright © 2023 Markus. All rights reserved.
//

import Foundation
import UIKit

enum DiscoveryHelper {

  static func discoverMainWindowScene() -> UIWindowScene? {
    return discoverMainWindow()?.windowScene
  }

  static func discoverMainWindow(ignoring ignoredWindow: UIWindow? = nil) -> UIWindow? {
    // Collect windows from connected scenes to avoid deprecated/global APIs
    var allWindows: [UIWindow];
    if let ignoredWindow, let windowScene = ignoredWindow.windowScene {
      allWindows = windowScene.windows;
    } else {
      allWindows = UIApplication.shared.connectedScenes
        .compactMap { $0 as? UIWindowScene }
        .flatMap { $0.windows };
    }

    // Prefer the key window if available (this avoids attaching to PiP windows)
    if let key = allWindows.first(where: { $0.isKeyWindow && !$0.isHidden && $0 != ignoredWindow }) {
      return key;
    }

    // Prefer a window that belongs to a foreground-active application scene
    if let foreground = allWindows.first(where: { !$0.isHidden && $0 != ignoredWindow && $0.windowScene?.activationState == .foregroundActive }) {
      return foreground;
    }

    // Fallback to the first non-hidden window
    for window in allWindows {
      if (!window.isHidden && window != ignoredWindow) {
        return window;
      }
    }
    return nil;
  }

  static func discoverMainViewController(ignoring viewController: UIViewController) -> UIViewController? {
    let mainAppWindow = discoverMainWindow(ignoring: viewController.view.window);
    guard let mainAppWindow else { return nil }

    var topController = mainAppWindow.rootViewController;
    guard let _ = topController else { return nil }

    while let presentedViewController = topController?.presentedViewController {
      topController = presentedViewController;
    }

    if let tc = topController, tc.responds(to: #selector(getter: UINavigationController.topViewController)) {
      topController = (topController as? UINavigationController)?.topViewController;
    }

    // ensure we never end up with recursive calls
    return (topController == viewController) ? nil : topController;
  }
}
