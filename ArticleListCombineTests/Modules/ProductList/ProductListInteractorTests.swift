import XCTest
import Combine
@testable import ArticleListCombine

class ProductListInteractorTests: XCTestCase {
    
    private var disposables: Set<AnyCancellable>!
    
    var sut: ProductListInteractor!
    
    override func setUp() {
        super.setUp()
        disposables = []
    }
    
    func test_getAllProducts_withSuccessReponse_shouldReturnProducts() {
        // Given
        sut = ProductListInteractor(networkManager: NetworkManagerMock())
        
        // When
        sut.getAllProducts()
            .sink { completion in
                // Then
                if case .failure = completion {
                    XCTFail("Error returned when not expected")
                }
            } receiveValue: { products in
                // Then
                XCTAssertEqual(products.count, 2)
            }
            .store(in: &disposables)
    }
    
    func test_getAllProducts_withErrorReponse_shouldCallGetProductsError() {
        // Given
        let networkManagerMock = NetworkManagerMock()
        networkManagerMock.returnError = true
        sut = ProductListInteractor(networkManager: networkManagerMock)
        
        // When
        sut.getAllProducts()
            .sink { completion in
                // Then
                var failureCompletion = false
                if case .failure = completion {
                    failureCompletion = true
                }
                XCTAssertTrue(failureCompletion)
            } receiveValue: { products in
                // Then
                XCTFail("Products returned when not expected")
            }
            .store(in: &disposables)
    }
    
}
