// MARK: - 2. PersistenceController.swift (새 파일 생성)
import CoreData

class PersistenceController {
    static let shared = PersistenceController()
    
    lazy var container: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "ExpenseModel")
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Core Data error: \(error)")
            }
        }
        return container
    }()
    
    func save() {
        let context = container.viewContext
        if context.hasChanges {
            try? context.save()
        }
    }
    
    private init() {}
}
