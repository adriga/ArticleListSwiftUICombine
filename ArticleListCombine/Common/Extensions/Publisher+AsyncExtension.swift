import Foundation
import Combine

extension Publisher {
    
    public func asyncSink(receiveCompletion: @escaping ((Subscribers.Completion<Self.Failure>) -> Void), receiveValue: @escaping ((Self.Output) -> Void)) -> AnyCancellable {
        return subscribe(on: DispatchQueue.global())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: receiveCompletion, receiveValue: receiveValue)
    }
    
}
extension Publisher where Self.Failure == Never {
    
    public func asyncSink(receiveValue: @escaping ((Self.Output) -> Void)) -> AnyCancellable {
        return subscribe(on: DispatchQueue.global())
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: receiveValue)
    }
    
}
