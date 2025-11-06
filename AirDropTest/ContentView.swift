//
//  ContentView.swift
//  AirDropTest
//
//  Created by Eduardo Bertol on 05/11/25.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var gameManager: GameManager
    @State private var showShareSheet = false
    @State private var itemsToShare: [Any] = []
    @State private var showAlert = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    
    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                gradient: Gradient(colors: [Color.blue.opacity(0.3), Color.purple.opacity(0.3)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 30) {
                // Título
                Text("Meu Inventário")
                    .font(.system(size: 36, weight: .bold))
                    .foregroundColor(.primary)
                    .padding(.top, 40)
                
                // Inventário
                VStack(spacing: 20) {
                    RecursoRow(icone: "🪨", nome: "Pedras", quantidade: gameManager.pedras)
                    RecursoRow(icone: "🪵", nome: "Madeira", quantidade: gameManager.madeira)
                    RecursoRow(icone: "🪙", nome: "Ouro", quantidade: gameManager.ouro)
                }
                .padding()
                .background(Color.white.opacity(0.9))
                .cornerRadius(20)
                .shadow(radius: 10)
                .padding(.horizontal)
                
                Spacer()
                
                // Botões de enviar
                VStack(spacing: 15) {
                    Button(action: {
                        enviarPedras()
                    }) {
                        HStack {
                            Text("Enviar 2 Pedras")
                                .font(.headline)
                            Spacer()
                            Text("🪨")
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.brown)
                        .foregroundColor(.white)
                        .cornerRadius(15)
                        .shadow(radius: 5)
                    }
                    
                    Button(action: {
                        enviarMadeira()
                    }) {
                        HStack {
                            Text("Enviar 1 Madeira")
                                .font(.headline)
                            Spacer()
                            Text("🪵")
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.orange)
                        .foregroundColor(.white)
                        .cornerRadius(15)
                        .shadow(radius: 5)
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 40)
            }
        }
        .sheet(isPresented: $showShareSheet) {
            ShareSheet(items: itemsToShare)
        }
        .alert(alertTitle, isPresented: $showAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(alertMessage)
        }
    }
    
    func enviarPedras() {
        guard gameManager.enviarPedras(quantidade: 2) else {
            alertTitle = "Ops!"
            alertMessage = "Você não tem pedras suficientes"
            showAlert = true
            return
        }
        
        let recurso: [String: Any] = [
            "tipo": "pedras",
            "quantidade": 2,
            "deJogador": UIDevice.current.name,
            "timestamp": Date().timeIntervalSince1970
        ]
        
        compartilharRecurso(recurso)
    }
    
    func enviarMadeira() {
        guard gameManager.enviarMadeira(quantidade: 1) else {
            alertTitle = "Ops!"
            alertMessage = "Você não tem madeira suficiente"
            showAlert = true
            return
        }
        
        let recurso: [String: Any] = [
            "tipo": "madeira",
            "quantidade": 1,
            "deJogador": UIDevice.current.name,
            "timestamp": Date().timeIntervalSince1970
        ]
        
        compartilharRecurso(recurso)
    }
    
    func compartilharRecurso(_ recurso: [String: Any]) {
        do {
            // Converter para JSON
            let jsonData = try JSONSerialization.data(withJSONObject: recurso, options: .prettyPrinted)
            
            // Salvar em arquivo temporário
            let tempDir = FileManager.default.temporaryDirectory
            let fileURL = tempDir.appendingPathComponent("recurso.gamedata")
            try jsonData.write(to: fileURL)
            
            // Preparar para compartilhar
            itemsToShare = [fileURL]
            showShareSheet = true
            
        } catch {
            print("Erro ao compartilhar: \(error)")
        }
    }
}

// View auxiliar para mostrar cada recurso
struct RecursoRow: View {
    let icone: String
    let nome: String
    let quantidade: Int
    
    var body: some View {
        HStack {
            Text(icone)
                .font(.system(size: 40))
            Text(nome)
                .font(.title2)
                .fontWeight(.semibold)
            Spacer()
            Text("\(quantidade)")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.blue)
        }
        .padding(.horizontal)
    }
}

// ShareSheet para o AirDrop
struct ShareSheet: UIViewControllerRepresentable {
    let items: [Any]
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(
            activityItems: items,
            applicationActivities: nil
        )
        
        controller.completionWithItemsHandler = { _, completed, _, _ in
            if completed {
                print("✅ Recurso enviado com sucesso")
            }
        }
        
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}

#Preview {
    ContentView()
        .environmentObject(GameManager())
}

#Preview {
    ContentView()
}
