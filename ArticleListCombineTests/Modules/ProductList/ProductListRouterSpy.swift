import XCTest
@testable import ArticleListCombine

class ProductListRouterSpy: ProductListWireframeProtocol {

    var showShoppingCartModule: Bool = false
    var shoppingCart: [ProductEntity]?

    func makeShoppingCartModule(shoppingCart: [ProductEntity]?) -> ShoppingCartView? {
        self.shoppingCart = shoppingCart
        showShoppingCartModule = true
        return ShoppingCartView()
    }
}
