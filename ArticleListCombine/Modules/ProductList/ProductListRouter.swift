import SwiftUI

protocol ProductListWireframeProtocol {
    func makeShoppingCartModule(shoppingCart: [ProductEntity]?) -> ShoppingCartView?
}

class ProductListRouter {
    
    private var moduleFactory: ModuleFactory?

    func createModule(factory: ModuleFactory?) -> ProductListView? {
        moduleFactory = factory
        return factory?.makeProductListModule(router: self)
    }

}

extension ProductListRouter: ProductListWireframeProtocol {
    
    func makeShoppingCartModule(shoppingCart: [ProductEntity]?) -> ShoppingCartView? {
        // Navigate to shopping cart screen. This module is not implemented for the challenge
//        let ShoppingCartView = ShoppingCartRouter().createModule(factory: moduleFactory, shoppingCart: shoppingCart)
        return ShoppingCartView()
    }
    
}
