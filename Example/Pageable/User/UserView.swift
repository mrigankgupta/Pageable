
//
//  Created by Gupta, Mrigank on 04/08/18.
//  Copyright © 2018 Gupta, Mrigank. All rights reserved.
//

import UIKit
import Pageable

class UserView: UIViewController {

    private var pgInteractor: PageInteractor<User, Int>
    private lazy var tableView = UITableView()

    init(pageInteractor: PageInteractor<User, Int>) {
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
        pgInteractor.pageDataSource = self
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
            let user = pgInteractor.selectedItem(for: indexPath.row)
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
// SETUP:3 Adopting PageDataSource Protocol
extension UserView: PageDataSource {}

extension UserView {
    //4. refresh page to load
    @objc
    func refreshPage() {
        pgInteractor.refreshPage()
    }
}

extension UIView {
    static func nibName() -> String {
        return String(describing: self)
    }

    static func reusableIdetifier() -> String {
        return String(describing: self)
    }
}

extension UITableView {
    // Reusable identifier should be unique across the app.There should be a convention to
    // give identifer names as there are chances for collision if app has
    // lots of cells and views. We can use compiler help here by using Class name as reusable identifier and nib names.
    // As we can only create cell class with unique names, it will help in giving unique reusable identifier name also.
    func dequeueReusableCell<T: UITableViewCell> (for indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withIdentifier: T.reusableIdetifier(), for: indexPath) as? T else {
            fatalError("Can't not cast Cell with reusable identfier\(T.reusableIdetifier())")
        }
        return cell
    }

    func dequeueReusableHeaderFooterView<T: UIView> () -> T {
        guard let cell = dequeueReusableHeaderFooterView(withIdentifier:T.reusableIdetifier()) as? T else {
            fatalError("Can't not cast View with reusable identfier\(T.reusableIdetifier())")
        }
        return cell
    }

    func registerNib<T: UITableViewCell>(forCell: T.Type) {
        register(UINib(nibName: T.nibName(), bundle: nil), forCellReuseIdentifier: T.reusableIdetifier())
    }

    func registerNib<T: UIView>(forforHeaderFooterView: T.Type) {
        register(UINib(nibName: T.nibName(), bundle: nil), forHeaderFooterViewReuseIdentifier: T.reusableIdetifier())
    }
}
