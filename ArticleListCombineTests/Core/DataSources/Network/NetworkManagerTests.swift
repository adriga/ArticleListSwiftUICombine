import XCTest
import OHHTTPStubs
import OHHTTPStubsSwift
import Combine
@testable import ArticleListCombine

class NetworkManagerTests: XCTestCase {

    var sut: NetworkManager!
    private var disposables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        disposables = []
        sut = NetworkManager()
    }
    
    override func tearDown() {
        HTTPStubs.removeAllStubs()
        super.tearDown()
    }
    
    func test_GETRequest_with200OkResponse_shouldResponseOk() async {
        // Given
        // Mock GET request OK
        stub(condition: isAbsoluteURLString("https://gist.githubusercontent.com/adriga/test") && isMethodGET()) { _ in
            let obj = ["data1": "data1",
                       "data2": "data2"] as [String: Any]
            return HTTPStubsResponse(jsonObject: obj, statusCode: 200, headers: nil)
        }
        
        // When
        sut.makeRequest(request: GetApiServiceMock())
            .sink { completion in
                // Then
                if case .failure = completion {
                    XCTFail()
                }
            } receiveValue: { reponseObject in
                // Then
                XCTAssertNotNil(reponseObject)
            }.store(in: &disposables)
    }
    
    func test_GETRequest_with500ErrorResponse_shouldResponseBadResponseError() async {
        // Given
        // Mock GET request KO with 500 error
        stub(condition: isAbsoluteURLString("https://gist.githubusercontent.com/adriga/test") && isMethodGET()) { _ in
            return HTTPStubsResponse(jsonObject: [String: Any](), statusCode: 500, headers: nil)
        }
        
        // When
        sut.makeRequest(request: GetApiServiceMock())
            .sink { completion in
                // Then
                if case .failure(let error) = completion {
                    XCTAssertEqual(error, ApiError.badResponse)
                }
            } receiveValue: { reponseObject in
                // Then
                XCTFail()
            }.store(in: &disposables)
    }
    
    func test_GETRequest_withBadBody_shouldResponseDecodeError() async {
        // Given
        // Mock GET request OK
        stub(condition: isAbsoluteURLString("https://gist.githubusercontent.com/adriga/test") && isMethodGET()) { _ in
            let obj = ["data1": "data1"] as [String: Any]
            return HTTPStubsResponse(jsonObject: obj, statusCode: 200, headers: nil)
        }

        // When
        sut.makeRequest(request: GetApiServiceMock())
            .sink { completion in
                // Then
                if case .failure(let error) = completion {
                    XCTAssertEqual(error, ApiError.decodeError)
                }
            } receiveValue: { reponseObject in
                // Then
                XCTFail()
            }.store(in: &disposables)
    }

}
