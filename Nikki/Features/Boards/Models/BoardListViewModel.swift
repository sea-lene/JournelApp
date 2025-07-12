//
//  BoardListViewModel.swift
//  Nikki
//
//  Created by Suhanee on 14/04/25.
//
import Foundation

class BoardListViewModel {
    
    private(set) var boards: [Board] = []
    
    func addBoard(title: String) {
        let newBoard = Board(id: UUID(), title: title, createdAt: Date())
        boards.append(newBoard)
    }
    
    func getBoard(at index: Int) -> Board {
        return boards[index]
    }
    
    func numberOfBoards() -> Int {
        return boards.count
    }
}
