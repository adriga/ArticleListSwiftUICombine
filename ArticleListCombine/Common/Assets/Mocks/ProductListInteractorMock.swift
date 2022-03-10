import Foundation
import Combine

class ProductListInteractorMock: ProductListInteractorProtocol {
    
    var returnError = false
    var products = [ProductEntity(code: "KEYCHAIN", name: "Marvel Keychain", price: "5"), ProductEntity(code: "TSHIRT", name: "Marvel T-Shirt", price: "20")]
    var error: ApiError = .badResponse

    func getAllProducts() -> AnyPublisher<[ProductEntity], ApiError> {
        return Future<[ProductEntity], ApiError> { resolve in
            if self.returnError {
                resolve(.failure(self.error))
            } else {
                resolve(.success(self.products))
            }
        }.eraseToAnyPublisher()
    }
}
