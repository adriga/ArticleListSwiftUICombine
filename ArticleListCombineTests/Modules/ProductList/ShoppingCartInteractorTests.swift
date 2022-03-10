import XCTest
import Combine
@testable import ArticleListCombine

class ShoppingCartInteractorTests: XCTestCase {
    
    private var disposables: Set<AnyCancellable>!
    
    var sut: ShoppingCartInteractor!

    override func setUp() {
        super.setUp()
        disposables = []
        sut = ShoppingCartInteractor()
    }
    
    func test_addProductToCart_shouldRefreshCart_withNewProduct() {
        // Given
        let mockProduct = ProductEntity(code: "KEYCHAIN", name: "Marvel Keychain", price: "5")
        sut.shoppingCart = [mockProduct]
        
        // When
        let _ = sut.addProductToCart(product: ProductEntity(code: "TSHIRT", name: "T-Shirt", price: "20"))
        
        // Then
        XCTAssertEqual(sut.shoppingCart.count, 2)
    }
    
    func test_getTotalCartAmount_withEmptyCart_shouldUpdateCartAmountWithZero() {
        // Given
        sut.shoppingCart = []

        // When
        sut.getTotalCartAmount()
            .sink { cartAmount in
                // Then
                XCTAssertEqual(cartAmount, 0.0)
            }
            .store(in: &disposables)
    }

    func test_getTotalCartAmount_withValidCart() {
        // Given
        let mockProduct = ProductEntity(code: "KEYCHAIN", name: "Marvel Keychain", price: "5")
        self.sut.shoppingCart = [mockProduct]

        // When
        sut.getTotalCartAmount()
            .sink { cartAmount in
                // Then
                XCTAssertEqual(cartAmount, 5.0)
            }
            .store(in: &disposables)
    }

    func test_getKeychainCartAmount_withEmptyCart_shouldReturnZero() {
        // Given
        sut.shoppingCart = []

        // When
        let keychainsAmount = sut.calculateKeychainsAmount()

        // Then
        XCTAssertEqual(keychainsAmount, 0)
    }

    func test_getKeychainCartAmount_withCartWithoutKeychains_shouldReturnZero() {
        // Given
        let mockProduct = ProductEntity(code: "TSHIRT", name: "T-Shirt", price: "20")
        sut.shoppingCart = [mockProduct]

        // When
        let keychainsAmount = sut.calculateKeychainsAmount()

        // Then
        XCTAssertEqual(keychainsAmount, 0)
    }

    func test_getKeychainCartAmount_withOneKeychainInTheCart_shouldReturnCorrectAmount() {
        // Given
        let mockProduct = ProductEntity(code: "KEYCHAIN", name: "Marvel Keychain", price: "5")
        sut.shoppingCart = [mockProduct]

        // When
        let keychainsAmount = sut.calculateKeychainsAmount()

        // Then
        XCTAssertEqual(keychainsAmount, 5)
    }

    func test_getKeychainCartAmount_withTwoKeychainsInTheCart_shouldReturnCorrectAmount() {
        // Given
        let mockProduct = ProductEntity(code: "KEYCHAIN", name: "Marvel Keychain", price: "5")
        sut.shoppingCart = [mockProduct, mockProduct]

        // When
        let keychainsAmount = sut.calculateKeychainsAmount()

        // Then
        XCTAssertEqual(keychainsAmount, 5)
    }

    func test_getKeychainCartAmount_withThreeKeychainsInTheCart_shouldReturnCorrectAmount() {
        // Given
        let mockProduct = ProductEntity(code: "KEYCHAIN", name: "Marvel Keychain", price: "5")
        sut.shoppingCart = [mockProduct, mockProduct, mockProduct]

        // When
        let keychainsAmount = sut.calculateKeychainsAmount()

        // Then
        XCTAssertEqual(keychainsAmount, 10)
    }

    func test_getTshirtCartAmount_withOneTshirtInTheCart() {
        // Given
        let mockProduct = ProductEntity(code: "TSHIRT", name: "T-Shirt", price: "20")
        sut.shoppingCart = [mockProduct]

        // Then
        XCTAssertEqual(sut.calculateTshirtsAmount(), 20)
    }

    func test_getTshirtCartAmount_withThreeTshirtInTheCart() {
        // Given
        let mockProduct = ProductEntity(code: "TSHIRT", name: "T-Shirt", price: "20")
        sut.shoppingCart = [mockProduct, mockProduct, mockProduct]

        // Then
        XCTAssertEqual(sut.calculateTshirtsAmount(), 57)
    }

}
