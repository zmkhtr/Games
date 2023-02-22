//
//  LoadGamesFromRemoteUseCaseTests.swift
//  GamesTests
//
//  Created by Azam Mukhtar on 22/02/23.
//

import XCTest
import Games

class LoadGamesFromRemoteUseCaseTests: XCTestCase {

    func test_init_doesNotRequestDataFromURL() {
        let (_, client) = makeSUT()
        
        XCTAssertTrue(client.requestedURLs.isEmpty)
    }
    
    func test_load_requestDataFromURL() {
        let request = createRequest()
        let url = anyURL()
        let (sut, client) = makeSUT(url: url)

        sut.load(request: request) {_ in }
        let enrichURL = enrich(url, with: request)

        XCTAssertEqual(client.requestedURLs, [enrichURL])
    }

    func test_load_requestDataFromURLTwice() {
        let request = createRequest()
        let url = anyURL()
        let (sut, client) = makeSUT(url: url)

        sut.load(request: request) {_ in }
        sut.load(request: request) {_ in }

        let enrichURL = enrich(url, with: request)
        XCTAssertEqual(client.requestedURLs, [enrichURL, enrichURL])
    }

    func test_load_deliversErrorOnClientError() {
        let (sut, client) = makeSUT()

        expect(sut, toCompleteWith: failure(.connectivity), when: {
            let clientError = NSError(domain: "Test", code: 0)
            client.complete(with: clientError)
        })
    }

    func test_load_deliversErrorOnNon200HTTPResponse() {
        let (sut, client) = makeSUT()

        let samples = [199, 201, 300, 400, 500]

        samples.enumerated().forEach { index, code in
            expect(sut, toCompleteWith: failure(.invalidData), when: {
                let json = makeItemsJSON([])
                client.complete(withStatusCode: code, data: json, at: index)
            })
        }
    }

    func test_load_deliversErrorOn200HTTPResponseWithInvalidJSON(){
        let (sut, client) = makeSUT()

        expect(sut, toCompleteWith: failure(.invalidData), when: {
            let invalidJSON = Data("invalid json".utf8)
            client.complete(withStatusCode: 200, data: invalidJSON)
        })
    }

    func test_load_deliversNoItemsOn200HTTPResponseWithEmptyJSONList() {
        let (sut, client) = makeSUT()

        expect(sut, toCompleteWith: .success([]), when: {
            let emptyListJSON = makeItemsJSON([])
            client.complete(withStatusCode: 200, data: emptyListJSON)
        })
    }

    func test_load_deliversItemsOn200HTTPResponseWithJSONItems(){
        let (sut, client) = makeSUT()

        let item1 = makeItem(id: 2343, title: "GTA", releaseDate: "2013-09-17", rating: 4.7, image: anyURL())
        let item2 = makeItem(id: 8345, title: "The Witcher", releaseDate: "2010-02-17", rating: 4.9, image: anyURL())

        let items = [item1.model, item2.model]

        expect(sut, toCompleteWith: .success(items), when: {
            let json = makeItemsJSON([item1.json, item2.json])
            client.complete(withStatusCode: 200, data: json)
        })
    }


    func test_load_doesNotDeliverResultAfterSUTInstanceHasBeenDeallocated() {
        let url = URL(string: "https://any-url.com")!
        let client = HTTPClientSpy()
        var sut: RemoteGamesLoader? = RemoteGamesLoader(url: url, client: client)


        var capturedResults = [RemoteGamesLoader.Result]()
        sut?.load(request: createRequest()) { capturedResults.append($0) }

        sut = nil
        client.complete(withStatusCode: 200, data: makeItemsJSON([]))

        XCTAssertTrue(capturedResults.isEmpty)
    }
    
    // - MARK: Helpers
    
    private func makeSUT(url: URL = URL(string: "https://a-url.com")!, file: StaticString = #filePath, line: UInt = #line) -> (sut: RemoteGamesLoader, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = RemoteGamesLoader(url: url, client: client)
        trackForMemoryLeaks(sut, file: file, line: line)
        trackForMemoryLeaks(client, file: file, line: line)
        return (sut, client)
    }
    
    private func failure(_ error: RemoteGamesLoader.Error) -> RemoteGamesLoader.Result {
        return .failure(error)
    }
    
    private func enrich(_ url: URL, with request: GamesRequest) -> URL {
        return GamesEndpoint.get(request: request).url(baseURL: url).url!
    }

    
    private func expect(_ sut: RemoteGamesLoader, with request: GamesRequest = GamesRequest(page: 1, page_size: 10), toCompleteWith expectedResult: RemoteGamesLoader.Result, when action: () -> Void, file: StaticString = #filePath, line: UInt = #line){
        
        let exp = expectation(description: "Wait for load completion")
        sut.load(request: request) { receivedResult in
            switch (receivedResult, expectedResult) {
            case let (.success(receivedItems), .success(expectedItems)):
                XCTAssertEqual(receivedItems, expectedItems, file: file, line: line)
            case let (.failure(receivedError as RemoteGamesLoader.Error), .failure(expectedError as RemoteGamesLoader.Error)):
                XCTAssertEqual(receivedError, expectedError, file: file, line: line)
            default:
                XCTFail("Expected result \(expectedResult) got \(receivedResult) instead", file: file, line: line)
            }
            
            exp.fulfill()
        }
        
        action()
        
        wait(for: [exp], timeout: 1.0)
    }
    
    private func createRequest(query: String? = nil) -> GamesRequest {
        return GamesRequest(page: 1, page_size: 10, search: query)
    }
    
    private func makeItem(id: Int, title: String, releaseDate: String, rating: Double, image: URL) -> (model: GameItem, json: [String: Any]) {
        let item = GameItem(id: id, title: title, releaseDate: releaseDate, rating: rating, image: image)
        
        let json = [
            "id": id,
            "name": "\(title)",
            "released": "\(releaseDate)",
            "rating": rating,
            "background_image": "\(image.absoluteString)"
        ].compactMapValues { $0 }
        
        return (item, json)
    }
}

