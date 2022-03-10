protocol PresenterFactory {
    func productListPresenter(router: ProductListWireframeProtocol) -> ProductListPresenter
}
