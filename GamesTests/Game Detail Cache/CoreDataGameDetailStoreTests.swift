//
//  CoreDataGameDetailStoreTests.swift
//  GamesTests
//
//  Created by Azam Mukhtar on 23/02/23.
//

import XCTest
import Games

class CoreDataImageDataStoreTests: XCTestCase {
    
    func test_retrieveGameDetail_deliversNotFoundWhenEmpty() {
        let sut = makeSUT()
        
        expect(sut, toCompleteRetrievalWith: notFound(), for: anyID())
    }
    
    func test_retrieveGameDetail_deliversNotFoundWhenStoredDataURLDoesNotMatch() {
        let sut = makeSUT()
        let id = 237
        let nonMatchingID = 134
        let item = makeItem(id: id)
        
        insert(item, into: sut)

        expect(sut, toCompleteRetrievalWith: notFound(), for: nonMatchingID)
    }

    func test_retrieveGameDetail_deliversFoundDataWhenThereIsAStoredImageDataMatchingURL() {
        let sut = makeSUT()
        let id = 234
        let storedData = makeItem(id: id)

        insert(storedData, into: sut)

        expect(sut, toCompleteRetrievalWith: found(storedData), for: id)
    }

    func test_retrieveGameDetail_deliversLastInsertedValue() {
        let sut = makeSUT()
        let firstStoredData = makeItem(id: 234)
        let id = 534
        let lastStoredData = makeItem(id: id)

        insert(firstStoredData, into: sut)
        insert(lastStoredData, into: sut)

        expect(sut, toCompleteRetrievalWith: found(lastStoredData), for: id)
    }
    
    func test_getAllData_deliverAllInsertedValue() {
        let sut = makeSUT()
        let firstStoredData = makeItem(id: 234)
        let id = 534
        let lastStoredData = makeItem(id: id)

        insert(firstStoredData, into: sut)
        insert(lastStoredData, into: sut)
        insert(lastStoredData, into: sut)
        
        sut.getAllData { result in
            switch result {
            case let .success(gamesDetail):
                XCTAssertNotNil(gamesDetail)
                XCTAssertEqual(2, gamesDetail?.count)
            default:
                break
            }
        }
    }
    
    func test_deleteGameDetail_deliversNotFoundAfterDeletion() {
        let sut = makeSUT()
        let id = 534
        let item = makeItem(id: id)

        insert(item, into: sut)
        sut.delete(dataForID: id) { _ in }
        
        expect(sut, toCompleteRetrievalWith: notFound(), for: id)
    }

    func test_sideEffects_runSerially() {
        let sut = makeSUT()
        let item = makeItem()

        let op1 = expectation(description: "Operation 1")
        sut.insert(item)  { _ in op1.fulfill() }

        let op2 = expectation(description: "Operation 2")
        sut.insert(item) { _ in op2.fulfill() }

        let op3 = expectation(description: "Operation 3")
        sut.insert(item) { _ in op3.fulfill() }

        wait(for: [op1, op2, op3], timeout: 5.0, enforceOrder: true)
    }
    
    // - MARK: Helpers
    
    private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> CoreDataGameDetailStore {
        let storeURL = URL(fileURLWithPath: "/dev/null")
        let sut = try! CoreDataGameDetailStore(storeURL: storeURL)
        trackForMemoryLeaks(sut, file: file, line: line)
        return sut
    }
    
    private func notFound() -> GameDetailStore.RetrievalResult {
        return .success(.none)
    }
    
    private func found(_ game: GameDetailItem) -> GameDetailStore.RetrievalResult {
        return .success(game)
    }
    
    private func expect(_ sut: GameDetailStore, toCompleteRetrievalWith expectedResult: GameDetailStore.RetrievalResult, for id: Int, file: StaticString = #filePath, line: UInt = #line) {
        let exp = expectation(description: "Wait for load completion")
        
        sut.retrieve(dataForID: id) { receivedResult in
            switch (receivedResult, expectedResult) {
            case let (.success(receivedData), .success(expectedData)):
                XCTAssertEqual(receivedData, expectedData, file: file, line: line)
            default:
                XCTFail("Expected \(expectedResult), got \(receivedResult) instead", file: file, line: line)
            }
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1.0)
    }
    
    private func insert(_ game: GameDetailItem, into sut: GameDetailStore, file: StaticString = #filePath, line: UInt = #line) {
        let exp = expectation(description: "Wait for cache insertion")
        sut.insert(game) { result in
            switch result {
            case let .failure(error):
                XCTFail("Failed to save \(game) with error \(error)", file: file, line: line)
                exp.fulfill()
                
            case .success:
                exp.fulfill()
            }
        }
        wait(for: [exp], timeout: 1.0)
    }
    
    private func anyID() -> Int {
        return Int.random(in: 0..<300)
    }
    
    private func makeItem(id: Int = Int.random(in: 0..<300)) -> GameDetailItem {
        return GameDetailItem(id: id, title: "GTA", releaseDate: "2013-09-17", rating: 3.5, image: anyURL(), description: "any description", played: 93, developers: "Rockstart", isFavorite: false)
    }
}
