import Foundation

class InteractorDependencyContainer {
    private var coreComponentsFactory: CoreComponentsFactory
    
    init(coreComponentsFactory: CoreComponentsFactory) {
        self.coreComponentsFactory = coreComponentsFactory
    }
}

extension InteractorDependencyContainer: InteractorFactory {
    
    func productListInteractor() -> ProductListInteractorProtocol {
        return ProductListInteractor(networkManager: coreComponentsFactory.getNetworkManager())
    }
    
    func shoppingCartInteractor() -> ShoppingCartInteractorProtocol {
        return ShoppingCartInteractor()
    }
    
}
