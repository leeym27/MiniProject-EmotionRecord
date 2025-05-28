//
//  LogViewController.swift
//  MiniProject
//
//  Created by 이용민 on 5/15/25.
//

import UIKit

class LogViewController: UIViewController, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var moodEntries: [MoodEntry] = []

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // 감정 기록 불러오기 + 정렬
        moodEntries = UserDefaultsManager.loadEntries()
            .sorted { (a: MoodEntry, b: MoodEntry) -> Bool in
                (a.dateValue ?? Date()) > (b.dateValue ?? Date())
            }
        tableView.dataSource = self
        tableView.delegate = self
        tableView.reloadData()
        
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        }


    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerHeight: CGFloat = 40
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: headerHeight))
        headerView.backgroundColor = UIColor.systemYellow
        
        let dateLabel = UILabel(frame: CGRect(x: 40, y: 0, width: 100, height: headerHeight))
        dateLabel.text = "날짜"

        let moodLabel = UILabel(frame: CGRect(x: 105, y: 0, width: 80, height: headerHeight))
        moodLabel.text = "기분"

        let memoLabel = UILabel(frame: CGRect(x: 210, y: 0, width: 100, height: headerHeight))
        memoLabel.text = "메모"

        [dateLabel, moodLabel, memoLabel].forEach {
            $0.font = .boldSystemFont(ofSize: 14)
            $0.textColor = .darkGray
            headerView.addSubview($0)
        }

        return headerView
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
}
extension LogViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return moodEntries.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let entry = moodEntries[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "LogCell", for: indexPath)
        cell.textLabel?.font = .systemFont(ofSize: 14)
        cell.textLabel?.textAlignment = .left
        cell.textLabel?.text = "\(entry.date)    \(entry.mood)         \(entry.memo)"
        return cell
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle,
                   forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            moodEntries.remove(at: indexPath.row)
            UserDefaultsManager.saveEntries(moodEntries)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let recordVC = storyboard.instantiateViewController(withIdentifier: "RecordViewController") as? RecordViewController {
            recordVC.isEditingEntry = true
            recordVC.editingIndex = indexPath.row
            recordVC.entry = moodEntries[indexPath.row]
            navigationController?.pushViewController(recordVC, animated: true)
        }
    }
}
extension MoodEntry {
    var dateValue: Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd"
        return formatter.date(from: self.date)
    }
}

