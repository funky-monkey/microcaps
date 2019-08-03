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
	@IBOutlet weak var refreshButton: NSButton!

	var appearanceChangeObservation: NSKeyValueObservation?

    override func viewDidLoad() {
        
        super.viewDidLoad()

		refreshButton.focusRingType = .none

		self.appearanceChangeObservation = self.view.observe(\.effectiveAppearance) { [weak self] _, _  in
			self?.updateAppearanceRelatedChanges()
		}
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.doubleAction = #selector(self.tableViewDoubleClick(_:))
        
        reload()
    }

	private func updateAppearanceRelatedChanges() {

		switch view.effectiveAppearance.bestMatch(from: [.aqua, .darkAqua]) {
		case .aqua?:
			self.view.layer?.backgroundColor = NSColor.white.cgColor
		case .darkAqua?:
			self.view.layer?.backgroundColor = NSColor.textBackgroundColor.cgColor
		default:
			self.view.layer?.backgroundColor = NSColor.textBackgroundColor.cgColor
		}
	}
    
    override func viewDidAppear() {
        if let window = self.view.window {
            self.view.wantsLayer = true
            self.view.layer?.backgroundColor = NSColor.textBackgroundColor.cgColor
            
            window.titlebarAppearsTransparent = true
            window.titleVisibility = .hidden
            window.styleMask.insert(.fullSizeContentView)
        }
    }
    
    @IBAction func reloadData(_ sender: NSButton) {

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
            text = String(describing: item.cmcRank)
            cellIdentifier = "RankId"
        } else if tableColumn == tableView.tableColumns[1] {
            text = item.symbol
            cellIdentifier = "SymbolId"
        }else if tableColumn == tableView.tableColumns[2] {
            text = item.name
            cellIdentifier = "TokenNameId"
        }else if tableColumn == tableView.tableColumns[3] {
            if let marketCap = item.quote.USD.marketCap {
                text = String(format: "%.2f", marketCap)
            }
            cellIdentifier = "MarketCapId"
        } else if tableColumn == tableView.tableColumns[4] {
            if let circulatingSupply = item.circulatingSupply {
                text = String(format: "%.2f", circulatingSupply)
            }
            cellIdentifier = "CirculatingSupplyId"
        } else if tableColumn == tableView.tableColumns[5] {
            if let totalSupply = item.totalSupply {
                text = String(format: "%.2f", totalSupply)
            }
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
        
        let id = item.slug
        if let url = URL(string: "https://coinmarketcap.com/currencies/" + id) {
            NSWorkspace.shared.open(url)
        }
    }
}
