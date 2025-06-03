//
//  ViewController.swift
//  MiniProject
//
//  Created by 이용민 on 5/15/25.
//

import UIKit
import FirebaseFirestore

class RecordViewController: UIViewController {

    @IBOutlet weak var dateview: UILabel!
    
    @IBOutlet var moodbtn: [UIButton]!
    
    @IBOutlet weak var memoview: UITextField!
    
    @IBOutlet weak var completebtn: UIButton!
    
    var isEditingEntry = false
    var editingIndex: Int?
    var entry: MoodEntry?
    var selectedMood: String?
    
    let moodList = ["😆", "🙂", "😐", "😢", "😡"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if isEditingEntry, let entry = entry {
            dateview.text = entry.date
            memoview.text = entry.memo
            selectedMood = entry.mood

            for (index, button) in moodbtn.enumerated() {
                if moodList[index] == entry.mood {
                    button.backgroundColor = .systemYellow
                }
            }
        } else {
            dateview.text = getToday()
        }
    }
    func getToday() -> String {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy.MM.dd"
            return formatter.string(from: Date())
        }
    
    @IBAction func moodButtonTapped(_ sender: UIButton) {
        for button in moodbtn {
            button.backgroundColor = .clear
        }

        sender.backgroundColor = .systemYellow
        selectedMood = moodList[sender.tag]
    }

 
    @IBAction func completeButtonTapped(_ sender: UIButton) {
        guard let mood = selectedMood,
                  let memo = memoview.text,
                  !memo.isEmpty else {
                showAlert("감정과 메모를 모두 입력해주세요.")
                return
            }
        let dateToUse = isEditingEntry ? (entry?.date ?? getToday()) : getToday()
            let newEntry = MoodEntry(date: dateToUse, mood: mood, memo: memo)

            // ✅ Firestore에 저장
            let db = Firestore.firestore()
            db.collection("moodEntries").addDocument(data: [
                "date": newEntry.date,
                "mood": newEntry.mood,
                "memo": newEntry.memo
            ]) { error in
                if let error = error {
                    self.showAlert("저장 실패: \(error.localizedDescription)")
                } else {
                    self.showAlert("기록이 완료되었습니다!")
                    self.memoview.text = ""
                    self.selectedMood = nil
                    self.moodbtn.forEach { $0.backgroundColor = .clear }
                }
            }
        

        
    }
    
    func showAlert(_ message: String, shouldPop: Bool = false) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default, handler: { _ in
            if shouldPop {
                self.navigationController?.popViewController(animated: true)
            }
        }))
        present(alert, animated: true)
    }


}

