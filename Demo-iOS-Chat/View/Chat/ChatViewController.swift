//
//  ChatViewController.swift
//  Demo-iOS-Chat
//
//  Created by Tien Nguyen on 17/6/25.
//

import UIKit

class ChatViewController: UIViewController {
    
    private let viewModel = ChatViewViewModel()
    
    @IBOutlet weak var warningLabel:UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageInputContainerView:UIView!
    @IBOutlet weak var messageTextField:UITextView!
    @IBOutlet weak var messageTextFieldHeight:NSLayoutConstraint!
    @IBOutlet weak var sendButton:UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupViewModel()
        addNotificationObserver()
        scrollToBottom(animated: false)
    }
    
    private func addNotificationObserver() {
        // Keyboard Notifications
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleKeyboard),
                                               name: UIResponder.keyboardWillChangeFrameNotification,
                                               object: nil)
        
        sendButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSend)))
        sendButton.isUserInteractionEnabled = true
    }
    
    private func setupViewModel() {
        viewModel.messageUpdated.sink { [weak self] _ in
            self?.tableView.reloadData()
            self?.scrollToBottom(animated: true)
        }.store(in: &viewModel.cancellables)
    }

    private func setupUI() {
        view.backgroundColor = .white
        navigationItem.title = "Chat"

        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.keyboardDismissMode = .onDrag
        tableView.register(UINib(nibName: "AssistantCell", bundle: nil), forCellReuseIdentifier: "AssistantCell")
        tableView.register(UINib(nibName: "UserCell", bundle: nil), forCellReuseIdentifier: "UserCell")

        messageTextField.layer.cornerRadius = 8
        messageTextField.layer.masksToBounds = true
        messageTextField.layer.borderWidth = 1
        messageTextField.layer.borderColor = UIColor.lightGray.cgColor
        messageTextField.textContainerInset = .init(top: 8, left: 8, bottom: 8, right: 8)
        messageTextField.contentInset = .zero
        messageTextField.delegate = self
        messageTextField.translatesAutoresizingMaskIntoConstraints = false
        
        warningLabel.font = UIFont.systemFont(ofSize: 14)
        warningLabel.textColor = .lightGray
        warningLabel.numberOfLines = 0
        warningLabel.text = "Assistant is not available 24/7. Please note that this is a demo app and can make mistakes. Check important info or click here for connect to a human assistant."
        
        messageInputContainerView.backgroundColor = .systemGray6.withAlphaComponent(0.9)
        
        resetChatInput()
    }

    @objc private func handleKeyboard(notification: Notification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }

        let isKeyboardVisible = keyboardFrame.origin.y < UIScreen.main.bounds.height
        let bottomPadding = isKeyboardVisible ? keyboardFrame.height - view.safeAreaInsets.bottom : 0

        UIView.animate(withDuration: 0.25) {
            self.messageInputContainerView.transform = CGAffineTransform(translationX: 0, y: -bottomPadding)
        }
    }

    @objc private func handleSend() {
        guard let text = messageTextField.text, !text.isEmpty else { return }

        viewModel.sendMessage(text)
        resetChatInput()
    }
    
    private func resetChatInput() {
        messageTextField.text = ""
        UIView.animate(withDuration: 0.25) {
            self.messageTextFieldHeight.constant = 33
            self.view.layoutIfNeeded()
        }
    }

    func scrollToBottom(animated: Bool) {
        guard viewModel.messages.count > 0 else { return }
        let lastIndex = IndexPath(row: viewModel.messages.count - 1, section: 0)
        tableView.scrollToRow(at: lastIndex, at: .bottom, animated: animated)
    }

}

extension ChatViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        messageTextFieldHeight.constant = textView.contentSize.height
        view.layoutIfNeeded()
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = (textView.text as NSString?)?.replacingCharacters(in: range, with: text) ?? ""
        return newText.count <= 255
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        return true
    }
}

extension ChatViewController: UITableViewDelegate, UITableViewDataSource {
    // MARK: - TableView

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.messages.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = viewModel.messages[indexPath.row]
        let identifier = !message.isIncoming ? "UserCell" : "AssistantCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! ChatCell
        cell.configure(message: message.text)
        return cell
    }
}
