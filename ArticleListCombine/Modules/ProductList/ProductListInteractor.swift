import Foundation
import Combine

protocol ProductListInteractorProtocol {
    func getAllProducts() -> AnyPublisher<[ProductEntity], ApiError>
}

class ProductListInteractor {
    
    var networkManager: ApiServiceManagerProtocol
    
    init(networkManager: ApiServiceManagerProtocol) {
        self.networkManager = networkManager
    }
}

extension ProductListInteractor: ProductListInteractorProtocol {
    
    func getAllProducts() -> AnyPublisher<[ProductEntity], ApiError> {
        return networkManager
            .makeRequest(request: GetProductsApiService())
            .map { productsDTO -> [ProductEntity] in
                return productsDTO.products.map { ProductEntity(dto: $0) }
            }
            .eraseToAnyPublisher()
    }
}
