import SwiftUI
import Combine

class ProductListPresenter: ObservableObject, Identifiable {
    
    var productListInteractor: ProductListInteractorProtocol
    var shoppingCartInteractor: ShoppingCartInteractorProtocol
    var router: ProductListWireframeProtocol
    
    var shoppingCart = [ProductEntity]()
    
    @Published var productList: [ProductViewEntity]?
    @Published var cartProductsCount = 0
    @Published var cartAmount = 0.0
    
    private var disposables = Set<AnyCancellable>()
    
    init(router: ProductListWireframeProtocol, productListInteractor: ProductListInteractorProtocol, shoppingCartInteractor: ShoppingCartInteractorProtocol) {
        self.router = router
        self.productListInteractor = productListInteractor
        self.shoppingCartInteractor = shoppingCartInteractor
        
        getAllProducts()
    }
    
    func reloadProducts() {
        getAllProducts()
    }
    
    func didSelectProduct(product: ProductViewEntity) {
        shoppingCartInteractor
            .addProductToCart(product: ProductEntity(viewEntity: product))
            .zip(shoppingCartInteractor.getTotalCartAmount())
            .asyncSink { [weak self] (cartProducts, cartAmount) in
                if self?.cartProductsCount == 0 {
                    withAnimation {
                        self?.cartProductsCount = cartProducts.count
                    }
                } else {
                    self?.cartProductsCount = cartProducts.count
                }
                self?.shoppingCart = cartProducts
                self?.cartAmount = cartAmount
            }
            .store(in: &disposables)
    }
}

extension ProductListPresenter {
    
    var shoppingCartView: some View {
        return router.makeShoppingCartModule(shoppingCart: shoppingCart)
    }
}

private extension ProductListPresenter {
    
    func getAllProducts() {
        productListInteractor
            .getAllProducts()
            .asyncSink { [weak self] completion in
                if case .failure = completion {
                    self?.productList = []
                }
            } receiveValue: { [weak self] products in
                self?.productList = products.map { ProductViewEntity(entity: $0) }
            }
            .store(in: &disposables)
    }
}
