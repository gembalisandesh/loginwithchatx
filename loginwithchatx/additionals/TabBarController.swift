////
////  TabBarController.swift
////  loginwithchatx
////
////  Created by admin on 16/04/24.
////
//
//import UIKit
//import CometChatSDK
//
//
//
//class TabBarController: UITabBarController, UITabBarControllerDelegate {
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        self.tabBarController?.delegate = self
//        
//
//        
//    }
//    override func viewWillAppear(_ animated: Bool) {
//        self.tabBarController?.delegate = self
//        configurations()
//        self.tabBarController?.delegate = self
//
//    }
//    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
//           // Determine the selected index
//           if let index = tabBarController.viewControllers?.firstIndex(of: viewController) {
//               // Update title based on index
//               switch index {
//               case 0:
//                   tabBarController.title = "Chat"
//               case 1:
//                   tabBarController.title = "User"
//               case 2:
//                   tabBarController.title = "Group"
//               // Add cases for other tabs as needed
//               default:
//                   break
//               }
//           }
//       }
//    private func configurations() {
//        setViewControllers([conversationNavigationController(), usersNavigationController(), groupNavigationController()], animated: false)
//        
//    }
//    func conversationNavigationController() -> UIViewController {
//        let VC1 = CometChatConversationsWithMessages()
//        VC1.tabBarItem.image = UIImage(systemName: "message")
//        VC1.title = "Conversations"
//        
//        return VC1
//    }
//    func usersNavigationController() -> UIViewController {
//        let VC2 = CometChatUsersWithMessages()
//        VC2.tabBarItem.image = UIImage(systemName: "person")
//        VC2.title = "Users"
//        return VC2
//    }
//
//    func groupNavigationController() -> UIViewController {
//        let VC3 = CometChatGroupsWithMessages()
//        VC3.tabBarItem.image = UIImage(systemName: "person.2.square.stack")
//        VC3.title = "Group"
//        
//        return VC3
//    }
//
//    
//    
//
//    /*
//    // MARK: - Navigation
//
//    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        // Get the new view controller using segue.destination.
//        // Pass the selected object to the new view controller.
//    }
//    */
//
//}
