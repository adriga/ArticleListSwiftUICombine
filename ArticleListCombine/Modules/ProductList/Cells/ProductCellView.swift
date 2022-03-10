import SwiftUI

struct ProductCellView: View {
    
    let product: ProductViewEntity
    
    var body: some View {
        HStack {
            Image(product.image ?? "default_product")
                .resizable()
                .frame(width: 50, height: 50)
                .padding([.top, .bottom], 10)
            VStack(alignment: .leading) {
                Text(product.name)
                    .font(.boldFont(ofSize: 17))
                    .foregroundColor(.primaryTextColor)
                    .padding(.top, 10)
                    .padding(.bottom, 2)
                HStack {
                    Text(product.price + "€")
                        .font(.mediumFont(ofSize: 15))
                        .foregroundColor(.primaryTextColor)
                    if let offer = product.offer {
                        Text(offer)
                            .font(.regularFont(ofSize: 12))
                            .foregroundColor(.secondaryTextColor)
                    }
                }
                .padding(.bottom, 10)
            }
            Spacer()
            Image("add_shopping_cart")
                .resizable()
                .frame(width: 20, height: 20)
        }
        .padding([.top, .bottom], 10)
        .padding([.leading, .trailing], 10)
    }
}

struct ProductCellView_Previews: PreviewProvider {
    static var previews: some View {
        ProductCellView(product: ProductViewEntity(entity: ProductEntity(code: "KEYCHAIN", name: "Marvel Keychain", price: "5")))
    }
}
