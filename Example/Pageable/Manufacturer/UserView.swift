
//
//  Created by Gupta, Mrigank on 04/08/18.
//  Copyright © 2018 Gupta, Mrigank. All rights reserved.
//

import UIKit
import Pageable

private let firstReqIndex = 1

class UserView: UIViewController {

    var mfInteractor: PageInteractor<User, String>!
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupPageInteractor()

        setupTableView()
        tableView.setupRefreshControl(self, selector:#selector(self.refreshPage))
    }

    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: String(describing: UserView.self), bundle: nil), forCellReuseIdentifier:
            String(describing: UserView.self))
        tableView.register(UINib(nibName: String(describing: LoadingCell.self), bundle: Bundle.main),
                           forCellReuseIdentifier: String(describing: LoadingCell.self))
        tableView.estimatedRowHeight = 80
        #if swift(>=4.2)
        tableView.rowHeight = UITableView.automaticDimension
        #else
        tableView.rowHeight = UITableViewAutomaticDimension
        #endif
        tableView.tableFooterView = UIView(frame: .zero)
    }

    private func setupPageInteractor() {
        mfInteractor = PageInteractor(firstPage: firstReqIndex)
        mfInteractor.pageDelegate = self.tableView
        mfInteractor.pageDataSource = self
        let mfService = UserService(firstPage: firstReqIndex)
        mfService.delegate = mfInteractor
        mfInteractor.service = mfService
        mfInteractor.setupService()
    }
}

extension UserView: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int { return 1 }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mfInteractor.visibleRow()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row >= mfInteractor.count() {
            let loading = tableView.dequeueReusableCell(withIdentifier: String(describing: LoadingCell.self), for: indexPath) as! LoadingCell
            loading.activityIndicator.startAnimating()
            return loading
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: InformationCell.self), for: indexPath) as! InformationCell
            let manufacturer = mfInteractor.selectedItem(for: indexPath.row)
            cell.configureCell(with: manufacturer, for: indexPath)
            return cell
        }
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell,
                            forRowAt indexPath: IndexPath) {
        mfInteractor.shouldPrefetch(index: indexPath.row)
    }
}

extension UserView: PageDataSource {

    func addUniqueItems(for items: [AnyObject]) -> Range<Int> {
        let startIndex = mfInteractor.count()
        if let items = items as? [User] {
            for new in items {
                if mfInteractor.dict[String(new.id)] == nil {
                    mfInteractor.dict[String(new.id)] = String(new.id)
                    mfInteractor.array.append(new)
                }
            }
        }
        return startIndex..<mfInteractor.count()
    }

    func addAll(items: [AnyObject]) {
        if let items = items as? [User] {
            mfInteractor.array = items
            for new in items {
                mfInteractor.dict[String(new.id)] = String(new.id)
            }
        }
    }

}

extension UserView {
    @objc
    func refreshPage() {
        mfInteractor.refreshPage()
    }
}
