//
//  EditNoteViewController.swift
//  TestFireBaseAndCrashlytics
//
//  Created by air on 04.11.17.
//  Copyright © 2017 VladOS. All rights reserved.
//

import UIKit

class EditNoteViewController: UIViewController {

    //MARK: - Properties
    
    var note:Note?
    
    //MARK: - Outlets
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var contentTextView: UITextView!
    
    //MARK: -View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Edit note"
        
        titleTextField.text = note?.title
        contentTextView.text = note?.content
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        guard let title = titleTextField?.text, let content = contentTextView?.text else {return}
        
        note?.databaseRef?.updateChildValues(["title":title, "content":content])
    }

}
