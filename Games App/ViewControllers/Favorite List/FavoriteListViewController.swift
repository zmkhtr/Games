//
//  FavoriteListViewController.swift
//  Games App
//
//  Created by Azam Mukhtar on 23/02/23.
//

import UIKit

final class FavoriteListViewController: UIViewController {
    
    private let viewModel: FavoriteViewModel
    private var cellControllers: [GameCellController] = []
    
    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl(frame: .zero)
        refreshControl.addTarget(self, action: #selector(self.refresh), for: .valueChanged)
        refreshControl.tintColor = .black
        return refreshControl
    }()
    
    @IBOutlet weak var labelEmpty: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    private let onGameSelected: ((Int) -> Void)
    
    public init(viewModel: FavoriteViewModel, onGameSelected: @escaping ((Int) -> Void)) {
        self.viewModel = viewModel
        self.onGameSelected = onGameSelected
        
        super.init(nibName: "FavoriteListViewController", bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented, You should't initialize the ViewController through Storyboards")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        setUpTableView()
        bindViewModel()
        refresh()
    }
    
    private func setUpTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.prefetchDataSource = self
        tableView.refreshControl = refreshControl
        tableView.register(UINib(nibName: "GameCell", bundle: nil), forCellReuseIdentifier: "GameCell")
    }
    
    @objc func refresh() {
        viewModel.loadGames()
    }
}

extension FavoriteListViewController {
    
    private func bindViewModel() {
        viewModel.onGamesLoad = { [weak self] gameCellControllers in
            guard let self = self else { return }
            self.cellControllers = gameCellControllers
            if self.cellControllers.isEmpty {
                self.labelEmpty.isHidden = false
            } else {
                self.labelEmpty.isHidden = true
            }
            self.tableView.reloadData()
        }
        
        viewModel.onErrorStateChange = { [weak self] errorMessage in
            guard let self = self else { return }
            if errorMessage != nil {
                self.labelEmpty.isHidden = false
            } else {
                self.labelEmpty.isHidden = true
            }
        }
        
        viewModel.onLoadingStateChange = { [weak self] isLoading in
            guard let self = self else { return }
            isLoading ? self.refreshControl.beginRefreshing() : self.refreshControl.endRefreshing()
        }
    }
    
}


extension FavoriteListViewController: UITableViewDelegate, UITableViewDataSource, UITableViewDataSourcePrefetching {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellControllers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return cellControllers[indexPath.row].view(in: tableView, for: indexPath)
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if cellControllers.indices.contains(indexPath.row) {
            cellControllers[indexPath.row].cancelLoad()
        }
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
        let id = cellControllers[indexPath.row].getItem().id
        onGameSelected(id)
    }
}

