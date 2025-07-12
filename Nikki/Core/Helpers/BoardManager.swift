//
//  BoardManager.swift
//  Nikki
//
//  Created by Suhanee on 18/04/25.
//

import Foundation
// Helpers/BoardManager.swift

import Foundation

class BoardManager {
    static let shared = BoardManager()
    
    private(set) var boards: [Board] = []
    
    func addBoard(title: String) {
        let newBoard = Board(id: UUID(), title: title, createdAt: Date())
        boards.append(newBoard)
    }
    
    func getBoards() -> [Board] {
        return boards
    }
    
    func getBoard(by id: UUID) -> Board? {
        return boards.first { $0.id == id }
    }
}
