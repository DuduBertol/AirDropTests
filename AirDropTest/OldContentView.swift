
//
//  ContentView.swift
//  AirDropTest
//
//  Created by Eduardo Bertol on 05/11/25.
//

import SwiftUI

struct OldContentView: View {
    @State private var showShareSheet = false
    @State private var itemsToShare: [Any] = []
    
    var body: some View {
        VStack(spacing: 30) {
            Text("AirDrop Test")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Button(action: {
                itemsToShare = ["Olá! Mensagem via AirDrop do meu app! 🚀"]
                showShareSheet = true
            }) {
                Text("Compartilhar Texto")
                    .frame(width: 250, height: 50)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            
            Button(action: {
                let imagem = criarImagem()
                itemsToShare = [imagem]
                showShareSheet = true
            }) {
                Text("Compartilhar Imagem")
                    .frame(width: 250, height: 50)
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            
            Button(action: {
                let fileURL = criarJSON()
                itemsToShare = [fileURL]
                showShareSheet = true
            }) {
                Text("Compartilhar JSON")
                    .frame(width: 250, height: 50)
                    .background(Color.orange)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
        }
        .sheet(isPresented: $showShareSheet) {
            ShareSheet(items: itemsToShare)
        }
    }
    
    func criarImagem() -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 300, height: 300))
        return renderer.image { ctx in
            UIColor.systemPurple.setFill()
            ctx.fill(CGRect(x: 0, y: 0, width: 300, height: 300))
            
            let texto = "Imagem do App"
            let attrs: [NSAttributedString.Key: Any] = [
                .font: UIFont.boldSystemFont(ofSize: 24),
                .foregroundColor: UIColor.white
            ]
            texto.draw(at: CGPoint(x: 50, y: 130), withAttributes: attrs)
        }
    }
    
    func criarJSON() -> URL {
        let dados = """
        {
            "nome": "João Silva",
            "idade": 28,
            "cidade": "Curitiba"
        }
        """
        
        let data = dados.data(using: .utf8)!
        let tempDir = FileManager.default.temporaryDirectory
        let fileURL = tempDir.appendingPathComponent("usuario.json")
        try? data.write(to: fileURL)
        
        return fileURL
    }
}

struct OldxShareSheet: UIViewControllerRepresentable {
    let items: [Any]
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController( //esse cara é o airdrop?
            activityItems: items,
            applicationActivities: nil
        )
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}

#Preview {
    ContentView()
}
