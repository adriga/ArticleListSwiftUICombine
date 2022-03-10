import Foundation

struct RequestHelper {
    
    static func getUrlRequest(url: String, body: [String: Any]?, operationType: String) -> URLRequest? {
        guard let url = URL(string: url) else {
            return nil
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = operationType
        urlRequest.timeoutInterval = 30
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        guard body == nil else {
            do {
                let encodedBody = try JSONSerialization.data(withJSONObject: body as Any, options: [])
                urlRequest.httpBody = encodedBody
                return urlRequest
            } catch {
                return nil
            }
        }
        return urlRequest
    }
    
}
