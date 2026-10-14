import Foundation
import Combine
import UserNotifications
import RealmSwift
import SwiftData

class WordBroker {
    static let shared = WordBroker()
    
    func processRecognizedWord(_ text: String, modelContext: ModelContext) {
        let cleanWord = text.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        do {
            let realm = try Realm()
            if let baseWord = realm.object(ofType: BaseWord.self, forPrimaryKey: cleanWord) {
                let newWord = UserWord(word: baseWord.word, translation: baseWord.translation, transcription: baseWord.transcription, example: baseWord.example)
                modelContext.insert(newWord)
            }
        } catch {}
    }
}

class SM2Algorithm {
    static func reviewWord(word: UserWord, quality: Int) {
        if quality >= 3 {
            word.interval = word.repetitions == 0 ? 1 : (word.repetitions == 1 ? 6 : Int(round(Double(word.interval) * word.easeFactor)))
            word.repetitions += 1
        } else {
            word.repetitions = 0
            word.interval = 1
        }
        word.easeFactor = max(1.3, word.easeFactor + (0.1 - (5.0 - Double(quality)) * (0.08 + (5.0 - Double(quality)) * 0.02)))
        word.nextReviewDate = Calendar.current.date(byAdding: .day, value: word.interval, to: Date()) ?? Date()
        scheduleNotification(for: word)
    }
    
    static func scheduleNotification(for word: UserWord) {
        let content = UNMutableNotificationContent()
        content.title = "Пора повторить!"
        content.body = "Вспомните слово: \(word.word)"
        
        let components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: word.nextReviewDate)
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
        UNUserNotificationCenter.current().add(UNNotificationRequest(identifier: word.id.uuidString, content: content, trigger: trigger))
    }
}
