////
////  TabBarViewController.swift
////  loginwithchatx
////
////  Created by Sandesh on 22/04/24.
////
//
//import UIKit
//
//class TabBarViewController: UITabBarController,UITabBarControllerDelegate {
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        self.tabBarController?.delegate = self
//        configurations()
//        
//    }
//    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController){
//           if let index = tabBarController.viewControllers?.firstIndex(of: viewController) {
//               switch index {
//               case 0:
//                   tabBarController.title = "Chat"
//               case 1:
//                   tabBarController.title = "Group"
//               default:
//                   break
//               }
//           }
//       }
//    private func configurations() {
//        setViewControllers([textNavigationController(), groupNavigationController()], animated: false)
//        
//    }
//    func textNavigationController() -> UIViewController {
//        let VC1 = TextAreaViewController()
//        VC1.tabBarItem.image = UIImage(systemName: "message")
//        VC1.title = "Conversations"
//        
//        return VC1
//    }
//    func groupNavigationController() -> UIViewController {
//        let VC2 = GroupAreaViewController()
//        VC2.tabBarItem.image = UIImage(systemName: "person.2.square.stack")
//        VC2.title = "Groups"
//        return VC2
//    }
//}
