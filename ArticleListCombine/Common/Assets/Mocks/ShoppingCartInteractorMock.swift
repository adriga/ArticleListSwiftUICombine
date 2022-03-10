import Foundation
import Combine

class ShoppingCartInteractorMock: ShoppingCartInteractorProtocol {
    
    var cartProducts = [ProductEntity(code: "KEYCHAIN", name: "Marvel Keychain", price: "5")]
    
    func addProductToCart(product: ProductEntity) -> Just<[ProductEntity]> {
        cartProducts.append(product)
        return Just(cartProducts)
    }
    
    func getTotalCartAmount() -> Just<Double> {
        return Just(10.0)
    }
}
