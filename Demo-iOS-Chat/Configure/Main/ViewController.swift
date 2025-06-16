//
//  ViewController.swift
//  Demo-iOS-Chat
//
//  Created by Tien Nguyen on 16/6/25.
//

import UIKit
import Combine

class ViewController: UIViewController {

    @IBOutlet weak var helloLabel: GradientTextLabel!
    @IBOutlet weak var infoLabel: UILabel!
    
    @IBOutlet weak var userButtonView: UIView!
    @IBOutlet weak var userButton: UIButton!
    
    @IBOutlet weak var assistantButtonView: UIView!
    @IBOutlet weak var assistantButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    private func setupView() {
        helloLabel.font = UIFont.boldSystemFont(ofSize: 36)
        helloLabel.gradientColors = [.systemPink, .purple, .blue]
        helloLabel.text = "Hello, User!"
        
        infoLabel.font = UIFont.systemFont(ofSize: 18)
        infoLabel.text = "Please Enter Username to start Chat!"
        
        
        userButton.titleLabel?.textColor = .white
        userButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        userButton.setTitle("Start at role of User", for: .normal)
        
        userButtonView.clipsToBounds = true
        userButtonView.layer.cornerRadius = userButtonView.frame.height / 2
        
        assistantButton.titleLabel?.textColor = .white
        assistantButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        assistantButton.setTitle("Start at role of Assistant", for: .normal)
        
        assistantButtonView.clipsToBounds = true
        assistantButtonView.layer.cornerRadius = assistantButtonView.frame.height / 2
        assistantButtonView.alpha = 0.3
    }
    
    @IBAction func startChatTapped(_ sender: Any) {
        let chatViewController = ChatViewController()
        self.navigationController?.pushViewController(chatViewController, animated: true)
    }
}

