import XCTest
@testable import ArticleListCombine

class ProductListPresenterTests: XCTestCase {

    var sut: ProductListPresenter!
    var routerSpy = ProductListRouterSpy()
    
    func test_whenPresenterIsInitialized_andThereAreProducts_shouldLoadProducts() {
        // Given
        sut = ProductListPresenter(router: routerSpy, productListInteractor: ProductListInteractorMock(), shoppingCartInteractor: ShoppingCartInteractorMock())
        
        // When
        waitForAsyncExpectations()
        
        // Then
        XCTAssertNotNil(sut.productList)
        XCTAssertNotEqual(sut.productList, [])
    }
    
    func test_whenPresenterIsInitialized_andThereIsAnError_shouldNotLoadProducts() {
        // Given
        let productListInteractor = ProductListInteractorMock()
        productListInteractor.returnError = true
        sut = ProductListPresenter(router: routerSpy, productListInteractor: productListInteractor, shoppingCartInteractor: ShoppingCartInteractorMock())
        
        // When
        waitForAsyncExpectations()
        
        // Then
        XCTAssertNotNil(sut.productList)
        XCTAssertEqual(sut.productList, [])
    }
    
    func test_whenReloadProducts_shouldLoadNewProducts() {
        // Given
        let productListInteractor = ProductListInteractorMock()
        productListInteractor.products = [ProductEntity(code: "KEYCHAIN", name: "Marvel Keychain", price: "5")]
        sut = ProductListPresenter(router: routerSpy, productListInteractor: productListInteractor, shoppingCartInteractor: ShoppingCartInteractorMock())
        waitForAsyncExpectations()
        XCTAssertNotNil(sut.productList)
        XCTAssertNotEqual(sut.productList, [])
        XCTAssertEqual(sut.productList?.first?.code, "KEYCHAIN")
        
        // When
        productListInteractor.products = [ProductEntity(code: "TSHIRT", name: "Marvel T-Shirt", price: "20")]
        sut.reloadProducts()
        waitForAsyncExpectations()
        
        // Then
        XCTAssertNotNil(sut.productList)
        XCTAssertNotEqual(sut.productList, [])
        XCTAssertEqual(sut.productList?.first?.code, "TSHIRT")
    }
    
    func test_shoppingCartViewIsRequested_andCartHasProducts_shouldReturnShoppingCartModuleWithCorrectProducts() {
        // Given
        sut = ProductListPresenter(router: routerSpy, productListInteractor: ProductListInteractorMock(), shoppingCartInteractor: ShoppingCartInteractorMock())
        sut.shoppingCart = [ProductEntity(code: "KEYCHAIN", name: "Marvel Keychain", price: "5")]

        // When
        waitForAsyncExpectations()
        let _ = sut.shoppingCartView

        // Then
        XCTAssertTrue(routerSpy.showShoppingCartModule)
        XCTAssertEqual(routerSpy.shoppingCart?.first?.code, "KEYCHAIN")
    }
    
    func test_updateEmptyCart_withOneProduct_shouldRefreshCartProducts() {
        // Given
        let shoppingCartInteractor = ShoppingCartInteractorMock()
        shoppingCartInteractor.cartProducts = []
        sut = ProductListPresenter(router: routerSpy, productListInteractor: ProductListInteractorMock(), shoppingCartInteractor: shoppingCartInteractor)
        sut.didSelectProduct(product: ProductViewEntity(entity: ProductEntity(code: "KEYCHAIN", name: "Marvel Keychain", price: "5")))

        // When
        waitForAsyncExpectations()
        
        // Then
        XCTAssertEqual(sut.cartProductsCount, 1)
        XCTAssertEqual(sut.shoppingCart.first?.code, "KEYCHAIN")
    }
    
    func test_updateCartWithOneProduct_withOneProduct_shouldRefreshCartProducts() {
        // Given
        sut = ProductListPresenter(router: routerSpy, productListInteractor: ProductListInteractorMock(), shoppingCartInteractor: ShoppingCartInteractorMock())
        sut.didSelectProduct(product: ProductViewEntity(entity: ProductEntity(code: "TSHIRT", name: "Marvel T-Shirt", price: "20")))

        // When
        waitForAsyncExpectations()
        
        // Then
        XCTAssertEqual(sut.cartProductsCount, 2)
        XCTAssertEqual(sut.shoppingCart.first?.code, "KEYCHAIN")
        XCTAssertEqual(sut.shoppingCart.last?.code, "TSHIRT")
    }
}
