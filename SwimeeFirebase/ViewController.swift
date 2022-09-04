//
//  ViewController.swift
//  SwimeeFirebase
//
//  Created by 張翔 on 2022/09/04.
//

import UIKit
import FirebaseFirestore
import FirebaseFirestoreCombineSwift

class ViewController: UIViewController, UITableViewDataSource {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var textField: UITextField!
    
    let db = Firestore.firestore()
    var postArray: [Post] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addAction(.init(handler: { _ in
            self.refreshTableView()
        }), for: .valueChanged)
        
        refreshTableView()
    }
    
    func refreshTableView() {
        // ここにコードを書くよ
    }
    
    @IBAction func buttonTapped() {
        // ここにコードを書くよ
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = postArray[indexPath.row].content
        return cell
    }
}

