//
//  HomeViewController.swift
//  GameUI
//
//  Created by Azam Mukhtar on 23/02/23.
//

import UIKit
import Games

final public class HomeViewController: UIViewController {
    
    private let viewModel: HomeViewModel
    private var cellControllers: [GameCellController] = []
    
    public lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl(frame: .zero)
        refreshControl.addTarget(self, action: #selector(self.refresh), for: .valueChanged)
        refreshControl.tintColor = .black
        return refreshControl
    }()
    
    private lazy var loadingFooter: LoadingFooter = {
        let footer = LoadingFooter.instanceFromNib()
        footer.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: tableView.bounds.width, height: CGFloat(100))

        return footer
    }()
    
    @IBOutlet private(set) public weak var tableView: UITableView!
    @IBOutlet private(set) public weak var retryButton: UIButton!
    
    private let onGameSelected: ((Int) -> Void)
    
    public init(viewModel: HomeViewModel, onGameSelected: @escaping ((Int) -> Void)) {
        self.viewModel = viewModel
        self.onGameSelected = onGameSelected
        
        super.init(nibName: "HomeViewController", bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented, You should't initialize the ViewController through Storyboards")
    }
    
    public override func viewDidLoad() {
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
        search.delegate = self
        self.navigationItem.searchController = search
        self.navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    private func setUpTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.prefetchDataSource = self
        tableView.refreshControl = refreshControl
        tableView.register(UINib(nibName: "GameCell", bundle: nil), forCellReuseIdentifier: "GameCell")
        
        tableView.contentInset.bottom = self.tabBarController?.tabBar.frame.height ?? 0
        tableView.tableFooterView = loadingFooter
        tableView.tableFooterView?.isHidden = true
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
            guard let self = self else { return }
            if errorMessage != nil {
                self.loadingFooter.labelError.isHidden = false
                self.tableView.tableFooterView?.isHidden = false
                self.loadingFooter.activityLoading.stopAnimating()
            } else {
                self.loadingFooter.labelError.isHidden = true
                self.tableView.tableFooterView?.isHidden = false
                self.loadingFooter.activityLoading.startAnimating()
            }
        }
        
        viewModel.onLoadingNextPageStateChange = { [weak self] isLoading in
            guard let self = self else { return }
            if isLoading {
                self.tableView.tableFooterView?.isHidden = false
                self.loadingFooter.activityLoading.startAnimating()
            } else {
                self.tableView.tableFooterView?.isHidden = true
                self.loadingFooter.activityLoading.stopAnimating()
            }
        }
    }
    
    
}


extension HomeViewController: UITableViewDelegate, UITableViewDataSource, UITableViewDataSourcePrefetching {
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellControllers.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return cellControllers[indexPath.row].view(in: tableView, for: indexPath)
    }
    
    public func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if cellControllers.indices.contains(indexPath.row) {
            cellControllers[indexPath.row].cancelLoad()
        }
    }
    
    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cellControllers[indexPath.row].preload()
    }
    
    public func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        indexPaths.forEach { indexPath in
            cellControllers[indexPath.row].preload()
        }
    }
    
    public func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
        indexPaths.forEach { indexPath in
            cellControllers[indexPath.row].cancelLoad()
        }
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let id = cellControllers[indexPath.row].getItem().id
        onGameSelected(id)
    }
}


extension HomeViewController {
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView.isDragging && !cellControllers.isEmpty else { return }
        
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        if (offsetY > contentHeight - scrollView.frame.height) {
            viewModel.loadNextPage()
        }
    }
}


extension HomeViewController: UISearchBarDelegate, UISearchControllerDelegate {
    public func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(HomeViewController.searchQuery), object: nil)
           self.perform(#selector(HomeViewController.searchQuery), with: nil, afterDelay: 0.5)
     
    }
    
    @objc func searchQuery() {
        guard let query = navigationItem.searchController?.searchBar.text else { return }
        cellControllers.removeAll()
        tableView.reloadData()
        viewModel.loadGames(query: query)
    }
    
    public func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        cellControllers.removeAll()
        tableView.reloadData()
        viewModel.loadGames()
    }
}


