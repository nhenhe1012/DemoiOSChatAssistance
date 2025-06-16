//
//  RequestLLM.swift
//  Demo-iOS-Chat
//
//  Created by Tien Nguyen on 17/6/25.
//

import Foundation

enum LLMModel: String {
    case deepseek_V3 =                      "deepseek/deepseek-chat:free"
    case deepseek_R1_distill_llama_70b =    "deepseek/deepseek-r1-distill-llama-70b:free"
    case deepseek_R1_0528_qwen3 =           "deepseek/deepseek-r1-0528-qwen3-8b:free"
    case deepseek_R1_0528 =                 "deepseek/deepseek-r1-0528:free"
    case deepseek_R1 =                      "deepseek/deepseek-r1:free"
    
    case gemini_2_0_flash_exp =             "google/gemini-2.0-flash-exp:free"
    
    case meta_llama3_3 =                    "meta-llama/llama-3.3-8b-instruct:free"
    
    case nvidia_llama3_3 =                  "nvidia/llama-3.3-nemotron-super-49b-v1:free"
    case nvidia_llama3_1 =                  "nvidia/llama-3.1-nemotron-ultra-253b-v1:free"
}

struct ChatPostRequest: APIRequest {
    var baseUrl: URL { URL(string: "https://openrouter.ai/api/v1/chat/completions")! }
    var method: HTTPMethod { .POST }
    var headers: [String : String]? { ["content-type": "application/json",
                                       "Authorization": "Bearer \(apiKey)"] }
    var body: Data?
    
    func requestChat(completion: @escaping (Result<RouterAIChatResponse, NetworkError>) -> Void) {
        NetworkManager.shared.request(self, completion: completion)
    }
}
