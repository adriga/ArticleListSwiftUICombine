import Foundation

enum ApiError: Error {
    case badRequest
    case badResponse
    case decodeError
    case unknown
}
