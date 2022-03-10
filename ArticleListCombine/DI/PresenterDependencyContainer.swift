import Foundation

class PresenterDependencyContainer {
    private lazy var interactorFactory: InteractorFactory = InteractorDependencyContainer(coreComponentsFactory: coreComponentsFactory)
    private var coreComponentsFactory: CoreComponentsFactory
    
    init(coreComponentsFactory: CoreComponentsFactory) {
        self.coreComponentsFactory = coreComponentsFactory
    }
}

extension PresenterDependencyContainer: PresenterFactory {
    
    func productListPresenter(router: ProductListWireframeProtocol) -> ProductListPresenter {
        return ProductListPresenter(router: router, productListInteractor: interactorFactory.productListInteractor(), shoppingCartInteractor: interactorFactory.shoppingCartInteractor())
    }
    
}
