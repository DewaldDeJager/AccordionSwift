//
//  DataSource.swift
//  AccordionSwift
//
//  Created by Victor Sigler Lopez on 7/3/18.
//  Copyright © 2018 Victor Sigler. All rights reserved.
//

import Foundation

/// Defines a sectioned data source to be displayed in the UITableView
open class DataSource<Item: ParentType>: DataSourceType {

    // MARK: - Properties

    /// The sections in the data source.
    open var sections: [Section<Item>]

    // MARK: -  Initialization

    /// Constructs a new DataSource.
    ///
    /// - Parameter sections: The sections for the data source.
    public init(_ sections: [Section<Item>]) {
        self.sections = sections
    }

    /// Constructs a new DataSource.
    ///
    /// - Parameter sections: The sections for the data source.
    public init(sections: Section<Item>...) {
        self.sections = sections
    }

    // MARK: - Methods

    /// Inserts the item at the specified index path
    ///
    /// - Parameters:
    ///   - item: The item to be inserted.
    ///   - indexPath: The index path specifying the location for the item.
    open func insert(item: Item, at indexPath: IndexPath) {
        insert(item: item, atRow: indexPath.row, inSection: indexPath.section)
    }

    /// Inserts the item at the specified row and section.
    ///
    /// - Parameters:
    ///   - item: The item to insert.
    ///   - row:  The row index of the item.
    ///   - section: The section index of the item.
    open func insert(item: Item, atRow row: Int, inSection section: Int) {
        guard section < numberOfSections() else { return }
        guard row <= numberOfItems(inSection: section) else { return }
        sections[section].items.insert(item, at: row)
    }

    /// Add the item at the specified section.
    ///
    /// - Parameters:
    ///   - item:  The item to be added.
    ///   - section: The section location for the item.
    open func append(_ item: Item, inSection section: Int) {
        guard let items = items(inSection: section) else { return }
        insert(item: item, atRow: items.endIndex, inSection: section)
    }

    /// Removes the item at the specified row and section.
    ///
    /// - Parameters:
    ///   - row: The row location of the item.
    ///   - section: The section location of the item.
    /// - Returns: The item removed, otherwise nil if it does not exist.
    @discardableResult
    open func remove(atRow row: Int, inSection section: Int) -> Item? {
        guard item(atRow: row, inSection: section) != nil else { return nil }
        return sections[section].items.remove(at: row)
    }

    /// Removes the item at the specified index path.
    ///
    /// - Parameter indexPath: The index path specifying the location of the item.
    /// - Returns:  The item at `indexPath`, otherwise nil if it does not exist.
    @discardableResult
    open func remove(at indexPath: IndexPath) -> Item? {
        return remove(atRow: indexPath.row, inSection: indexPath.section)
    }

    // MARK: - Subscripts

    /// The section at the specified index.
    ///
    /// - Parameter index: The index of a section.
    open subscript (index: Int) -> Section<Item> {
        get { return sections[index] }
        set { sections[index] = newValue }
    }

    /// The item at the specified index path.
    ///
    /// - Parameter indexPath: The index path of an item.
    open subscript (indexPath: IndexPath) -> Item {
        get { return sections[indexPath.section].items[indexPath.row] }
        set { sections[indexPath.section].items[indexPath.row] = newValue }
    }

    // MARK: - DataSourceType Methods

    open func numberOfSections() -> Int {
        return sections.count
    }

    open func numberOfItems(inSection section: Int) -> Int {
        guard section < sections.count else { return 0 }
        return sections[section].total
    }

    open func items(inSection section: Int) -> [Item]? {
        guard section < sections.count else { return nil }
        return sections[section].items
    }

    open func item(atRow row: Int, inSection section: Int) -> Item? {
        guard let items = items(inSection: section) else { return nil }
        guard row < items.count else { return nil }
        return items[row]
    }

    open func headerTitle(inSection section: Int) -> String? {
        guard section < sections.count else { return nil }
        return sections[section].headerTitle
    }

    open func footerTitle(inSection section: Int) -> String? {
        guard section < sections.count else { return nil }
        return sections[section].footerTitle
    }

    open func childItem(atRow row: Int, inSection section: Int, parentIndex: Int, currentPos: Int) -> Item.ChildItem? {
        guard let items = items(inSection: section) else { return nil }
        return items[parentIndex].children[row - currentPos - 1]
    }

    open func expandParent(atIndexPath indexPath: IndexPath, parentIndex: Int) {
        let section = indexPath.section
        guard var items = items(inSection: section) else { return }
        items[parentIndex].state = .expanded
        sections[section].total += items[parentIndex].children.count
    }

    open func collapseChildren(atIndexPath indexPath: IndexPath, parentIndex: Int) {
        let section = indexPath.section
        guard var items = items(inSection: section) else { return }
        items[parentIndex].state = .collapsed
        sections[section].total -= items[parentIndex].children.count
    }
}
