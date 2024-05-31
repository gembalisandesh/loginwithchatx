////
////  ConversationViewController.swift
////  loginwithchatx
////
////  Created by admin on 16/04/24.
////
//
//import UIKit
//import CometChatSDK
//
//
//class ConversationViewController: UIViewController {
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        addTitleLabel()
//
//        // Do any additional setup after loading the view.
//    }
//    override func viewWillAppear(_ animated: Bool) {
//        addTitleLabel()
//        let cometChatConversationsWithMessages = CometChatConversationsWithMessages()
////l        let naviVC = UINavigationController(rootViewController: cometChatConversationsWithMessages)
//        
//        self.navigationController?.pushViewController(cometChatConversationsWithMessages, animated: true)
//        
//        
//    }
//    private func addTitleLabel() {
//        let titleLabel = UILabel(frame: CGRect(x: 0, y: 100, width: view.frame.width, height: 50))
//        titleLabel.textAlignment = .center
//        titleLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
//        titleLabel.text = "Conversations"
//        view.addSubview(titleLabel)
//    }
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
