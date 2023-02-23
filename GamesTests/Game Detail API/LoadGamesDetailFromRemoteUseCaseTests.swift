//
//  LoadGamesDetailFromRemoteUseCaseTests.swift
//  GamesTests
//
//  Created by Azam Mukhtar on 22/02/23.
//

import XCTest
import Games

class LoadGamesDetailFromRemoteUseCaseTests: XCTestCase {

    func test_init_doesNotRequestDataFromURL() {
        let (_, client) = makeSUT()
        
        XCTAssertTrue(client.requestedURLs.isEmpty)
    }
    
    func test_load_requestDataFromURL() {
        let id = 2394
        let url = anyURL()
        let (sut, client) = makeSUT(url: url)

        sut.get(for: id) {_ in }
        let enrichURL = enrich(url, with: id)

        XCTAssertEqual(client.requestedURLs, [enrichURL])
    }

    func test_load_requestDataFromURLTwice() {
        let id = 2394
        let url = anyURL()
        let (sut, client) = makeSUT(url: url)
        
        sut.get(for: id) {_ in }
        sut.get(for: id) {_ in }

        let enrichURL = enrich(url, with: id)
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
    
    func test_load_deliversItemsOn200HTTPResponseWithJSONItems(){
        let (sut, client) = makeSUT()
        
        let item = makeItem(id: 2342, title: "GTA", releaseDate: "2013-09-17", rating: 3.5, image: anyURL(), description: "any description", played: 93, developer: "Rockstart", isFavorite: false)


        expect(sut, toCompleteWith: .success(item.model), when: {
            client.complete(withStatusCode: 200, data: item.data)
        })
    }

    func test_load_doesNotDeliverResultAfterSUTInstanceHasBeenDeallocated() {
        let url = URL(string: "https://any-url.com")!
        let client = HTTPClientSpy()
        var sut: RemoteGameDetailLoader? = RemoteGameDetailLoader(url: url, client: client)


        var capturedResults = [RemoteGameDetailLoader.Result]()
        sut?.get(for: 1234) { capturedResults.append($0) }

        sut = nil
        client.complete(withStatusCode: 200, data: makeItemsJSON([]))

        XCTAssertTrue(capturedResults.isEmpty)
    }
    
    // - MARK: Helpers
    
    private func makeSUT(url: URL = URL(string: "https://a-url.com")!, file: StaticString = #filePath, line: UInt = #line) -> (sut: RemoteGameDetailLoader, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = RemoteGameDetailLoader(url: url, client: client)
        trackForMemoryLeaks(sut, file: file, line: line)
        trackForMemoryLeaks(client, file: file, line: line)
        return (sut, client)
    }
    
    private func failure(_ error: RemoteGameDetailLoader.Error) -> RemoteGameDetailLoader.Result {
        return .failure(error)
    }
    
    private func enrich(_ url: URL, with id: Int) -> URL {
        return GameDetailEndpoint.get(id: id).url(baseURL: url).url!
    }

    
    private func expect(_ sut: RemoteGameDetailLoader, with id: Int = 1234, toCompleteWith expectedResult: RemoteGameDetailLoader.Result, when action: () -> Void, file: StaticString = #filePath, line: UInt = #line){
        
        let exp = expectation(description: "Wait for load completion")
        sut.get(for: id) { receivedResult in
            switch (receivedResult, expectedResult) {
            case let (.success(receivedItems), .success(expectedItems)):
                XCTAssertEqual(receivedItems, expectedItems, file: file, line: line)
            case let (.failure(receivedError as RemoteGameDetailLoader.Error), .failure(expectedError as RemoteGameDetailLoader.Error)):
                XCTAssertEqual(receivedError, expectedError, file: file, line: line)
            default:
                XCTFail("Expected result \(expectedResult) got \(receivedResult) instead", file: file, line: line)
            }
            
            exp.fulfill()
        }
        
        action()
        
        wait(for: [exp], timeout: 1.0)
    }
    
    private func makeItem(id: Int, title: String, releaseDate: String, rating: Double, image: URL, description: String, played: Int, developer: String, isFavorite: Bool) -> (model: GameDetailItem, data: Data) {
        let item = GameDetailItem(id: id, title: title, releaseDate: releaseDate, rating: rating, image: image, description: description, played: played, developers: developer, isFavorite: isFavorite)
        
        let json = [
            "id": id,
            "name": "\(title)",
            "released": "\(releaseDate)",
            "rating": rating,
            "description_raw": description,
            "background_image": "\(image.absoluteString)",
            "added_by_status": [
                "playing": played
            ],
            "developers": [
                [
                    "name": developer
                ]
            ]
        ].compactMapValues { $0 }
        let data = try! JSONSerialization.data(withJSONObject: json)
        return (item, data)
    }
}

