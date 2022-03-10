protocol ModuleFactory {
    func appInitialization() -> CoreComponentsFactory
    func makeProductListModule(router: ProductListWireframeProtocol) -> ProductListView
}
