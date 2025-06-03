import UIKit
import FirebaseFirestore

class CalendarViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var positiveLabel: UILabel!
    @IBOutlet weak var negativeLabel: UILabel!
    
    @IBOutlet weak var positiveProgressView: UIProgressView!
    
    @IBOutlet weak var negativeProgressView: UIProgressView!
    
    @IBOutlet weak var verygood: UILabel!
    @IBOutlet weak var good: UILabel!
    @IBOutlet weak var soso: UILabel!
    @IBOutlet weak var bad: UILabel!
    @IBOutlet weak var verybad: UILabel!
    var currentDate = Date()
    var daysInMonth: [String] = []
    var moodEntries: [MoodEntry] = []
    
    let calendar = Calendar.current
    let positiveMoods: Set<String> = ["😆", "🙂"]
    let negativeMoods: Set<String> = ["😢", "😡"]
    let moodList = ["😆", "🙂", "😐", "😢", "😡"]



    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        setMonthView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        fetchMoodEntriesFromFirestore()
    }
    
    func fetchMoodEntriesFromFirestore() {
        let db = Firestore.firestore()
        db.collection("moodEntries").getDocuments { snapshot, error in
            if let error = error {
                print("❌ 캘린더 불러오기 실패: \(error.localizedDescription)")
                return
            }

            guard let snapshot = snapshot else { return }

            self.moodEntries = snapshot.documents.compactMap { doc in
                let data = doc.data()
                return MoodEntry(
                    date: data["date"] as? String ?? "",
                    mood: data["mood"] as? String ?? "",
                    memo: data["memo"] as? String ?? ""
                )
            }

            self.setMonthView()
            self.updateEmotionStatistics()
        }
    }



    @IBAction func prevMonthTapped(_ sender: UIButton) {
        currentDate = Calendar.current.date(byAdding: .month, value: -1, to: currentDate)!
            setMonthView()
            updateEmotionStatistics()
    }
    
    @IBAction func nextMonthTapped(_ sender: UIButton) {
        currentDate = Calendar.current.date(byAdding: .month, value: 1, to: currentDate)!
            setMonthView()
            updateEmotionStatistics()
    }
    
    func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
    }

    func setMonthView() {
        daysInMonth.removeAll()
        
        let firstDayOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: currentDate))!
        let totalDays = calendar.range(of: .day, in: .month, for: currentDate)!.count
        let weekday = calendar.component(.weekday, from: firstDayOfMonth) - 1
        
        for _ in 0..<weekday {
            daysInMonth.append("")
        }

        for day in 1...totalDays {
            daysInMonth.append("\(day)")
        }
        
        monthLabel.text = getFormattedMonth(date: currentDate)
        collectionView.reloadData()
    }

    func getFormattedMonth(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "yyyy년 M월"
        return formatter.string(from: date)
    }


    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return daysInMonth.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CalendarCell", for: indexPath) as! CalendarCell

        let dayString = daysInMonth[indexPath.row]
        cell.dayLabel.text = dayString

        if dayString.isEmpty {
            cell.emojiLabel.text = ""  // 이모지도 없애기
        } else if let dayInt = Int(dayString) {
            var components = Calendar.current.dateComponents([.year, .month], from: currentDate)
            components.day = dayInt
            if let fullDate = Calendar.current.date(from: components),
               let emoji = emojiForDate(fullDate) {
                cell.emojiLabel.text = emoji
            } else {
                cell.emojiLabel.text = ""
            }
        }
        return cell
    }


    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.size.width / 7
        let height = collectionView.frame.size.height / 7
        return CGSize(width: width, height: height)
    }
    
    func emojiForDate(_ date: Date) -> String? {
        for entry in moodEntries {
            if let entryDate = entry.dateValue {
                if Calendar.current.isDate(entryDate, inSameDayAs: date) {
                    return entry.mood
                }
            }
        }
        return nil
    }

    func updateEmotionStatistics() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd"

        let calendar = Calendar.current
        let currentComponents = calendar.dateComponents([.year, .month], from: currentDate)

        let thisMonthEntries = moodEntries.filter {
            guard let date = formatter.date(from: $0.date) else { return false }
            let entryComponents = calendar.dateComponents([.year, .month], from: date)
            return entryComponents.year == currentComponents.year && entryComponents.month == currentComponents.month
        }

        let positiveCount = thisMonthEntries.filter { positiveMoods.contains($0.mood) }.count
        let negativeCount = thisMonthEntries.filter { negativeMoods.contains($0.mood) }.count
        let totalCount = positiveCount + negativeCount

        let positiveRatio = totalCount > 0 ? Float(positiveCount) / Float(totalCount) : 0
        let negativeRatio = totalCount > 0 ? Float(negativeCount) / Float(totalCount) : 0

        positiveProgressView.progress = positiveRatio
        negativeProgressView.progress = negativeRatio

        positiveLabel.text = "긍정 \(Int(positiveRatio * 100))%"
        negativeLabel.text = "부정 \(Int(negativeRatio * 100))%"

        var moodCountDict: [String: Int] = [:]
        for mood in moodList {
            moodCountDict[mood] = 0
        }

        for entry in thisMonthEntries {
            moodCountDict[entry.mood, default: 0] += 1
        }

        let emojiLabels = [verygood, good, soso, verybad, bad]
        for (index, mood) in moodList.enumerated() {
            emojiLabels[index]?.text = "\(mood) : \(moodCountDict[mood] ?? 0)개"
        }
    }


}
