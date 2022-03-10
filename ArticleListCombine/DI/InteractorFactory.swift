protocol InteractorFactory {
    func productListInteractor() -> ProductListInteractorProtocol
    func shoppingCartInteractor() -> ShoppingCartInteractorProtocol
}
