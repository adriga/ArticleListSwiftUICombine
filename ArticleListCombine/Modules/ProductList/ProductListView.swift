import SwiftUI

struct ProductListView: View {
    
    @ObservedObject var presenter: ProductListPresenter
    
    var body: some View {
        if let productList = presenter.productList,
           productList.isEmpty {
            VStack {
                Text("no_products".localizedString)
                    .font(.regularFont(ofSize: 20))
                    .foregroundColor(.primaryTextColor)
                    .padding(.bottom, 20)
                    .accessibilityIdentifier("no_products".localizedString)
                Button("try_again_button".localizedString) {
                    presenter.reloadProducts()
                }
                .font(.regularFont(ofSize: 15))
            }
        } else if let productList = presenter.productList {
            ZStack {
                VStack {
                    List {
                        ForEach(productList, id: \.self) { product in
                            Button(action: {
                                presenter.didSelectProduct(product: product)
                            }) {
                                ProductCellView(product: product)
                            }
                            .accessibilityIdentifier("ProductCell")
                        }
                        .listRowInsets(EdgeInsets())
                    }
                    .accessibilityIdentifier("ProductList")
                }
                if presenter.cartProductsCount > 0 {
                    VStack {
                        Spacer()
                        HStack() {
                            Image("add_shopping_cart")
                                .resizable()
                                .frame(width: 40, height: 40)
                                .padding(.leading, 15)
                            VStack(alignment: .leading) {
                                Text("\(presenter.cartProductsCount)" + "shopping_cart_products".localizedString)
                                    .font(.boldFont(ofSize: 15))
                                    .foregroundColor(.primaryTextColor)
                                    .padding(.bottom, 2)
                                    .accessibilityIdentifier("cartProductsLabel")
                                Text( "shopping_cart_total".localizedString + "\(presenter.cartAmount)€")
                                    .font(.boldFont(ofSize: 18))
                                    .foregroundColor(.primaryTextColor)
                            }
                            .padding([.leading, .trailing], 15)
                            Spacer()
                            Image("arrow_forward")
                                .resizable()
                                .frame(width: 20, height: 20)
                                .padding(.trailing, 15)
                        }
                        .frame(height: 100)
                        .background(Color.white)
                        .shadow(color: .mediumGrayColor, radius: 10)
                    }
                    .transition(.move(edge: .bottom))
                }
            }
        }
    }
}

struct ProductListView_Previews: PreviewProvider {
    static var previews: some View {
        ProductListView(presenter: ProductListPresenter(router: ProductListRouter(), productListInteractor: ProductListInteractorMock(), shoppingCartInteractor: ShoppingCartInteractorMock()))
    }
}
