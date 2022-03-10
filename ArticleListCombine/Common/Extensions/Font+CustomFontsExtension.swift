import SwiftUI

extension Font {
    
    static func boldFont(ofSize size: CGFloat) -> Font {
        return Font.system(size: size, weight: .bold)
    }
    
    static func mediumFont(ofSize size: CGFloat) -> Font {
        return Font.system(size: size, weight: .medium)
    }
    
    static func regularFont(ofSize size: CGFloat) -> Font {
        return Font.system(size: size, weight: .regular)
    }
    
    static func lightFont(ofSize size: CGFloat) -> Font {
        return Font.system(size: size, weight: .light)
    }
    
    static func thinSystemFont(ofSize size: CGFloat) -> Font {
        return Font.system(size: size, weight: .thin)
    }
    
}
