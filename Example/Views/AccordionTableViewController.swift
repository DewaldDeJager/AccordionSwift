//
//  AccordionTableViewController.swift
//  Example
//
//  Created by Victor Sigler Lopez on 7/5/18.
//  Copyright © 2018 Victor Sigler. All rights reserved.
//

import UIKit
import AccordionSwift

class AccordionTableViewController: UITableViewController {
    
    // MARK: - Typealias
    
    typealias ParentCellModel = Parent<GroupCellModel, CountryCellModel>
    typealias ParentCellConfig = CellViewConfig<ParentCellModel, UITableViewCell>
    typealias ChildCellConfig = CellViewConfig<CountryCellModel, CountryTableViewCell>
    
    // MARK: - Properties
    
    /// The Data Source Provider with the type of DataSource and the different models for the Parent and Child cell.
    var dataSourceProvider: DataSourceProvider<DataSource<ParentCellModel>, ParentCellConfig, ChildCellConfig>?
    
    // MARK: - UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configDataSource()
        navigationItem.title = "World Cup 2018"
    }
}

extension AccordionTableViewController {
    
    // MARK: - Methods
    
    /// Configure the data source
    private func configDataSource() {
        
        let groupA = Parent(state: .collapsed, item: GroupCellModel(name: "Group A"),
                            childs: [CountryCellModel(name: "Uruguay"),
                                     CountryCellModel(name: "Russia"),
                                     CountryCellModel(name: "Saudi Arabia"),
                                     CountryCellModel(name: "Egypt")]
        )
        
        let groupB = Parent(state: .expanded, item: GroupCellModel(name: "Group B"),
                            childs: [CountryCellModel(name: "Spain"),
                                     CountryCellModel(name: "Portugal"),
                                     CountryCellModel(name: "Iran"),
                                     CountryCellModel(name: "Morocco")]
        )
        
        let groupC = Parent(state: .expanded, item: GroupCellModel(name: "Group C"),
                            childs: [CountryCellModel(name: "France"),
                                     CountryCellModel(name: "Denmark"),
                                     CountryCellModel(name: "Peru"),
                                     CountryCellModel(name: "Australia")]
        )
        
        let groupD = Parent(state: .expanded, item: GroupCellModel(name: "Group D"),
                            childs: [CountryCellModel(name: "Croatia"),
                                     CountryCellModel(name: "Argentina"),
                                     CountryCellModel(name: "Nigeria"),
                                     CountryCellModel(name: "Iceland")]
        )
        
        let groupE = Parent(state: .collapsed, item: GroupCellModel(name: "Group E"),
                            childs: [CountryCellModel(name: "Brazil"),
                                     CountryCellModel(name: "Switzerland"),
                                     CountryCellModel(name: "Serbia"),
                                     CountryCellModel(name: "Costa Rica")]
        )
        
        let groupF = Parent(state: .collapsed, item: GroupCellModel(name: "Group F"),
                            childs: [CountryCellModel(name: "Sweden"),
                                     CountryCellModel(name: "Mexico"),
                                     CountryCellModel(name: "South Korea"),
                                     CountryCellModel(name: "Germany")]
        )
        
        let groupG = Parent(state: .collapsed, item: GroupCellModel(name: "Group G"),
                            childs: [CountryCellModel(name: "Belgium"),
                                     CountryCellModel(name: "England"),
                                     CountryCellModel(name: "Tunisia"),
                                     CountryCellModel(name: "Panama")]
        )
        
        let groupH = Parent(state: .collapsed, item: GroupCellModel(name: "Group H"),
                            childs: [CountryCellModel(name: "Colombia"),
                                     CountryCellModel(name: "Japan"),
                                     CountryCellModel(name: "Senegal"),
                                     CountryCellModel(name: "Poland")]
        )
        
        let section0 = Section([groupA, groupB, groupC, groupD, groupE, groupF, groupG, groupH], headerTitle: nil)
        let dataSource = DataSource(sections: section0)
        
        let parentCellConfig = CellViewConfig<Parent<GroupCellModel, CountryCellModel>, UITableViewCell>(
        reuseIdentifier: "GroupCell") { (cell, model, tableView, indexPath) -> UITableViewCell in
            cell.textLabel?.text = model?.item.name
            return cell
        }
        
        let childCellConfig = CellViewConfig<CountryCellModel, CountryTableViewCell>(
        reuseIdentifier: "CountryCell") { (cell, item, tableView, indexPath) -> CountryTableViewCell in
            cell.contryLabel.text = item?.name
            cell.countryImageView.image = UIImage(named: "\(item!.name.lowercased())")
            return cell
        }
        
        let didSelectParentCell = { (tableView: UITableView, indexPath: IndexPath, item: ParentCellModel?) -> Void in
            print("Parent cell \(item!.item.name) tapped")
        }
        
        let didSelectChildCell = { (tableView: UITableView, indexPath: IndexPath, item: CountryCellModel?) -> Void in
            print("Child cell \(item!.name) tapped")
        }
        
        let scrollViewDidScroll = { (scrollView: UIScrollView) -> Void in
            print(scrollView.contentOffset)
            
        }
        
        dataSourceProvider = DataSourceProvider(
            dataSource: dataSource,
            parentCellConfig: parentCellConfig,
            childCellConfig: childCellConfig,
            didSelectParentAtIndexPath: didSelectParentCell,
            didSelectChildAtIndexPath: didSelectChildCell,
            scrollViewDidScroll: scrollViewDidScroll
        )
        
        tableView.dataSource = dataSourceProvider?.tableViewDataSource
        tableView.delegate = dataSourceProvider?.tableViewDelegate
        tableView.tableFooterView = UIView()
    }
}
