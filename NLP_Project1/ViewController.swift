//
//  ViewController.swift
//  NLP_Project1
//
//  Created by Emmanuel  Ogbewe on 1/19/19.
//  Copyright © 2019 Emmanuel Ogbewe. All rights reserved.
//

import UIKit
import NaturalLanguage

class ViewController: UIViewController {
    
    private var textView = UITextView()
    private let check = UIButton()
    private var directionsLabel = UILabel()
    private var expectedLabel = UILabel()
    private var checkBackView = UIView()
    
    private var checkBottomConstraint : NSLayoutConstraint!
    private var topLabelTopConstraint : NSLayoutConstraint!
    
    //Define expected sentence structure
    private var expectedStructure : [String] = ["Adjective","Pronoun","Verb","Pronoun"]
    private var realStructure : [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        layout()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        keyboardNotifications()

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        super.touchesBegan(touches, with: event)
    }
    //Layout view
    private func layout() {
        
        view.backgroundColor = UIColor.white
        view.addSubview(directionsLabel)
        view.addSubview(expectedLabel)
        view.addSubview(check)
        view.addSubview(textView)
        
        directionsLabel.textColor = UIColor.black
        directionsLabel.text = "Write a sentence with the follow form"
        directionsLabel.numberOfLines = 2
        
        var lblText = String()
        var count = 0
        expectedStructure.forEach { (str) in
            count = count + 1
            lblText.append( count != expectedStructure.count ? str + ", " : str)
        }
        
        expectedLabel.text = lblText
        
        directionsLabel.font = UIFont(name: "Avenir-Black", size: 25)
        directionsLabel.numberOfLines = 0
        directionsLabel.translatesAutoresizingMaskIntoConstraints = false
        
        expectedLabel.font = UIFont(name: "Avenir-Roman", size: 17)
        expectedLabel.translatesAutoresizingMaskIntoConstraints = false
        
        textView.delegate = self
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.layer.cornerRadius = 10
        textView.layer.borderWidth = 2
        textView.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.3).cgColor
        textView.textColor = UIColor.darkGray
        textView.contentInset.left = 15
        textView.contentInset.top = 10
        textView.font = UIFont(name: "Avenir-Medium", size: 19)
        textView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.1)
        
        check.translatesAutoresizingMaskIntoConstraints = false
        
        resetCheckView()
        
        topLabelTopConstraint =  directionsLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20)
        checkBottomConstraint = check.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        
       [
        topLabelTopConstraint,
        directionsLabel.heightAnchor.constraint(equalToConstant: 70),
        directionsLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
        directionsLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
        
        expectedLabel.topAnchor.constraint(equalTo: directionsLabel.bottomAnchor, constant: 5),
        expectedLabel.heightAnchor.constraint(equalToConstant: 50),
        expectedLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
        expectedLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
        
        textView.topAnchor.constraint(equalTo: expectedLabel.bottomAnchor, constant: 15),
        textView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
        textView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
        
        checkBottomConstraint,
        check.topAnchor.constraint(equalTo: textView.bottomAnchor, constant: 20),
        check.heightAnchor.constraint(equalToConstant: 46),
        check.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
        check.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20)
        
        ].forEach{$0.isActive = true}
        
    }
    //Keyboard
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let keyboardHeight = keyboardSize.height
            
            UIView.animate(withDuration: 0.9, delay: 0.0, options: .curveEaseIn, animations: {
                self.directionsLabel.alpha = 0
                self.topLabelTopConstraint.constant = -(self.directionsLabel.frame.size.height)
                self.checkBottomConstraint.constant = -( keyboardHeight)
            }, completion: nil)
            
        }
    }
    @objc func keyboardWillHide(notification: NSNotification) {
        
        UIView.animate(withDuration: 0.9, delay: 0.0, options: .curveEaseOut, animations: {
            self.directionsLabel.alpha = 1
            self.topLabelTopConstraint.constant = 20
            self.checkBottomConstraint.constant = -20
        }, completion: nil)
    }
    func keyboardNotifications(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    //Animate check view
    private func resetCheckView(){
        checkBackView.backgroundColor = UIColor.white
        check.isEnabled = false
        check.setTitle("CHECK", for: .normal)
        check.setTitleColor(UIColor.darkGray.withAlphaComponent(0.4), for: .normal)
        check.titleLabel?.font = UIFont(name: "Avenir-Black", size: 17)
        check.layer.cornerRadius = 15
        check.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.4).cgColor
        check.backgroundColor = UIColor.lightGray.withAlphaComponent(0.3)
        
        check.addTarget(self, action: #selector(ViewController.pressCheck), for: .touchUpInside)
    }
    
    private func animateView(answer : String){
       
    
        print(realStructure)
        if check.titleLabel?.text == "CHECK" {
            if(answer == "correct"){
                check.setTitle("CORRECT", for: .normal)
            }else{
                check.setTitle("PLEASE TRY AGAIN", for: .normal)
                check.backgroundColor = UIColor.red.withAlphaComponent(0.6)
            }
        }else{
            textView.text = ""
            realStructure.removeAll()
            resetCheckView()
        }
    }
   
    //Function will conduct NLP on the users text then append all NLTag's to the realStructure array
    private func startNlp(){
        let tagger = NLTagger(tagSchemes: [.lexicalClass])
        tagger.string = textView.text
        realStructure.removeAll()
        let options : NLTagger.Options = [.omitPunctuation, .omitWhitespace]
        tagger.enumerateTags(in: textView.text.startIndex..<textView.text.endIndex, unit: .word, scheme: .lexicalClass, options: options) { (tag, range) -> Bool in
            if let tag = tag {
                realStructure.append(tag.rawValue)
            }
            
            return true
        }
    }
    //Compare structures and about true or false
    private func compareStructures() -> Bool {
        if expectedStructure == realStructure {
            return true
        }
        return false
    }
    
    @objc private func pressCheck () {
        startNlp()
        if compareStructures() == true {
            animateView(answer: "correct")
        }else{
            animateView(answer: "incorrect")
        }
    }
}

extension ViewController: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    func textViewDidChange(_ textView: UITextView) {
        check.backgroundColor = UIColor.green
        check.setTitleColor(UIColor.white, for: .normal)
        check.isEnabled = true
        if(textView.text.isEmpty){
            resetCheckView()
        }
    }
   
}

