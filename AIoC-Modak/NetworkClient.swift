import Foundation

enum NetworkError: Error {
    case invalidURL
    case networkError(Error)
    case decodingError(Error)
}

protocol NetworkClientProtocol {
    func fetchResource<T: Mappable>(page: Int, expecting expectedType: T.Type) async throws -> T
}

class NetworkClient: NetworkClientProtocol {
    func fetchResource<T: Mappable>(page: Int, expecting expectedType: T.Type) async throws -> T {
        guard let url = URL(string: expectedType.endpoint(for: page)) else {
            throw NetworkError.invalidURL
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            do {
                let element = try JSONDecoder().decode(expectedType, from: data)
                return element
            } catch {
                print("Decoding error: \(error)")
                if let decodingError = error as? DecodingError {
                    switch decodingError {
                    case .dataCorrupted(let context):
                        print("Data corrupted: \(context)")
                    case .keyNotFound(let key, let context):
                        print("Key '\(key.stringValue)' not found, \(context.debugDescription)")
                    case .typeMismatch(let type, let context):
                        print("Type mismatch for type \(type), \(context.debugDescription)")
                    case .valueNotFound(let type, let context):
                        print("Value not found for type \(type), \(context.debugDescription)")
                    default:
                        print("Unknown decoding error occurred")
                    }
                } else {
                    print("Other error: \(error)")
                }
                
                throw NetworkError.decodingError(error)
            }
        } catch {
            throw NetworkError.networkError(error)
        }
    }
}
