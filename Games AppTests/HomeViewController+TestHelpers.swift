//
//  HomeViewController+TestHelpers.swift
//  Games AppTests
//
//  Created by Azam Mukhtar on 23/02/23.
//

import UIKit
import Games_App

extension HomeViewController {
    func simulateUserInitiatedGamesReload() {
        refreshControl.simulatePullToRefresh()
    }
    
    @discardableResult
    func simulateGameItemViewVisible(at index: Int) -> GameCell? {
        return gameItemView(at: index) as? GameCell
    }
    
    @discardableResult
    func simulateGameItemViewNotVisible(at row: Int) -> GameCell? {
        let view = simulateGameItemViewVisible(at: row)
        
        let delegate = tableView.delegate
        let index = IndexPath(row: row, section: gameItemSection)
        delegate?.tableView?(tableView, didEndDisplaying: view!, forRowAt: index)
        
        return view
    }
    
    func simulateGameItemViewNearVisible(at row: Int) {
        let ds = tableView.prefetchDataSource
        let index = IndexPath(row: row, section: gameItemSection)
        ds?.tableView(tableView, prefetchRowsAt: [index])
    }
    
    func simulateGameItemViewNotNearVisible(at row: Int) {
        simulateGameItemViewNearVisible(at: row)
        
        let ds = tableView.prefetchDataSource
        let index = IndexPath(row: row, section: gameItemSection)
        ds?.tableView?(tableView, cancelPrefetchingForRowsAt: [index])
    }
    
    func renderedImageData(at index: Int) -> Data? {
        return simulateGameItemViewVisible(at: index)?.renderedImage
    }

    var errorMessage: String? {
        if retryButton.isHidden {
            return nil
        }
        return retryButton.titleLabel?.text
    }

    var isShowingLoadingIndicator: Bool {
        return refreshControl.isRefreshing == true
    }
    
    func numberOfRenderedGameItemViews() -> Int {
        return tableView.numberOfRows(inSection: gameItemSection)
    }
    
    func gameItemView(at row: Int) -> UITableViewCell? {
        guard numberOfRenderedGameItemViews() > row else {
            return nil
        }
        let ds = tableView.dataSource
        let index = IndexPath(row: row, section: gameItemSection)
        return ds?.tableView(tableView, cellForRowAt: index)
    }
    
    private var gameItemSection: Int {
        return 0
    }
}


extension UIRefreshControl {
    func simulatePullToRefresh() {
        simulate(event: .valueChanged)
    }
}

extension UIControl {
    func simulate(event: UIControl.Event) {
        allTargets.forEach { target in
            actions(forTarget: target, forControlEvent: event)?.forEach {
                (target as NSObject).perform(Selector($0))
            }
        }
    }
}

extension UIButton {
    func simulateTap() {
        simulate(event: .touchUpInside)
    }
}


extension GameCell {
    func simulateRetryAction() {
        buttonRetryImage.simulateTap()
    }
    
    var isShowingImageLoadingIndicator: Bool {
        return viewImageContainer.isShimmering
    }
    
    var isShowingRetryAction: Bool {
        return !buttonRetryImage.isHidden
    }
    
    var titleText: String? {
        return labelTitle.text
    }
    
    var releaseDateText: String? {
        return labelReleaseDate.text
    }
    
    var ratingText: String? {
        return labelRating.text
    }
    
    var renderedImage: Data? {
        return imageGame.image?.pngData()
    }
}

func anyURL() -> URL {
    return URL(string: "http://any-url.com")!
}
