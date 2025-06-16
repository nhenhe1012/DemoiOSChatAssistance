//
//  BaseViewModel.swift
//  Demo-iOS-Chat
//
//  Created by Tien Nguyen on 17/6/25.
//

import Foundation
import Combine

class BaseViewModel {
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    
    var cancellables = Set<AnyCancellable>()
    
    deinit {
        cancellables.removeAll()
    }
    
    init() {
        setupBindings()
    }
    
    // Common function.
    func setupBindings() { }
    
    func setLoading(_ loading: Bool) {
        DispatchQueue.main.async {
            self.isLoading = loading
        }
    }

    func setError(_ message: String) {
        DispatchQueue.main.async {
            self.errorMessage = message
        }
    }
    
}
