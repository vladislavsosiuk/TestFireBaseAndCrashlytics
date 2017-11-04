//
//  ViewController.swift
//  TestFireBaseAndCrashlytics
//
//  Created by air on 03.11.17.
//  Copyright © 2017 VladOS. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn
import FirebaseDatabase
import Crashlytics



class MainViewController: UIViewController {
    
    //MARK: - Keys
    
    let cellIdentifier = "DefaultCellIdentifier"
    let EditNoteSegueIdentifier = "EditNoteSegueIdentifier"
    
    //MARK: - Properties
    
    var dataBaseRef = Database.database().reference(withPath: "notes")
    var notes:[Note] = []
    var hasNotes:Bool{
        return notes.count>0
    }

    //MARK: - Outlets
    
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        
        dataBaseRef.observe(.value, with: {snapshot in
            var newItems = [Note]()
            for child in snapshot.children{
                let note = Note(snapshot: child as! DataSnapshot)
                newItems.append(note)
            }
            
            self.notes = newItems
            self.tableView.reloadData()
        })
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
    }
    
    //MARK: -
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier{
            switch identifier{
            case EditNoteSegueIdentifier:
                guard let destination = segue.destination as? EditNoteViewController else{ fatalError("Unexpected Destination View Controller")}
                
                 guard let indexPath = tableView.indexPathForSelectedRow else {return}
                
                destination.note = notes[indexPath.row]
            default:
                break
            }
        }
    }
    
    //MARK: - IBActions

    @IBAction func signOutClicked(_ sender: UIButton) {
        
        let firebaseAuth = Auth.auth()
        do {
            dataBaseRef.removeAllObservers()
            try firebaseAuth.signOut()
            GIDSignIn.sharedInstance().signOut()
            dismiss(animated: true, completion: nil)
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        
    }
    @IBAction func addNote(_ sender: UIBarButtonItem) {
        
        let alert = UIAlertController(title: "AddNote", message: nil, preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Save", style: .default, handler: {(action) in
            
            guard let title = alert.textFields?[0].text, let content = alert.textFields?[1].text else {return}
            
            let note = Note(title: title, content: content)
            
            let noteRef = self.dataBaseRef.child(title.lowercased())
            noteRef.setValue(note.toAnyObject())
            
        })
        
        alert.addTextField{textTitle in
            textTitle.placeholder = "Input note title"
        }
        alert.addTextField{textContent in
            textContent.placeholder = "Input note content"
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(saveAction) 
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func crashClicked(_ sender: UIBarButtonItem) {
        Crashlytics.sharedInstance().crash()
    }
    
    //MARK: - Helpers
    func setupView(){
        
        tableView.tableFooterView = UIView()
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 44.0
        
        title = "Notes"
    }
}

extension MainViewController:UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if hasNotes{
            return 1
        }
        return 0
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if hasNotes{
            return notes.count
        }
        return 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        
        cell.textLabel?.text = notes[indexPath.row].title
        cell.detailTextLabel?.text = notes[indexPath.row].content
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            
            let note = notes[indexPath.row]
            note.databaseRef?.removeValue()
        }
    }
}
