
//
//  Created by Gupta, Mrigank on 04/08/18.
//  Copyright © 2018 Gupta, Mrigank. All rights reserved.
//

import UIKit
import Pageable

class UserView: UIViewController {

    private var pgInteractor: PageInteractor<UserModel, Int>
    private lazy var tableView = UITableView()

    init(pageInteractor: PageInteractor<UserModel, Int>) {
        self.pgInteractor = pageInteractor
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupPageInteractor()
    }

    private func setupTableView() {
        tableView.frame = view.bounds
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.registerNib(forCell: InformationCell.self)
        tableView.registerNib(forCell: LoadingCell.self)
        tableView.estimatedRowHeight = 80
        #if swift(>=4.2)
        tableView.rowHeight = UITableView.automaticDimension
        #else
        tableView.rowHeight = UITableViewAutomaticDimension
        #endif
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.setupRefreshControl(self, selector:#selector(self.refreshPage))
    }
    // SETUP:1 Setup PageInteractor
    private func setupPageInteractor() {
        pgInteractor.pageDelegate = self.tableView
        pgInteractor.refreshPage()
    }
}

extension UserView: UITableViewDelegate, UITableViewDataSource {
    // SETUP:2 Populate cells from PageInteractor
    func numberOfSections(in tableView: UITableView) -> Int { return 1 }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pgInteractor.visibleRow()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row >= pgInteractor.count() {
            let loadingCell: LoadingCell = tableView.dequeueReusableCell(for: indexPath)
            loadingCell.activityIndicator.startAnimating()
            return loadingCell
        } else {
            let infoCell: InformationCell = tableView.dequeueReusableCell(for: indexPath)
            let user = pgInteractor.item(for: indexPath.row)
            infoCell.configureCell(with: user, for: indexPath)
            return infoCell
        }
    }

    func tableView(_ tableView: UITableView,
                   willDisplay cell: UITableViewCell,
                   forRowAt indexPath: IndexPath) {
        pgInteractor.shouldPrefetch(index: indexPath.row)
    }
}

extension UserView {
    // SETUP:4 refresh page to load
    @objc
    func refreshPage() {
        pgInteractor.refreshPage()
    }
}
