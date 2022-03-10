import Foundation
import Combine

protocol ShoppingCartInteractorProtocol: AnyObject {
    func addProductToCart(product: ProductEntity) -> Just<[ProductEntity]>
    func getTotalCartAmount() -> Just<Double>
}

class ShoppingCartInteractor {
    var shoppingCart = [ProductEntity]()
}

extension ShoppingCartInteractor: ShoppingCartInteractorProtocol {
    
    func addProductToCart(product: ProductEntity) -> Just<[ProductEntity]> {
        shoppingCart.append(product)
        return Just(shoppingCart)
    }
    
    func getTotalCartAmount() -> Just<Double> {
        return Just(calculateKeychainsAmount() + calculateTshirtsAmount() + calculateMugsAmount())
    }
    
}

extension ShoppingCartInteractor {

    func calculateKeychainsAmount() -> Double {
        let keychains = shoppingCart.filter( { $0.code == "KEYCHAIN" } )
        if let firstKeychain = keychains.first,
           let keychainPrice = Double(firstKeychain.price) {
            if keychains.count % 2 == 0 {
                return keychainPrice * Double(keychains.count) / 2
            } else {
                return (keychainPrice * Double(keychains.count - 1) / 2) + keychainPrice
            }
        }
        return 0
    }
    
    func calculateTshirtsAmount() -> Double {
        let tshirts = shoppingCart.filter( { $0.code == "TSHIRT" } )
        if let firstTshirt = tshirts.first,
           let tshirtPrice = Double(firstTshirt.price) {
            if tshirts.count >= 3 {
                return tshirtPrice * Double(tshirts.count) - tshirtPrice * Double(tshirts.count) * 5/100
            } else {
                return tshirtPrice * Double(tshirts.count)
            }
        }
        return 0
    }
    
    func calculateMugsAmount() -> Double {
        let mugs = shoppingCart.filter( { $0.code == "MUG" } )
        if let firstMug = mugs.first,
           let mugPrice = Double(firstMug.price) {
            return mugPrice * Double(mugs.count)
        }
        return 0
    }

}
