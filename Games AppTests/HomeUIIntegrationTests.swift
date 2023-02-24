//
//  HomeUIIntegrationTests.swift
//  Games AppTests
//
//  Created by Azam Mukhtar on 23/02/23.
//

import XCTest
import Games
import Games_App

final class HomeUIIntegrationTests: XCTestCase {
    
    func test_homeView_hasTitle() {
        let (sut, _) = makeSUT()
        
        sut.loadViewIfNeeded()
        
        XCTAssertEqual(sut.title, "Games For You")
    }
    
    func test_loadGamesActions_requestGamesFromLoader() {
        let (sut, loader) = makeSUT()
        XCTAssertEqual(loader.loadGamesCallCount, 0, "Expected no loading requests before view is loaded")

        sut.loadViewIfNeeded()
        XCTAssertEqual(loader.loadGamesCallCount, 1, "Expected a loading request once view is loaded")

        sut.simulateUserInitiatedGamesReload()
        XCTAssertEqual(loader.loadGamesCallCount, 2, "Expected another loading request once user initiates a reload")

        sut.simulateUserInitiatedGamesReload()
        XCTAssertEqual(loader.loadGamesCallCount, 3, "Expected yet another loading request once user initiates another reload")
    }

    func test_loadingGamesIndicator_isVisibleWhileLoadingFeed() {
        let (sut, loader) = makeSUT()

        sut.loadViewIfNeeded()
        XCTAssertTrue(sut.isShowingLoadingIndicator, "Expected loading indicator once view is loaded")

        loader.completeGamesLoading(at: 0)
        XCTAssertFalse(sut.isShowingLoadingIndicator, "Expected no loading indicator once loading completes successfully")

        sut.simulateUserInitiatedGamesReload()
        XCTAssertTrue(sut.isShowingLoadingIndicator, "Expected loading indicator once user initiates a reload")

        loader.completeGamesLoadingWithError(at: 1)
        XCTAssertFalse(sut.isShowingLoadingIndicator, "Expected no loading indicator once user initiated loading completes with error")
    }

    func test_loadGamesCompletion_rendersSuccessfullyLoadedFeed() {
        let item0 = makeItem(id: 23432, title: "GTA", releaseDate: "2018-09-17", rating: 4.7, image: anyURL())
        let item1 = makeItem(id: 83454, title: "The Witcher", releaseDate: "2010-01-17", rating: 4.9, image: anyURL())
        let item2 = makeItem(id: 23432, title: "GTA 5", releaseDate: "2015-09-17", rating: 4.2, image: anyURL())
        let item3 = makeItem(id: 83453, title: "The Naruto", releaseDate: "2010-05-17", rating: 4.4, image: anyURL())
        let (sut, loader) = makeSUT()

        sut.loadViewIfNeeded()
        assertThat(sut, isRendering: [])

        loader.completeGamesLoading(with: [item0], at: 0)
        assertThat(sut, isRendering: [item0])

        sut.simulateUserInitiatedGamesReload()
        
        loader.completeGamesLoading(with: [item0, item1, item2, item3], at: 1)
        assertThat(sut, isRendering: [item0, item1, item2, item3])
    }

    func test_loadGamesCompletion_doesNotAlterCurrentRenderingStateOnError() {
        let item0 = makeItem()
        let (sut, loader) = makeSUT()

        sut.loadViewIfNeeded()
        loader.completeGamesLoading(with: [item0], at: 0)
        assertThat(sut, isRendering: [item0])

        sut.simulateUserInitiatedGamesReload()
        loader.completeGamesLoadingWithError(at: 1)
        assertThat(sut, isRendering: [item0])
    }

    func test_loadGamesCompletion_rendersErrorMessageOnErrorUntilNextReload() {
        let (sut, loader) = makeSUT()

        sut.loadViewIfNeeded()
        XCTAssertEqual(sut.errorMessage, nil)

        loader.completeGamesLoadingWithError(at: 0)
        XCTAssertEqual(sut.errorMessage, "Fetch data failed\n     Tap to Retry")

        sut.simulateUserInitiatedGamesReload()
        XCTAssertEqual(sut.errorMessage, nil)
    }

    func test_gamesImageView_loadsImageURLWhenVisible() {
        let item0 = makeItem(image: URL(string: "http://url-0.com")!)
        let item1 = makeItem(image: URL(string: "http://url-1.com")!)
        let (sut, loader) = makeSUT()

        sut.loadViewIfNeeded()
        loader.completeGamesLoading(with: [item0, item1])

        XCTAssertEqual(loader.loadedImageURLs, [], "Expected no image URL requests until views become visible")

        sut.simulateGameItemViewVisible(at: 0)
        XCTAssertEqual(loader.loadedImageURLs, [item0.image], "Expected first image URL request once first view becomes visible")

        sut.simulateGameItemViewVisible(at: 1)
        XCTAssertEqual(loader.loadedImageURLs, [item0.image, item1.image], "Expected second image URL request once second view also becomes visible")
    }

    func test_feedImageView_cancelsImageLoadingWhenNotVisibleAnymore() {
        let item0 = makeItem(image: URL(string: "http://url-0.com")!)
        let item1 = makeItem(image: URL(string: "http://url-1.com")!)
        let (sut, loader) = makeSUT()

        sut.loadViewIfNeeded()
        loader.completeGamesLoading(with: [item0, item1])
        XCTAssertEqual(loader.cancelledImageURLs, [], "Expected no cancelled image URL requests until image is not visible")

        sut.simulateGameItemViewNotVisible(at: 0)
        XCTAssertEqual(loader.cancelledImageURLs, [item0.image], "Expected one cancelled image URL request once first image is not visible anymore")

        sut.simulateGameItemViewNotVisible(at: 1)
        XCTAssertEqual(loader.cancelledImageURLs, [item0.image, item1.image], "Expected two cancelled image URL requests once second image is also not visible anymore")
    }

    func test_feedImageViewLoadingIndicator_isVisibleWhileLoadingImage() {
        let (sut, loader) = makeSUT()

        sut.loadViewIfNeeded()
        loader.completeGamesLoading(with: [makeItem(), makeItem()])

        let view0 = sut.simulateGameItemViewVisible(at: 0)
        let view1 = sut.simulateGameItemViewVisible(at: 1)
        XCTAssertEqual(view0?.isShowingImageLoadingIndicator, true, "Expected loading indicator for first view while loading first image")
        XCTAssertEqual(view1?.isShowingImageLoadingIndicator, true, "Expected loading indicator for second view while loading second image")

        loader.completeImageLoading(at: 0)
        XCTAssertEqual(view0?.isShowingImageLoadingIndicator, false, "Expected no loading indicator for first view once first image loading completes successfully")
        XCTAssertEqual(view1?.isShowingImageLoadingIndicator, true, "Expected no loading indicator state change for second view once first image loading completes successfully")

        loader.completeImageLoadingWithError(at: 1)
        XCTAssertEqual(view0?.isShowingImageLoadingIndicator, false, "Expected no loading indicator state change for first view once second image loading completes with error")
        XCTAssertEqual(view1?.isShowingImageLoadingIndicator, false, "Expected no loading indicator for second view once second image loading completes with error")

        view1?.simulateRetryAction()
        XCTAssertEqual(view0?.isShowingImageLoadingIndicator, false, "Expected no loading indicator state change for first view once second image loading completes with error")
        XCTAssertEqual(view1?.isShowingImageLoadingIndicator, true, "Expected loading indicator state change for second view on retry action")
    }

    func test_gamesImageView_rendersImageLoadedFromURL() {
        let (sut, loader) = makeSUT()

        sut.loadViewIfNeeded()
        loader.completeGamesLoading(with: [makeItem(), makeItem()])

        let view0 = sut.simulateGameItemViewVisible(at: 0)
        let view1 = sut.simulateGameItemViewVisible(at: 1)
        XCTAssertEqual(view0?.renderedImage, .none, "Expected no image for first view while loading first image")
        XCTAssertEqual(view1?.renderedImage, .none, "Expected no image for second view while loading second image")

        let imageData0 = UIImage.make(withColor: .red).preparingThumbnail(of: (view0?.imageGame.frame.size)!)!.pngData()!
        loader.completeImageLoading(with: imageData0, at: 0)
        XCTAssertEqual(view0?.renderedImage, imageData0, "Expected image for first view once first image loading completes successfully")
        XCTAssertEqual(view1?.renderedImage, .none, "Expected no image state change for second view once first image loading completes successfully")

        let imageData1 = UIImage.make(withColor: .blue).preparingThumbnail(of: (view1?.imageGame.frame.size)!)!.pngData()!
        loader.completeImageLoading(with: imageData1, at: 1)
        XCTAssertEqual(view0?.renderedImage, imageData0, "Expected no image state change for first view once second image loading completes successfully")
        XCTAssertEqual(view1?.renderedImage, imageData1, "Expected image for second view once second image loading completes successfully")
    }

    func test_gameItemViewRetryButton_isVisibleOnImageURLLoadError() {
        let (sut, loader) = makeSUT()

        sut.loadViewIfNeeded()
        loader.completeGamesLoading(with: [makeItem(), makeItem()])

        let view0 = sut.simulateGameItemViewVisible(at: 0)
        let view1 = sut.simulateGameItemViewVisible(at: 1)
        XCTAssertEqual(view0?.isShowingRetryAction, false, "Expected no retry action for first view while loading first image")
        XCTAssertEqual(view1?.isShowingRetryAction, false, "Expected no retry action for second view while loading second image")

        let imageData = UIImage.make(withColor: .red).preparingThumbnail(of: (view0?.imageGame.frame.size)!)!.pngData()!
        loader.completeImageLoading(with: imageData, at: 0)
        XCTAssertEqual(view0?.isShowingRetryAction, false, "Expected no retry action for first view once first image loading completes successfully")
        XCTAssertEqual(view1?.isShowingRetryAction, false, "Expected no retry action state change for second view once first image loading completes successfully")

        loader.completeImageLoadingWithError(at: 1)
        XCTAssertEqual(view0?.isShowingRetryAction, false, "Expected no retry action state change for first view once second image loading completes with error")
        XCTAssertEqual(view1?.isShowingRetryAction, true, "Expected retry action for second view once second image loading completes with error")

        view1?.simulateRetryAction()
        XCTAssertEqual(view0?.isShowingRetryAction, false, "Expected no retry action state change for first view on  second image retry")
        XCTAssertEqual(view1?.isShowingRetryAction, false, "Expected no retry action for second view on retry")
    }

    func test_gameItemViewRetryButton_isVisibleOnInvalidImageData() {
        let (sut, loader) = makeSUT()

        sut.loadViewIfNeeded()
        loader.completeGamesLoading(with: [makeItem()])

        let view = sut.simulateGameItemViewVisible(at: 0)
        XCTAssertEqual(view?.isShowingRetryAction, false, "Expected no retry action while loading image")

        let invalidImageData = Data("invalid image data".utf8)
        loader.completeImageLoading(with: invalidImageData, at: 0)
        XCTAssertEqual(view?.isShowingRetryAction, true, "Expected retry action once image loading completes with invalid image data")
    }

    func test_gameItemViewRetryAction_retriesImageLoad() {
        let item0 = makeItem(image: URL(string: "http://url-0.com")!)
        let item1 = makeItem(image: URL(string: "http://url-1.com")!)
        let (sut, loader) = makeSUT()

        sut.loadViewIfNeeded()
        loader.completeGamesLoading(with: [item0, item1])

        let view0 = sut.simulateGameItemViewVisible(at: 0)
        let view1 = sut.simulateGameItemViewVisible(at: 1)
        XCTAssertEqual(loader.loadedImageURLs, [item0.image, item1.image], "Expected two image URL request for the two visible views")

        loader.completeImageLoadingWithError(at: 0)
        loader.completeImageLoadingWithError(at: 1)
        XCTAssertEqual(loader.loadedImageURLs, [item0.image, item1.image], "Expected only two image URL requests before retry action")

        view0?.simulateRetryAction()
        XCTAssertEqual(loader.loadedImageURLs, [item0.image, item1.image, item0.image], "Expected third imageURL request after first view retry action")

        view1?.simulateRetryAction()
        XCTAssertEqual(loader.loadedImageURLs, [item0.image, item1.image, item0.image, item1.image], "Expected fourth imageURL request after second view retry action")
    }

    func test_feedImageView_preloadsImageURLWhenNearVisible() {
        let item0 = makeItem(image: URL(string: "http://url-0.com")!)
        let item1 = makeItem(image: URL(string: "http://url-1.com")!)
        let (sut, loader) = makeSUT()

        sut.loadViewIfNeeded()
        loader.completeGamesLoading(with: [item0, item1])
        XCTAssertEqual(loader.loadedImageURLs, [], "Expected no image URL requests until image is near visible")

        sut.simulateGameItemViewNearVisible(at: 0)
        XCTAssertEqual(loader.loadedImageURLs, [item0.image], "Expected first image URL request once first image is near visible")

        sut.simulateGameItemViewNearVisible(at: 1)
        XCTAssertEqual(loader.loadedImageURLs, [item0.image, item1.image], "Expected second image URL request once second image is near visible")
    }

    func test_feedImageView_cancelsImageURLPreloadingWhenNotNearVisibleAnymore() {
        let item0 = makeItem(image: URL(string: "http://url-0.com")!)
        let item1 = makeItem(image: URL(string: "http://url-1.com")!)
        let (sut, loader) = makeSUT()

        sut.loadViewIfNeeded()
        loader.completeGamesLoading(with: [item0, item1])
        XCTAssertEqual(loader.cancelledImageURLs, [], "Expected no cancelled image URL requests until image is not near visible")

        sut.simulateGameItemViewNotNearVisible(at: 0)
        XCTAssertEqual(loader.cancelledImageURLs, [item0.image], "Expected first cancelled image URL request once first image is not near visible anymore")

        sut.simulateGameItemViewNotNearVisible(at: 1)
        XCTAssertEqual(loader.cancelledImageURLs, [item0.image, item1.image], "Expected second cancelled image URL request once second image is not near visible anymore")
    }

    func test_feedImageView_doesNotRenderLoadedImageWhenNotVisibleAnymore() {
        let (sut, loader) = makeSUT()
        sut.loadViewIfNeeded()
        loader.completeGamesLoading(with: [makeItem()])

        let view = sut.simulateGameItemViewNotVisible(at: 0)
        loader.completeImageLoading(with: anyImageData())

        XCTAssertNil(view?.renderedImage, "Expected no rendered image when an image load finishes after the view is not visible anymore")
    }

    func test_loadFeedCompletion_dispatchesFromBackgroundToMainThread() {
        let (sut, loader) = makeSUT()
        sut.loadViewIfNeeded()

        let exp = expectation(description: "Wait for background queue")
        DispatchQueue.global().async {
            loader.completeGamesLoading(at: 0)
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1.0)
    }

    func test_loadImageDataCompletion_dispatchesFromBackgroundToMainThread() {
        let (sut, loader) = makeSUT()

        sut.loadViewIfNeeded()
        loader.completeGamesLoading(with: [makeItem()])
        _ = sut.simulateGameItemViewVisible(at: 0)

        let exp = expectation(description: "Wait for background queue")
        DispatchQueue.global().async {
            loader.completeImageLoading(with: self.anyImageData(), at: 0)
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1.0)
    }
    
    // MARK: - Helpers
    
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (sut: HomeViewController, loader: LoaderSpy) {
        let loader = LoaderSpy()
        let sut = HomeUIComposer.homeComposedWith(gamesLoader: loader, imageLoader: loader) { _ in }
        trackForMemoryLeaks(loader, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, loader)
    }
    
    private func makeItem(id: Int = 23423, title: String = "GTA", releaseDate: String = "2018-09-17", rating: Double = 4.3, image: URL = anyURL()) -> GameItem {
        return GameItem(id: id, title: title, releaseDate: releaseDate, rating: rating, image: image)
    }

    private func anyImageData() -> Data {
        return UIImage.make(withColor: .red).pngData()!
    }
}


extension HomeUIIntegrationTests {
    
    class LoaderSpy: GamesLoader, ImageDataLoader {
        
        // MARK: - FeedLoader
        
        private var gamesRequests = [(GamesLoader.Result) -> Void]()
        
        var loadGamesCallCount: Int {
            return gamesRequests.count
        }
        
        func load(request: GamesRequest, completion: @escaping (GamesLoader.Result) -> Void) {
            gamesRequests.append(completion)
        }
        
        func completeGamesLoading(with games: [GameItem] = [], at index: Int = 0) {
            gamesRequests[index](.success(games))
        }
        
        func completeGamesLoadingWithError(at index: Int = 0) {
            let error = NSError(domain: "an error", code: 0)
            gamesRequests[index](.failure(error))
        }
        
        // MARK: - FeedImageDataLoader
        
        private struct TaskSpy: ImageDataLoaderTask {
            let cancelCallback: () -> Void
            func cancel() {
                cancelCallback()
            }
        }
        
        private var imageRequests = [(url: URL, completion: (ImageDataLoader.Result) -> Void)]()
        
        var loadedImageURLs: [URL] {
            return imageRequests.map { $0.url }
        }
        
        private(set) var cancelledImageURLs = [URL]()
        
        func loadImageData(from url: URL, completion: @escaping (ImageDataLoader.Result) -> Void) -> ImageDataLoaderTask {
            imageRequests.append((url, completion))
            return TaskSpy { [weak self] in self?.cancelledImageURLs.append(url) }
        }
        
        func completeImageLoading(with imageData: Data = Data(), at index: Int = 0) {
            imageRequests[index].completion(.success(imageData))
        }
        
        func completeImageLoadingWithError(at index: Int = 0) {
            let error = NSError(domain: "an error", code: 0)
            imageRequests[index].completion(.failure(error))
        }
    }
    
}

extension HomeUIIntegrationTests {

    func assertThat(_ sut: HomeViewController, isRendering games: [GameItem], file: StaticString = #file, line: UInt = #line) {
        guard sut.numberOfRenderedGameItemViews() == games.count else {
            return XCTFail("Expected \(games.count) games, got \(sut.numberOfRenderedGameItemViews()) instead.", file: file, line: line)
        }
        
        games.enumerated().forEach { index, image in
            assertThat(sut, hasViewConfiguredFor: image, at: index, file: file, line: line)
        }
    }
    
    func assertThat(_ sut: HomeViewController, hasViewConfiguredFor game: GameItem, at index: Int, file: StaticString = #file, line: UInt = #line) {
        let view = sut.gameItemView(at: index)
        
        guard let cell = view as? GameCell else {
            return XCTFail("Expected \(GameCell.self) instance, got \(String(describing: view)) instead", file: file, line: line)
        }
        
        XCTAssertEqual(cell.titleText, game.title, "Expected title text to be \(String(describing: game.title)) for game view at index (\(index))", file: file, line: line)
        
        XCTAssertEqual(cell.releaseDateText, "Release date \(game.releaseDate)", "Expected Release Date text to be \(String(describing: game.releaseDate)) for game view at index (\(index)", file: file, line: line)
        
        XCTAssertEqual(cell.ratingText, "\(game.rating)", "Expected Rating text to be \(String(describing: game.rating)) for game view at index (\(index)", file: file, line: line)
    }
    
}
