//
//  ViewController.swift
//  Xrx
//
//  Created by Esteban on 5/18/17.
//  Copyright © 2017 org.eginez. All rights reserved.
//

import Cocoa

class ViewController: NSViewController, NSTableViewDataSource, NSTableViewDelegate {

    @IBOutlet weak var tableView: NSTableView!
    
    private let pasteboard = NSPasteboard.general()
    private var timer: Timer?
    private var copiedStrings = BufferContent()
    
    fileprivate enum CellIdentifiers {
        static let BufferContentID = "BufferContentID"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        timer = Timer.scheduledTimer(withTimeInterval: 2, repeats: true) { timer in
            self.checkPasteBoard()
        }
        tableView.delegate = self
        tableView.dataSource = self
        tableView.target = self
        tableView.doubleAction = #selector(tableViewDblClick(_:))
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return copiedStrings.count()
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let content = copiedStrings.getAt(position: row)
        if tableColumn == tableView.tableColumns[0] {
            guard let cell = tableView.make(withIdentifier: CellIdentifiers.BufferContentID, owner: nil) as? NSTableCellView else {
                return nil
            }
            cell.textField?.stringValue = content
            cell.imageView?.image = nil
            return cell
        }
        return nil
    }
    
    func checkPasteBoard() {
        if let stringInBuffer = pasteboard.string(forType: NSPasteboardTypeString) {
            let sizeBefore = copiedStrings.count()
            copiedStrings.insert(aString: stringInBuffer)
            if sizeBefore != copiedStrings.count() {
                print("Adding string ", stringInBuffer)
                tableView.reloadData()
            }
        }
    }
    
    func tableViewDblClick(_ sender:AnyObject){
        guard tableView.selectedRow >= 0 else {
            return
        }
        let content = copiedStrings.getAt(position: tableView.selectedRow)
        
        print("Copying to paste buffer ", content)
        pasteboard.clearContents()
        pasteboard.writeObjects([content as NSString])
    }
}

