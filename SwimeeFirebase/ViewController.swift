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
            self.tableView.refreshControl?.endRefreshing()
        }), for: .valueChanged)
        
        refreshTableView()
    }
    
    func refreshTableView() {
        Task {
            do {
                let querySnapshot = try await db.collection("Post").getDocuments()
            
                var newPostArray: [Post] = []
                for document in querySnapshot.documents {
                    let post = try document.data(as: Post.self)
                    newPostArray.append(post)
                }
                newPostArray.sort(using: KeyPathComparator(\.createdAt, order: .reverse))
                postArray = newPostArray
                
                // もっと簡単に書けるよ (map, sorted)
                // postArray = try querySnapshot.documents
                //     .map { try $0.data(as: Post.self) }
                //     .sorted(using: KeyPathComparator(\.createdAt, order: .reverse))
                
                tableView.reloadData()
            } catch {
                print("エラーが発生しました: \(error)")
            }
        }
    }
    
    @IBAction func buttonTapped() {
        Task {
            do {
                let newPost = Post(content: textField.text!, createdAt: .now)
                let data = try Firestore.Encoder().encode(newPost)
                let document = try await db.collection("Post").addDocument(data: data)
                print("データを追加しました: \(document.documentID)")
                textField.text?.removeAll()
                refreshTableView()
            } catch {
                print("エラーが発生しました: \(error)")
            }
        }
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

