import Foundation

//** Протокол наследуется
// view-классом, которому presenter посылает
// сигнал обновить видимые ячейки,
// по заврешении асинхронных заданий в самом presenter
protocol ViewProtocolDelegate : class {
    func reloadCells()
    func optimReloadCell(indexPath: IndexPath)
    func optimReloadCells(_ deletions: [IndexPath], _ insertions: [IndexPath], _ updates: [IndexPath])
    func insertNewSections(sections: IndexSet)
    func className()->String
    func refreshDataSource()
}
