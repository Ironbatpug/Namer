//
//  ViewController.swift
//  Namer
//
//  Created by Molnár Csaba on 2019. 11. 03..
//  Copyright © 2019. Molnár Csaba. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class ViewController: UIViewController {
    
    @IBOutlet weak var helloLbl: UILabel!
    @IBOutlet weak var nameEntryTextField: UITextField!
    @IBOutlet weak var submitBtn: UIButton!
    @IBOutlet weak var namesLbl: UILabel!
    @IBOutlet weak var addNameBtn: UIButton!
    
    var disposeBag = DisposeBag()
    var namesArray: Variable<[String]> = Variable([])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindtextfield()
        bindSubmitButton()
        bindAddNameButton()
        
        namesArray.asObservable()
        .subscribe(onNext: { names in
            self.namesLbl.text = names.joined(separator: ", ")
        })
        .disposed(by: disposeBag)
    }
    
    func bindtextfield() {
        nameEntryTextField.rx.text
            .map {
                if $0 == "" {
                    return "TYPE YOUR NAME BELOW."
                } else {
                    return "Hello, \($0!)."
                }
        }
        .bind(to: helloLbl.rx.text)
        .disposed(by: disposeBag)
    }
    
    func bindSubmitButton() {
        submitBtn.rx.tap
            .subscribe(onNext: {
                if self.nameEntryTextField.text != "" {
                    self.namesArray.value.append(self.nameEntryTextField.text!)
                    self.namesLbl.rx.text.onNext(self.namesArray.value.joined(separator: ", "))
                    self.nameEntryTextField.rx.text.onNext("")
                    self.helloLbl.rx.text.onNext("TYPE YOUR NAME BELOW.")
                }
            })
            .disposed(by: disposeBag)
    }
    
    func bindAddNameButton() {
    addNameBtn.rx.tap
        .throttle(0.5, scheduler: MainScheduler.instance).subscribe(onNext: {
            guard let addNameVC = self.storyboard?.instantiateViewController(withIdentifier: "AddNameVC") as? AddNameVC else { fatalError("Could not create AddNameVC") }
            addNameVC.nameSubject
                .subscribe(onNext: { name in
                    self.namesArray.value.append(name)
                    addNameVC.dismiss(animated: true, completion: nil)
                }).disposed(by: self.disposeBag)
            addNameVC.modalPresentationStyle = .overFullScreen
            self.present(addNameVC, animated: true, completion: nil)
        }).disposed(by: disposeBag)
    }
    
}

