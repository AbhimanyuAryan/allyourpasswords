//
//  ContainerViewController.swift
//  allyourpasswords
//
//  Created by Sean Walker on 1/18/19.
//  Copyright © 2019 Sean Walker. All rights reserved.
//

import Cocoa
import SQLite

class ContainerViewController : NSViewController {

    var row : Row?
    var tableViewController : TableViewController?
    var detailViewController: DetailViewController?

    @IBOutlet weak var containerView: NSView!

    func showDetailViewController() {
        let storyboard = NSStoryboard(name: NSStoryboard.Name("Main"), bundle: Bundle.main)

        if let oldViewController = detailViewController {
            oldViewController.view.removeFromSuperview()
            oldViewController.removeFromParent()
            detailViewController = nil
        }

        detailViewController = storyboard.instantiateController(withIdentifier: "DetailViewController") as? DetailViewController
        detailViewController!.row = row
        detailViewController!.tableViewController = tableViewController
        
        addChild(detailViewController!)
        detailViewController!.view.frame = containerView.bounds
        containerView.addSubview(detailViewController!.view)
    }

    func showEmptyViewController() {
        let storyboard = NSStoryboard(name: NSStoryboard.Name("Main"), bundle: Bundle.main)

        for sView in containerView.subviews {
            sView.removeFromSuperview()
        }

        let vc = storyboard.instantiateController(withIdentifier: "EmptyViewController") as! EmptyViewController
        vc.tableViewController = tableViewController

        addChild(vc)
        vc.view.frame = containerView.bounds
        containerView.addSubview(vc.view)
    }

    func showEditViewController() {
        let storyboard = NSStoryboard(name: NSStoryboard.Name("Main"), bundle: Bundle.main)

        for sView in containerView.subviews {
            sView.removeFromSuperview()
        }

        let vc = storyboard.instantiateController(withIdentifier: "EditViewController") as! EditViewController
        vc.tableViewController = tableViewController

        addChild(vc)
        vc.view.frame = containerView.bounds
        containerView.addSubview(vc.view)
    }
    
    override func viewDidLoad() {
        let db = Database.open()
        let login = Login()
        let rowCount = try! db?.scalar(login.table.count)
        let firstRow = try! db?.pluck(login.table.limit(0).order(login.id))

        if (rowCount! > 0) {
            row = firstRow
            showDetailViewController()
        } else {
            showEmptyViewController()
        }

        super.viewDidLoad()
    }

    @IBAction func addNewLogin(_ sender: NSMenuItem) {
        showEditViewController()
    }
}
