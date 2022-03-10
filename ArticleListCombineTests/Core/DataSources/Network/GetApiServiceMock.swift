import Foundation
@testable import ArticleListCombine

struct GetApiServiceMock: ApiService {
    
    typealias Response = ResponseDTOMock
    
    var resourceName: String {
        return "/test"
    }
    
    var operationType: String {
        return "GET"
    }
    
    var body: [String: Any]? {
        return nil
    }
}
