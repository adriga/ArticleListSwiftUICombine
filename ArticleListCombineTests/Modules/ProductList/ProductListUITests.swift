import XCTest
import SwiftUI
import OHHTTPStubs
import OHHTTPStubsSwift
import KIF
@testable import ArticleListCombine

class ProductListUITests: KIFTestCase {

    var moduleFactory = ModuleDependencyContainer()

    override func afterEach() {
        HTTPStubs.removeAllStubs()
        super.afterEach()
    }

    func test_viewDidLoad_withProductsErrorResponse_shouldShowNoProductsView() {
        // Given
        // Mock GET request Error
        stub(condition: isAbsoluteURLString("https://gist.githubusercontent.com/adriga/786347e52a898f1b1c1562b6ed8af132/raw/822d1d538e24cf7fa1b848f0624eb9bf7d4e9c10/products.json") && isMethodGET()) { _ in
            return HTTPStubsResponse(jsonObject: [String: Any](), statusCode: 500, headers: nil)
        }
        // Navigate to view under test
        UIApplication.shared.keyWindow?.rootViewController = UIHostingController(rootView: moduleFactory.makeProductListModule(router: ProductListRouterSpy()))

        // Then
        tester().waitForView(withAccessibilityIdentifier: "no_products".localizedString)
    }

    func test_viewDidLoad_withProductsSuccessResponse_shouldShowProducts() {
        // Given
        // Mock GET request OK
        stub(condition: isAbsoluteURLString("https://gist.githubusercontent.com/adriga/786347e52a898f1b1c1562b6ed8af132/raw/822d1d538e24cf7fa1b848f0624eb9bf7d4e9c10/products.json") && isMethodGET()) { _ in
            let obj = ["products": [["code": "KEYCHAIN", "name": "Marvel Keychain", "price": 5],
                                    ["code": "TSHIRT", "name": "T-Shirt", "price": 20],
                                    ["code": "MUG", "name": "Coffee Mug", "price": 7.5]]] as [String: Any]
            return HTTPStubsResponse(jsonObject: obj, statusCode: 200, headers: nil)
        }
        // Navigate to view under test
        UIApplication.shared.keyWindow?.rootViewController = UIHostingController(rootView: moduleFactory.makeProductListModule(router: ProductListRouterSpy()))

        // Then
        tester().waitForView(withAccessibilityIdentifier: "ProductCell")
    }

    func test_whenClickOnAProdut_itShouldBeAddedToCart() {
        // Given
        // Mock GET request OK
        stub(condition: isAbsoluteURLString("https://gist.githubusercontent.com/adriga/786347e52a898f1b1c1562b6ed8af132/raw/822d1d538e24cf7fa1b848f0624eb9bf7d4e9c10/products.json") && isMethodGET()) { _ in
            let obj = ["products": [["code": "KEYCHAIN", "name": "Marvel Keychain", "price": 5],
                                    ["code": "TSHIRT", "name": "T-Shirt", "price": 20],
                                    ["code": "MUG", "name": "Coffee Mug", "price": 7.5]]] as [String: Any]
            return HTTPStubsResponse(jsonObject: obj, statusCode: 200, headers: nil)
        }
        // Navigate to view under test
        UIApplication.shared.keyWindow?.rootViewController = UIHostingController(rootView: moduleFactory.makeProductListModule(router: ProductListRouterSpy()))

        // When
        tester().tapRow(at: IndexPath(item: 0, section: 0), inTableViewWithAccessibilityIdentifier: "ProductList")

        // Then
        if let productsInCart = tester().waitForView(withAccessibilityIdentifier: "cartProductsLabel") as? UILabel {
            XCTAssertEqual(productsInCart.text, String(format: "shopping_cart_products".localizedString, 1))
        }
    }
    
    // e2e test that makes a real server request (without mocks)
    func test_viewDidLoad_shouldShowProducts() {
        UIApplication.shared.keyWindow?.rootViewController = UIHostingController(rootView: moduleFactory.makeProductListModule(router: ProductListRouterSpy()))
        tester().waitForView(withAccessibilityIdentifier: "ProductCell")
    }
}
