import Foundation
import Combine

protocol ApiServiceManagerProtocol {
    func makeRequest<T: ApiService>(request: T) -> AnyPublisher<T.Response, ApiError>
}

class NetworkManager: NSObject, ApiServiceManagerProtocol {
 
    final let serverBaseUrl = "https://gist.githubusercontent.com/adriga"
    
    func makeRequest<T: ApiService>(request: T) -> AnyPublisher<T.Response, ApiError> {
        let urlSession = URLSession(configuration: .default, delegate: self, delegateQueue: nil)
        let request = RequestHelper.getUrlRequest(url: serverBaseUrl + request.resourceName, body: request.body, operationType: request.operationType)
        guard let request = request else {
            return Fail(error: ApiError.badRequest).eraseToAnyPublisher()
        }
        return urlSession.dataTaskPublisher(for: request)
            .tryMap { (data, response) in
                guard let response = response as? HTTPURLResponse,
                      response.statusCode == 200 else {
                          throw ApiError.badResponse
                }
                return data
            }
            .decode(type: T.Response.self, decoder: JSONDecoder())
            .mapError { error in
                if let error = error as? ApiError {
                    return error
                } else {
                    return ApiError.decodeError
                }
            }
            .eraseToAnyPublisher()
    }
    
}

extension NetworkManager: URLSessionDelegate {
    
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {

        guard let serverTrust = challenge.protectionSpace.serverTrust,
              let serverCertificateData = getServerCertificateData(from: serverTrust) else {
                  completionHandler(.cancelAuthenticationChallenge, nil)
                  return
        }
        guard let localCertificateData = getLocalCertificateData() else {
            completionHandler(.cancelAuthenticationChallenge, nil)
            return
        }
        let isServerTrusted = SecTrustEvaluateWithError(serverTrust, nil)
        if isServerTrusted && serverCertificateData == (localCertificateData as Data) {
            let credential = URLCredential(trust: serverTrust)
            completionHandler(.useCredential, credential)
        }
        else {
            completionHandler(.cancelAuthenticationChallenge, nil)
        }

    }
}

private extension NetworkManager {
    
    func getServerCertificateData(from serverTrust: SecTrust) -> Data? {
        guard let serverCertificates = SecTrustCopyCertificateChain(serverTrust) as? [SecCertificate],
              let serverCertificate = serverCertificates.first else {
                  return nil
        }
        return getData(from: serverCertificate)
    }
    
    func getData(from certificate: SecCertificate) -> Data {
        let serverCertificateCFData = SecCertificateCopyData(certificate)
        let data = CFDataGetBytePtr(serverCertificateCFData)
        let size = CFDataGetLength(serverCertificateCFData)
        let serverCertificateData = NSData(bytes: data, length: size)
        return serverCertificateData as Data
    }
    
    func getLocalCertificateData() -> NSData? {
        guard let pathToCertificate = Bundle.main.path(forResource: "www.github.com", ofType: "cer"),
              let localCertificateData = NSData(contentsOfFile: pathToCertificate) else {
                  return nil
        }
        return localCertificateData
    }
}
