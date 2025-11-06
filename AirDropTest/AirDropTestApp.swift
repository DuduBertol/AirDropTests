//
//  AirDropTestApp.swift
//  AirDropTest
//
//  Created by Eduardo Bertol on 05/11/25.
//

import SwiftUI

import SwiftUI

@main
struct AirDropTestApp: App {
    @StateObject private var gameManager = GameManager()
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(gameManager)
                .onOpenURL { url in
                    processarArquivoRecebido(url: url)
                }
                .alert("Recurso Recebido! 🎁", isPresented: $showAlert) {
                    Button("OK", role: .cancel) { }
                } message: {
                    Text(alertMessage)
                }
        }
    }
    
    func processarArquivoRecebido(url: URL) {
        do {
            // Ler o conteúdo do arquivo JSON
            let data = try Data(contentsOf: url)
            let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
            
            if let tipo = json?["tipo"] as? String,
               let quantidade = json?["quantidade"] as? Int,
               let deJogador = json?["deJogador"] as? String {
                
                print("✅ Recurso recebido: \(quantidade) \(tipo) de \(deJogador)")
                
                // Atualizar o inventário
                gameManager.receberRecurso(tipo: tipo, quantidade: quantidade)
                
                // Mostrar alerta
                alertMessage = "Você recebeu \(quantidade) \(tipo) de \(deJogador)"
                showAlert = true
            }
            
        } catch {
            print("❌ Erro ao processar arquivo: \(error)")
        }
    }
}
