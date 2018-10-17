//
//  ViewController.swift
//  Microcaps
//
//  Created by Sidney de Koning on 21/12/2017.
//  Copyright © 2017 Funky Monkey. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    
    let datasource = MarketcapDatasource()
    
    @IBOutlet weak var tableView: NSTableView!
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.doubleAction = #selector(self.tableViewDoubleClick(_:))
        
        reload()
    }
    
    override func viewDidAppear() {
        if let window = self.view.window {            
            self.view.wantsLayer = true
            self.view.layer?.backgroundColor = NSColor.white.cgColor
            
            window.titlebarAppearsTransparent = true
            window.titleVisibility = .hidden
            window.styleMask.insert(.fullSizeContentView)
        }
    }
    
    @IBAction func reloadData(_ sender: Any) {
        self.reload()
    }
    
    func reload() {
        print("Calling reload...")
        self.datasource.load {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

}

extension ViewController: NSTableViewDataSource {
    func numberOfRows(in tableView: NSTableView) -> Int {
        return self.datasource.data.count
    }
}

extension ViewController: NSTableViewDelegate {
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        
        let item = self.datasource.data[row]
        var text: String = ""
        var cellIdentifier: String = ""
        
        if tableColumn == tableView.tableColumns[0] {
            text = item.rank.string
            cellIdentifier = "RankId"
        } else if tableColumn == tableView.tableColumns[1] {
            text = item.symbol.string
            cellIdentifier = "SymbolId"
        }else if tableColumn == tableView.tableColumns[2] {
            text = item.name.string
            cellIdentifier = "TokenNameId"
        }else if tableColumn == tableView.tableColumns[3] {
            text = String(describing: item.marketCapEur)
            cellIdentifier = "MarketCapId"
        } else if tableColumn == tableView.tableColumns[4] {
            text = String(describing: item.availableSupply)
            cellIdentifier = "AvailableSupplyId"
        } else if tableColumn == tableView.tableColumns[5] {
            text = String(describing: item.totalSupply)
            cellIdentifier = "TotalSupplyId"
        }
        
        if let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: cellIdentifier), owner: nil) as? NSTableCellView {
            cell.textField?.stringValue = text
            cell.textField?.alignment = .left
            return cell
        }
        return nil
    }
    
    func tableViewSelectionDidChange(_ notification: Notification) {
        // Not implemented yet
    }
    
    @objc func tableViewDoubleClick(_ sender:AnyObject) {
        guard tableView.selectedRow >= 0 else {
            return
        }
        
        let item = self.datasource.data[self.tableView.selectedRow]
        
        let id = item.id.string
        let url = URL(string: "https://coinmarketcap.com/currencies/" + id)!
        NSWorkspace.shared.open(url)
    }
}
