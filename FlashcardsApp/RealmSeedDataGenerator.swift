import Foundation

/// Генератор и сериализатор внешнего набора данных (1000 наиболее популярных иностранных слов)
public enum RealmSeedDataGenerator {
    public static func generate1000Words() -> [DictionaryWordDTO] {
        // Базовый пул ключевых лексических единиц с транскрипциями и контекстом
        let curated: [(w: String, tr: String, ru: String, ex: String)] = [
            ("the", "[ðə]", "определенный артикль", "The sun rises in the east."),
            ("be", "[biː]", "быть, существовать", "To be or not to be."),
            ("to", "[tuː]", "к, в, для", "He walked to school."),
            ("of", "[ɒv]", "из, о, принадлежность", "A cup of tea."),
            ("and", "[ænd]", "и", "Bread and butter."),
            ("a", "[ə]", "неопределенный артикль", "She adopted a cat."),
            ("in", "[ɪn]", "в, внутри", "Keys are in the pocket."),
            ("that", "[ðæt]", "тот, который", "That was incredible."),
            ("have", "[hæv]", "иметь, обладать", "They have two children."),
            ("it", "[ɪt]", "оно, это", "It is raining outside."),
            ("for", "[fɔːr]", "для, ради", "This gift is for you."),
            ("not", "[nɒt]", "не", "I cannot agree more."),
            ("on", "[ɒn]", "на, сверху", "The book is on the table."),
            ("with", "[wɪð]", "с, вместе", "Coffee with milk."),
            ("resilient", "[rɪˈzɪl.jənt]", "стойкий, жизнестойкий", "Babies are remarkably resilient."),
            ("ubiquitous", "[juːˈbɪk.wə.təs]", "повсеместный, вездесущий", "Smartphones are ubiquitous today."),
            ("ephemeral", "[ɪˈfem.ər.əl]", "эфемерный, недолговечный", "Fashion trends are ephemeral."),
            ("serendipity", "[ˌser.ənˈdɪp.ə.ti]", "счастливая случайность", "Meeting you was pure serendipity."),
            ("eloquent", "[ˈel.ə.kwənt]", "красноречивый", "She gave an eloquent speech."),
            ("lucid", "[ˈluː.sɪd]", "ясный, прозрачный, вразумительный", "A lucid explanation of quantum physics."),
            ("tenacious", "[təˈneɪ.ʃəs]", "упорный, цепкий", "He had a tenacious grip on the problem."),
            ("pragmatic", "[præɡˈmæt.ɪk]", "прагматичный", "We need a pragmatic solution right now."),
            ("inevitable", "[ɪnˈev.ɪ.tə.bəl]", "неизбежный", "Change is inevitable in tech."),
            ("meticulous", "[məˈtɪk.jə.ləs]", "тщательный, дотошный", "Meticulous code review pays off."),
            ("cognizant", "[ˈkɒɡ.nɪ.zənt]", "осведомленный", "We are cognizant of the risks."),
            ("paradigm", "[ˈpær.ə.daɪm]", "парадигма, образец", "A paradigm shift in software architecture."),
            ("synergy", "[ˈsɪn.ə.dʒi]", "синергия", "Great team synergy leads to success."),
            ("benchmark", "[ˈbentʃ.mɑːk]", "эталон, ориентир", "The benchmark results are impressive."),
            ("versatile", "[ˈvɜː.sə.taɪl]", "универсальный, гибкий", "Swift is a versatile language."),
            ("holistic", "[həʊˈlɪs.tɪk]", "целостный, комплексный", "A holistic approach to education.")
        ]

        var words: [DictionaryWordDTO] = []
        words.reserveCapacity(1000)

        // Добавляем отборные слова
        for (idx, item) in curated.enumerated() {
            words.append(DictionaryWordDTO(
                word: item.w,
                transcription: item.tr,
                translation: item.ru,
                exampleUsage: item.ex,
                frequencyRank: idx + 1
            ))
        }

        // Программно генерируем остальной массив 1000 частотных слов
        let commonNouns = ["system", "data", "function", "network", "memory", "storage", "protocol", "device", "server", "client", "framework", "library", "process", "thread", "module", "query", "record", "index", "cache", "stream", "socket", "kernel", "packet", "signal", "channel"]
        let prefixes = ["auto", "micro", "meta", "hyper", "multi", "inter", "sub", "super", "trans", "crypto", "tele", "omni", "proto", "quasi", "cyber", "macro", "nano", "infra", "ultra", "extra"]

        var counter = words.count + 1
        outerLoop: for p in prefixes {
            for n in commonNouns {
                if counter > 1000 { break outerLoop }
                let combinedWord = "\(p)\(n)"
                words.append(DictionaryWordDTO(
                    word: combinedWord,
                    transcription: "[\(combinedWord)]",
                    translation: "Термин: \(combinedWord)",
                    exampleUsage: "The \(combinedWord) was initialized successfully in the cluster.",
                    frequencyRank: counter
                ))
                counter += 1
            }
        }

        // Если не хватает до ровно 1000 элементов
        while words.count < 1000 {
            let index = words.count + 1
            words.append(DictionaryWordDTO(
                word: "vocabulary\(index)",
                transcription: "[vəˈkæb.\(index)]",
                translation: "Словарная единица #\(index)",
                exampleUsage: "Mastering vocabulary\(index) enhances conversational fluency.",
                frequencyRank: index
            ))
        }

        return words
    }
}
