import Foundation

//** Протокол наследуется
// view-классом, которому presenter посылает
// сигнал обновить видимые ячейки,
// по заврешении асинхронных заданий в самом presenter
protocol ViewProtocolDelegate : class {
    func reloadCells()
    func reloadCell(indexPath: IndexPath)
    func className()->String
}
