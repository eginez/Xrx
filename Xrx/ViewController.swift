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
    private var copiedStrings: Set<String> = []
    
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
        return copiedStrings.count
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let arrayView = Array<String>(copiedStrings).reversed() as [String]
        let content = arrayView[row]
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
            let sizeBefore = copiedStrings.count
            copiedStrings.insert(stringInBuffer);
            if sizeBefore != copiedStrings.count {
                print("Adding string ", stringInBuffer)
                tableView.reloadData()
            }
            
        }
    }
    
    func tableViewDblClick(_ sender:AnyObject){
        let arrayView = Array<String>(copiedStrings)
        guard tableView.selectedRow >= 0 else {
            return
        }
        let content = arrayView[tableView.selectedRow]
        
        print("Copying to paste buffer ", content)
        pasteboard.clearContents()
        pasteboard.writeObjects([content as NSString])
    }
}

