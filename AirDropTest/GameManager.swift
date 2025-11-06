//
//  GameManager.swift
//  AirDropTest
//
//  Created by Eduardo Bertol on 05/11/25.
//

import Foundation
import SwiftUI
import Combine

class GameManager: ObservableObject {
    @Published var pedras: Int = 10
    @Published var madeira: Int = 5
    @Published var ouro: Int = 2
    
    private let defaults = UserDefaults.standard
    
    init() {
        carregarInventario()
    }
    
    func receberRecurso(tipo: String, quantidade: Int) {
        switch tipo {
        case "pedras":
            pedras += quantidade
        case "madeira":
            madeira += quantidade
        case "ouro":
            ouro += quantidade
        default:
            break
        }
        salvarInventario()
    }
    
    func enviarPedras(quantidade: Int) -> Bool {
        guard pedras >= quantidade else { return false }
        pedras -= quantidade
        salvarInventario()
        return true
    }
    
    func enviarMadeira(quantidade: Int) -> Bool {
        guard madeira >= quantidade else { return false }
        madeira -= quantidade
        salvarInventario()
        return true
    }
    
    func salvarInventario() {
        defaults.set(pedras, forKey: "pedras")
        defaults.set(madeira, forKey: "madeira")
        defaults.set(ouro, forKey: "ouro")
    }
    
    func carregarInventario() {
        pedras = defaults.integer(forKey: "pedras")
        madeira = defaults.integer(forKey: "madeira")
        ouro = defaults.integer(forKey: "ouro")
        
        // Valores iniciais se for primeira vez
        if pedras == 0 && madeira == 0 && ouro == 0 {
            pedras = 10
            madeira = 5
            ouro = 2
            salvarInventario()
        }
    }
}
