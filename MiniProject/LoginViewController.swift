//
//  LoginViewViewController.swift
//  MiniProject
//
//  Created by 이용민 on 5/26/25.
//

import UIKit
import FirebaseFirestore

class LoginViewController: UIViewController {

    @IBOutlet weak var studentnum: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var signupSwitch: UISwitch!

    let db = Firestore.firestore()

    @IBAction func loginButtonTapped(_ sender: UIButton) {
        let inputId = studentnum.text ?? ""
        let inputPassword = password.text ?? ""

        guard !inputId.isEmpty, !inputPassword.isEmpty else {
            showAlert("학번과 비밀번호를 모두 입력해주세요.")
            return
        }

        if signupSwitch.isOn {
            let userDocRef = db.collection("users").document(inputId)
            userDocRef.getDocument { snapshot, error in
                if let snapshot = snapshot, snapshot.exists {
                    self.showAlert("이미 존재하는 학번입니다.")
                } else {
                    userDocRef.setData([
                        "studentId": inputId,
                        "password": inputPassword
                    ]) { error in
                        if let error = error {
                            self.showAlert("회원가입 실패: \(error.localizedDescription)")
                        } else {
                            self.showAlert("회원가입 완료! 다시 로그인 해주세요.") {
                                self.studentnum.text = ""
                                self.password.text = ""
                                self.signupSwitch.setOn(false, animated: true)
                            }
                        }
                    }
                }
            }
        } else {

            db.collection("users").document(inputId).getDocument { snapshot, error in
                if let data = snapshot?.data(), data["password"] as? String == inputPassword {
                    self.showAlert("로그인 성공! 환영합니다.") {
                        UserDefaults.standard.set(inputId, forKey: "username")

                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        if let mainVC = storyboard.instantiateViewController(withIdentifier: "TabBarController") as? UITabBarController,
                           let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                           let delegate = windowScene.delegate as? SceneDelegate {
                            delegate.window?.rootViewController = mainVC
                        }
                    }
                } else {
                    self.showAlert("로그인 실패: 학번 또는 비밀번호가 올바르지 않습니다.")
                }
            }
        }
    }

    func showAlert(_ message: String, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default, handler: { _ in
            completion?()
        }))
        present(alert, animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        studentnum.attributedPlaceholder = NSAttributedString(
            string: "학번",
            attributes: [.foregroundColor: UIColor.white, .font: UIFont.systemFont(ofSize: 15)]
        )

        password.attributedPlaceholder = NSAttributedString(
            string: "비밀번호",
            attributes: [.foregroundColor: UIColor.white, .font: UIFont.systemFont(ofSize: 15)]
        )
    }
}
