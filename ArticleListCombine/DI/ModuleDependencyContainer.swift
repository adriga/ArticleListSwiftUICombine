import Foundation

class ModuleDependencyContainer {
    private lazy var presenterFactory: PresenterFactory = PresenterDependencyContainer(coreComponentsFactory: coreComponentsFactory)
    private lazy var coreComponentsFactory: CoreComponentsFactory = CoreComponentsDependencyContainer()
}

extension ModuleDependencyContainer: ModuleFactory {
    
    func appInitialization() -> CoreComponentsFactory {
        return self.coreComponentsFactory
    }
    
    func makeProductListModule(router: ProductListWireframeProtocol) -> ProductListView {
        return ProductListView(presenter: presenterFactory.productListPresenter(router: router))
    }
    
}
