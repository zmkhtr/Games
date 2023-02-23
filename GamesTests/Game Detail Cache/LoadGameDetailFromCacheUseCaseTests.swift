//
//  LoadGameDetailFromCacheUseCaseTests.swift
//  GamesTests
//
//  Created by Azam Mukhtar on 22/02/23.
//

import XCTest
import Games

class LoadImageDataFromCacheUseCaseTests: XCTestCase {
    
    func test_init_doesNotMessageStoreUponCreation() {
        let (_, store) = makeSUT()
        
        XCTAssertTrue(store.receivedMessages.isEmpty)
    }
    
    func test_loadGameDetail_requestsStoredDataForID() {
        let (sut, store) = makeSUT()
        let id = anyID()

        sut.get(for: id) { _ in }

        XCTAssertEqual(store.receivedMessages, [.retrieve(dataFor: id)])
    }

    func test_loadGameDetailL_failsOnStoreError() {
        let (sut, store) = makeSUT()

        expect(sut, toCompleteWith: failed(), when: {
            let retrievalError = anyNSError()
            store.completeRetrieval(with: retrievalError)
        })
    }

    func test_loadGameDetail_deliversNotFoundErrorOnNotFound() {
        let (sut, store) = makeSUT()

        expect(sut, toCompleteWith: notFound(), when: {
            store.completeRetrieval(with: .none)
        })
    }

    func test_loadGameDetail_deliversStoredDataOnFoundData() {
        let (sut, store) = makeSUT()
        let foundData = makeItem()

        expect(sut, toCompleteWith: .success(foundData), when: {
            store.completeRetrieval(with: foundData)
        })
    }

    func test_loadAllGameDetailL_failsOnStoreError() {
        let (sut, store) = makeSUT()

        expectGetAll(sut, toCompleteWith: .failure(LocalGameDetailLoader.LoadError.failed), when: {
            let retrievalError = anyNSError()
            store.completeAllRetrieval(with: retrievalError)
        })
    }

    func test_loadAllGameDetail_deliversNotFoundErrorOnNotFound() {
        let (sut, store) = makeSUT()

        expectGetAll(sut, toCompleteWith: .failure(LocalGameDetailLoader.LoadError.notFound), when: {
            store.completeAllRetrieval(with: .none)
        })
    }
    
    func test_loadAllGamesDetail_deliversStoredDataOnFoundData() {
        let (sut, store) = makeSUT()
        let foundData1 = makeItem()
        let foundData2 = makeItem()
        

        expectGetAll(sut, toCompleteWith: .success([foundData1, foundData2]), when: {
            store.completeAllRetrieval(with: [foundData1, foundData2], at: 0)
        })
    }

    func test_loadImageDataFromURL_doesNotDeliverResultAfterSUTInstanceHasBeenDeallocated() {
        let store = GameDetailStoreSpy()
        var sut: LocalGameDetailLoader? = LocalGameDetailLoader(store: store)

        var received = [GameDetailLoader.Result]()
        sut?.get(for: anyID()) { received.append($0) }

        sut = nil
        store.completeRetrieval(with: makeItem())

        XCTAssertTrue(received.isEmpty, "Expected no received results after instance has been deallocated")
    }
    
    // MARK: - Helpers
    
    private func makeSUT(currentDate: @escaping () -> Date = Date.init, file: StaticString = #filePath, line: UInt = #line) -> (sut: LocalGameDetailLoader, store: GameDetailStoreSpy) {
        let store = GameDetailStoreSpy()
        let sut = LocalGameDetailLoader(store: store)
        trackForMemoryLeaks(store, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, store)
    }
    
    private func failed() -> GameDetailLoader.Result {
        return .failure(LocalGameDetailLoader.LoadError.failed)
    }
    
    private func notFound() -> GameDetailLoader.Result {
        return .failure(LocalGameDetailLoader.LoadError.notFound)
    }
    
    private func never(file: StaticString = #file, line: UInt = #line) {
        XCTFail("Expected no no invocations", file: file, line: line)
    }
    
    private func expect(_ sut: LocalGameDetailLoader, toCompleteWith expectedResult: GameDetailLoader.Result, when action: () -> Void, file: StaticString = #filePath, line: UInt = #line) {
        let exp = expectation(description: "Wait for load completion")
        
        sut.get(for: 234) { receivedResult in
            switch (receivedResult, expectedResult) {
            case let (.success(receivedData), .success(expectedData)):
                XCTAssertEqual(receivedData, expectedData, file: file, line: line)
                
            case (.failure(let receivedError as LocalGameDetailLoader.LoadError), .failure(let expectedError as LocalGameDetailLoader.LoadError)):
                XCTAssertEqual(receivedError, expectedError, file: file, line: line)
                
            default:
                XCTFail("Expected result \(expectedResult), got \(receivedResult) instead", file: file, line: line)
            }
            
            exp.fulfill()
        }
        action()
        wait(for: [exp], timeout: 1.0)
    }
    
    private func expectGetAll(_ sut: LocalGameDetailLoader, toCompleteWith expectedResult: AllGamesDetailLoader.Result, when action: () -> Void, file: StaticString = #filePath, line: UInt = #line) {
        let exp = expectation(description: "Wait for load completion")
     
        sut.getAll { receivedResult in
            switch (receivedResult, expectedResult) {
            case let (.success(receivedData), .success(expectedData)):
                XCTAssertEqual(receivedData, expectedData, file: file, line: line)
                
            case (.failure(let receivedError as LocalGameDetailLoader.LoadError), .failure(let expectedError as LocalGameDetailLoader.LoadError)):
                XCTAssertEqual(receivedError, expectedError, file: file, line: line)
                
            default:
                XCTFail("Expected result \(expectedResult), got \(receivedResult) instead", file: file, line: line)
            }
            
            exp.fulfill()
        }
        action()
        wait(for: [exp], timeout: 1.0)
    }
    
    private func anyID() -> Int {
        return Int.random(in: 0..<300)
    }
    
    private func makeItem() -> GameDetailItem {
        return GameDetailItem(id: anyID(), title: "GTA", releaseDate: "2013-09-17", rating: 3.5, image: anyURL(), description: "any description", played: 93, developers: "Rockstart", isFavorite: false)
    }
}


