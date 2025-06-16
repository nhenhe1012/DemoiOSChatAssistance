//
//  StoreService.swift
//  Demo-iOS-Chat
//
//  Created by Tien Nguyen on 18/6/25.
//

import FirebaseFirestore

class StoreService {
    static let shared = StoreService()
    
    private init() {}
    
    let firestore = Firestore.firestore()
    
    func addMessage(_ message: ChatMessage) {
        try? firestore.collection("conversions").document("a").setData(from: ChatMessage(text: "Tien", isIncoming: true))
    }
    
    func getMessages(completion: @escaping ([ChatMessage]) -> Void) {
        firestore.collection("conversions").document("a").getDocument() { document, error in
            
        }
        firestore.collection("conversions")
            .order(by: "createdAt", descending: true)
            .limit(to: 100)
            .addSnapshotListener { query, error in
            
        }
    }
}
