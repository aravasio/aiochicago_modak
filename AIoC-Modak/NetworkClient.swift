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
                throw NetworkError.decodingError(error)
            }
        } catch {
            throw NetworkError.networkError(error)
        }
    }
}
