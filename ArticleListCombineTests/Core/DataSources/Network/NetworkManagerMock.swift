import Combine
@testable import ArticleListCombine

class NetworkManagerMock: ApiServiceManagerProtocol {
    
    var returnError = false
    var responseDto: Decodable = ProductsDTO(products: [ProductDTO(code: "KEYCHAIN", name: "Marvel Keychain", price: 5), ProductDTO(code: "TSHIRT", name: "T-Shirt", price: 20)])
    var responseError: ApiError = .badResponse
    
    func makeRequest<T: ApiService>(request: T) -> AnyPublisher<T.Response, ApiError> {
        return Future<T.Response, ApiError> { resolve in
            if self.returnError {
                resolve(.failure(self.responseError))
            } else {
                resolve(.success(self.responseDto as! T.Response))
            }
        }.eraseToAnyPublisher()
    }
}
