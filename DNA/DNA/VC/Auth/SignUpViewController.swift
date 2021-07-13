//
//  SignUpViewController.swift
//  DNA
//
//  Created by 장서영 on 2021/06/09.
//

import UIKit
import Alamofire

class SignUpViewController: UIViewController {

    @IBOutlet weak var circle: UIView!
    @IBOutlet weak var nameTxt: UITextField!
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var confirmEmailButton: UIButton!
    @IBOutlet weak var warningLabel: UILabel!
    @IBOutlet weak var pwTxt: UITextField!{
        didSet {
            pwTxt.isSecureTextEntry = true
        }
    }
    @IBOutlet weak var confirmPwTxt: UITextField!{
        didSet {
            confirmPwTxt.isSecureTextEntry = true
        }
    }
    @IBOutlet weak var signUpButton: UIButton!
    
    let id = String()
    let httpclient = HTTPClient()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setNavigationBar()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func confirmEmailButton(_ sender: UIButton){
        print("tapped")
        httpclient.get(url: AuthAPI.email(id).path(), params: nil, header: Header.tokenIsEmpty.header()).responseJSON(completionHandler: {
            response in
            switch response.response?.statusCode {
            case 200 :
                print("SUCCESS")
                self.confirmEmailButton.setTitle("확인완료", for: .normal)
            case 400: print("BAD REQUEST")
                self.confirmEmailButton.setTitle("확인불가", for: .normal)
            default : print(response.error ?? 0)
            }
        })
    }
    
    @IBAction func signUpButton(_ sender: UIButton){
        guard let Name = nameTxt.text else {return}
        guard let Email = emailTxt.text else {return}
        guard let Password = pwTxt.text else {return}
        signUp(name: Name, email: Email, password: Password)
    }
    
    func signUp(name: String, email: String, password: String){
        httpclient.post(url: AuthAPI.signUp.path(), params: ["name":name, "email":email, "password":password], header: Header.tokenIsEmpty.header()).responseJSON(completionHandler: {
            response in
            switch response.response?.statusCode {
            case 201:
                print("SUCCESS")
                self.navigationController?.popViewController(animated: true)
            case 400:
                self.warningLabel.isHidden = false
                print("BAD REQUEST")
            case 401:
                self.warningLabel.isHidden = false
                print("UNAUTHORIZED")
            case 403:
                self.warningLabel.isHidden = false
                print("FORBIDDEN")
            case 404:
                self.warningLabel.isHidden = false
                print("NOT FOUND")
            case 409:
                self.warningLabel.isHidden = false
                print("CONFLICT")
            default :
                print(response.response?.statusCode ?? 0)
            }
        })
    }
}