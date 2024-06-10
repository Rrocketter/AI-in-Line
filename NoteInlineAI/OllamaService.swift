//
//  OllamaService.swift
//  NoteInlineAI
//
//  Created by Rahul Gupta on 6/7/24.
//

import Foundation

struct Response: Codable {
    let model: String
    let response: String
}


class OllamaService {
    static let shared = OllamaService()
    
    func sendPrompt(prompt: String, completion: @escaping (String?) -> Void) {
        guard !prompt.isEmpty else {
            completion("Prompt is empty")
            return
        }

        print("Started Send Prompt")
        
        
        let urlString = "http://127.0.0.1:11434/api/generate"
        
        guard let url = URL(string: urlString) else {
            completion("Invalid URL")
            return
        }
        
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = [
            "model": "llama3",
            "prompt": prompt,
            "options": [
                "num_ctx": 4096
            ]
        ]
        
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    completion("Error: \(error.localizedDescription)")
                }
                return
            }
            
            
            guard let data = data else {
                DispatchQueue.main.async {
                    completion("No data received")
                }
                return
            }
            
            let decoder = JSONDecoder()
            let lines = data.split(separator: 10)
            var responses = [String]()
            
            
            for line in lines {
                if let jsonLine = try? decoder.decode(Response.self, from: Data(line)) {
                    responses.append(jsonLine.response)
                }
            }
            
            print(responses)
            
            DispatchQueue.main.async {
                let fullResponse = responses.joined(separator: "")
                print(fullResponse)
                completion(fullResponse)
            }
        }.resume()
    }
}
