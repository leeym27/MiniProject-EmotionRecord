//
//  ViewController.swift
//  MiniProject
//
//  Created by 이용민 on 5/15/25.
//

import UIKit

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
        

        var entries = UserDefaultsManager.loadEntries()
        let dateToUse = isEditingEntry ? (entry?.date ?? getToday()) : getToday()
        let newEntry = MoodEntry(date: dateToUse, mood: mood, memo: memo)

        if !isEditingEntry {
                let alreadyExists = entries.contains { $0.date == dateToUse }
                if alreadyExists {
                    showAlert("오늘은 이미 감정을 기록했어요!")
                    return
                }
            }
        
        if isEditingEntry, let index = editingIndex {
            entries[index] = newEntry
            UserDefaultsManager.saveEntries(entries)
            showAlert("수정이 완료되었습니다!", shouldPop: true)
            return
        } else {
            entries.append(newEntry)
            UserDefaultsManager.saveEntries(entries)
            showAlert("기록이 완료되었습니다!")
        }

        UserDefaultsManager.saveEntries(entries)

        memoview.text = ""
        selectedMood = nil
        for button in moodbtn {
            button.backgroundColor = .clear
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

