//
//  LoginViewViewController.swift
//  MiniProject
//
//  Created by 이용민 on 5/26/25.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var studentnum: UITextField!
  
    @IBOutlet weak var password: UITextField!
    
    @IBAction func loginButtonTapped(_ sender: UIButton) {
        let correctId = "2171018"
        let correctPassword = "pass1234"
        
        let inputId = studentnum.text ?? ""
        let inputPassword = password.text ?? ""
        
        if inputId == correctId && inputPassword == correctPassword {
            let alert = UIAlertController(title: "로그인 성공", message: "환영합니다!", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "확인", style: .default, handler: { _ in
                    UserDefaults.standard.set(inputId, forKey: "username")

                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    if let mainVC = storyboard.instantiateViewController(withIdentifier: "TabBarController") as? UITabBarController {
                        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                           let delegate = windowScene.delegate as? SceneDelegate {
                            delegate.window?.rootViewController = mainVC
                        }
                    }
                }))
                self.present(alert, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "로그인 실패", message: "학번 또는 비밀번호가 틀렸습니다.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        studentnum.attributedPlaceholder = NSAttributedString(
            string: "학번",
            attributes: [
                .foregroundColor: UIColor.white,
                .font: UIFont.systemFont(ofSize: 15)
            ]
        )

        password.attributedPlaceholder = NSAttributedString(
            string: "비밀번호",
            attributes: [
                .foregroundColor: UIColor.white,
                .font: UIFont.systemFont(ofSize: 15)
            ]
        )
    }

}
