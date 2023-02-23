//
//  HomeViewController.swift
//  GameUI
//
//  Created by Azam Mukhtar on 23/02/23.
//

import UIKit
import Games

final class HomeViewController: UIViewController {
    
    private let viewModel: HomeViewModel
    private var cellControllers: [GameCellController] = []
    
    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl(frame: .zero)
        refreshControl.addTarget(self, action: #selector(self.refresh), for: .valueChanged)
        refreshControl.tintColor = .black
        return refreshControl
    }()
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var retryButton: UIButton!
    
    public init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        
        
        super.init(nibName: "HomeViewController", bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented, You should't initialize the ViewController through Storyboards")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        setupView()
        bindViewModel()
        refresh()
    }
    
    private func setupView() {
        setUpTableView()
        setUpSearchController()
    }
    
    private func setUpSearchController() {
        let search = UISearchController(searchResultsController: nil)
        search.searchBar.delegate = self
        self.navigationItem.searchController = search
        self.navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    private func setUpTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.prefetchDataSource = self
        tableView.refreshControl = refreshControl
        tableView.register(UINib(nibName: "GameCell", bundle: nil), forCellReuseIdentifier: "GameCell")
    }
    
    @objc func refresh() {
        var query = ""
        if let searchText = navigationItem.searchController?.searchBar.text {
            query = searchText
        }

        viewModel.loadGames(query: query)
    }
    
    
    @IBAction func retryAction(_ sender: UIButton) {
        refresh()
    }
}

extension HomeViewController {
    
    private func bindViewModel() {
        bindViewModelFirstLoad()
        bindViewModelNextPage()
    }
    
    private func bindViewModelFirstLoad() {
        viewModel.onGamesLoad = { [weak self] gameCellControllers in
            guard let self = self else { return }
            self.cellControllers = gameCellControllers
            self.tableView.reloadData()
        }
        
        viewModel.onErrorStateChange = { [weak self] errorMessage in
            guard let self = self else { return }
            if errorMessage != nil {
                self.retryButton.isHidden = false
            } else {
                self.retryButton.isHidden = true
            }
        }
        
        viewModel.onLoadingStateChange = { [weak self] isLoading in
            guard let self = self else { return }
            isLoading ? self.refreshControl.beginRefreshing() : self.refreshControl.endRefreshing()
        }
    }
    
    private func bindViewModelNextPage() {
        viewModel.onNextPageGamesLoad = { [weak self] gameCellControllers in
            guard let self = self else { return }
            let startIndex = self.cellControllers.count
            let endIndex = startIndex + gameCellControllers.count
            self.cellControllers.append(contentsOf: gameCellControllers)
            
            self.tableView.insertRows(at: (startIndex..<endIndex).map({ row in
                IndexPath(row: row, section: 0)
            }), with: .left)
        }
        
        viewModel.onErrorGettingNextPage = { [weak self] errorMessage in
//            guard let self = self else { return }
            // - TODO: After Get Data done.
            
        }
        
        viewModel.onLoadingNextPageStateChange = { [weak self] isLoading in
//            guard let self = self else { return }
            // - TODO: After Get Data done.
        }
    }
    
    
}


extension HomeViewController: UITableViewDelegate, UITableViewDataSource, UITableViewDataSourcePrefetching {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellControllers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return cellControllers[indexPath.row].view(in: tableView, for: indexPath)
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cellControllers[indexPath.row].cancelLoad()
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cellControllers[indexPath.row].preload()
    }
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        indexPaths.forEach { indexPath in
            cellControllers[indexPath.row].preload()
        }
    }
    
    func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
        indexPaths.forEach { indexPath in
            cellControllers[indexPath.row].cancelLoad()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}


extension HomeViewController {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView.isDragging else { return }
        
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        if (offsetY > contentHeight - scrollView.frame.height) {
            viewModel.loadNextPage()
        }
    }
}
extension HomeViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(HomeViewController.searchQuery), object: nil)
           self.perform(#selector(HomeViewController.searchQuery), with: nil, afterDelay: 0.5)
     
    }
    
    @objc func searchQuery() {
        guard let query = navigationItem.searchController?.searchBar.text else { return }
        cellControllers.removeAll()
        tableView.reloadData()
        viewModel.loadGames(query: query)
    }
}


