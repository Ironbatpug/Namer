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
    
    var disposeBag = DisposeBag()
    var namesArray: Variable<[String]> = Variable([])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindtextfield()
        bindSubmitButton()
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
                }
            })
            .disposed(by: disposeBag)
    }
    
}

