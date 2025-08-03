// MARK: - 4. ExpenseAnalyzer.swift (새 파일 생성)
import Foundation

class ExpenseAnalyzer {
    static let shared = ExpenseAnalyzer()
    
    private let categories = [
        "식비": ["스타벅스", "카페", "맥도날드", "버거킹", "치킨", "피자", "음식", "식당", "커피", "점심", "저녁", "아침"],
        "교통비": ["버스", "지하철", "택시", "기차", "교통", "주유", "기름"],
        "쇼핑": ["쇼핑", "옷", "신발", "가방", "화장품", "마트", "편의점"],
        "의료비": ["병원", "약국", "의료", "치료"],
        "문화생활": ["영화", "콘서트", "공연", "게임", "책"],
        "기타": []
    ]
    
    func analyzeExpense(_ text: String) -> (date: Date, amount: Double, item: String, category: String) {
        let amount = extractAmount(from: text)
        let date = extractDate(from: text)
        let item = extractItem(from: text)
        let category = classifyCategory(from: text)
        
        return (date: date, amount: amount, item: item, category: category)
    }
    
    private func extractAmount(from text: String) -> Double {
        let pattern = #"(\d+,?\d*)\s*원"#
        let regex = try? NSRegularExpression(pattern: pattern)
        let range = NSRange(text.startIndex..., in: text)
        
        if let match = regex?.firstMatch(in: text, range: range) {
            let matchedString = String(text[Range(match.range(at: 1), in: text)!])
            let cleanedString = matchedString.replacingOccurrences(of: ",", with: "")
            return Double(cleanedString) ?? 0
        }
        
        // 숫자만 있는 경우도 체크
        let numberPattern = #"(\d+,?\d*)"#
        let numberRegex = try? NSRegularExpression(pattern: numberPattern)
        if let match = numberRegex?.firstMatch(in: text, range: range) {
            let matchedString = String(text[Range(match.range(at: 1), in: text)!])
            let cleanedString = matchedString.replacingOccurrences(of: ",", with: "")
            if let amount = Double(cleanedString), amount > 100 {
                return amount
            }
        }
        
        return 0
    }
    
    private func extractDate(from text: String) -> Date {
        let calendar = Calendar.current
        let today = Date()
        
        // "6월 24일" 패턴
        let monthDayPattern = #"(\d{1,2})월\s*(\d{1,2})일"#
        if let regex = try? NSRegularExpression(pattern: monthDayPattern),
           let match = regex.firstMatch(in: text, range: NSRange(text.startIndex..., in: text)) {
            let month = Int(String(text[Range(match.range(at: 1), in: text)!])) ?? calendar.component(.month, from: today)
            let day = Int(String(text[Range(match.range(at: 2), in: text)!])) ?? calendar.component(.day, from: today)
            
            var components = calendar.dateComponents([.year], from: today)
            components.month = month
            components.day = day
            
            if let date = calendar.date(from: components) {
                return date
            }
        }
        
        // "어제", "오늘" 등의 상대적 날짜
        if text.contains("어제") {
            return calendar.date(byAdding: .day, value: -1, to: today) ?? today
        } else if text.contains("그저께") || text.contains("이틀전") {
            return calendar.date(byAdding: .day, value: -2, to: today) ?? today
        }
        
        return today
    }
    
    private func extractItem(from text: String) -> String {
        // 상호명이나 상품명 추출
        let commonPlaces = ["스타벅스", "맥도날드", "버거킹", "롯데리아", "서브웨이", "KFC", "피자헛", "도미노피자"]
        
        for place in commonPlaces {
            if text.contains(place) {
                return place
            }
        }
        
        // "에서" 앞의 단어를 찾기
        let pattern = #"(\w+)에서"#
        if let regex = try? NSRegularExpression(pattern: pattern),
           let match = regex.firstMatch(in: text, range: NSRange(text.startIndex..., in: text)) {
            return String(text[Range(match.range(at: 1), in: text)!])
        }
        
        // 첫 번째 명사 추출
        let words = text.components(separatedBy: " ")
        for word in words {
            if word.count > 1 && !word.contains("원") && !word.contains("월") && !word.contains("일") {
                return word
            }
        }
        
        return "기타 지출"
    }
    
    private func classifyCategory(from text: String) -> String {
        for (category, keywords) in categories {
            for keyword in keywords {
                if text.contains(keyword) {
                    return category
                }
            }
        }
        return "기타"
    }
    
    private init() {}
}
