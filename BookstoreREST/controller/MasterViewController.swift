//
//  MasterViewController.swift
//  BookstoreREST
//
//  Created by user168039 on 5/1/20.
//  Copyright © 2020 Tec. All rights reserved.
//

import UIKit

class MasterViewController: UITableViewController, BookDelegate {
    func newBook(_ controller: AnyObject, newBook: Book) {
        <#code#>
    }
    
    func editBook(_ controller: AnyObject, editBook: Book) {
        <#code#>
    }
    
    func deleteBook(_ controller: AnyObject) {
        let row = (tableView.indexPathForSelectedRow?.row)!
        service.deleteBook(id: row) { (error) in
            if let error = error {
                print("fail to delete", error)
                return
            }
            
            print("Succesfully deleted post")
        }
        tableView.reloadData()
        navigationController?.popToRootViewController(animated: true)
    }
    

    var detailViewController: DetailViewController? = nil
    let service = BookService()
    var bookList : [Book] = []


    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let split = splitViewController {
            let controllers = split.viewControllers
            detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
        
        refresh()
    }

    private func refresh() {
        service.getAll() { [unowned self] (bookList) in
            self.bookList = bookList
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
        super.viewWillAppear(animated)
    }
    

    // MARK: - Segues
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let book = bookList[indexPath.row]
                let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
                controller.detailItem = book
                controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
                controller.delegate = self
            }
        }
    }

    // MARK: - Table View
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bookList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let book = bookList[indexPath.row]
        cell.textLabel!.text = book.title

        return cell
    }
}

