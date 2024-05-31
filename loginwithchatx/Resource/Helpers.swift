//
//  Helpers.swift
//  loginwithchatx
//
//  Created by Sandesh on 29/05/24.
//

import Foundation
import UIKit
import CometChatSDK

public class Helpers {
    public static func dismissCallsSenderViewController(from viewController: UIViewController) {
        if let presentedViewController = viewController.presentedViewController {
            dismissCallsSenderViewController(from: presentedViewController)
        } else if let navController = viewController as? UINavigationController,
                  let topViewController = navController.topViewController {
            dismissCallsSenderViewController(from: topViewController)
        } else if let callsSenderViewController = viewController as? CallsSenderViewController {
            callsSenderViewController.dismiss(animated: true, completion: {
                print("CallsSenderViewController dismissed after call rejection.")
            })
        }
    }
    public static func dismissCallsViewController(from viewController: UIViewController) {
        if let presentedViewController = viewController.presentedViewController {
            dismissCallsViewController(from: presentedViewController)
        } else if let navController = viewController as? UINavigationController,
                  let topViewController = navController.topViewController {
            dismissCallsViewController(from: topViewController)
        } else if let callsViewController = viewController as? CallsViewController {
            callsViewController.dismiss(animated: true, completion: {
                print("CallsViewController dismissed after call cancellation.")
            })
        }
    }
    public static func getUser(forUID uid: String, completion: @escaping (User?) -> Void) {
        CometChat.getUser(UID: uid, onSuccess: { user in
            completion(user)
        }) { error in
            print("User fetching failed with error: \(error?.errorDescription ?? "Unknown error")")
            completion(nil)
        }
    }
}
