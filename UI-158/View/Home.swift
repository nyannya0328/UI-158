//
//  Home.swift
//  UI-158
//
//  Created by にゃんにゃん丸 on 2021/04/08.
//

import SwiftUI

struct Home: View {
    @State var urlText = ""
    @StateObject var downloadmodel = DownLoadTaskModel()
    var body: some View {
        NavigationView{
            
            VStack(spacing:15){
                
                TextField("Url Search", text: $urlText)
                    .padding(.vertical,10)
                    .padding(.horizontal)
                    .background(Color.white)
                    
                    .cornerRadius(8)
                    .shadow(color: Color.black.opacity(0.2), radius: 5, x: 5, y: 5)
                    .shadow(color: Color.black.opacity(0.2), radius: 5, x: -5, y: -5)
                
                Button(action: {
                    downloadmodel.startDownload(urlstring: urlText)
                    
                }, label: {
                    Text("Down load Text")
                        .fontWeight(.semibold)
                        .padding(.vertical,10)
                        .padding(.horizontal,30)
                        .foregroundColor(.white)
                        .background(Color.blue)
                        .clipShape(Capsule())
                })
                .padding(.top,20)
                
                
            }
            .padding()
            .navigationTitle("Down Load Task")
        }
        .preferredColorScheme(.light)
        .alert(isPresented: $downloadmodel.showAlert, content: {
            Alert(title: Text("Message"), message: Text(downloadmodel.alertMsg), dismissButton: .destructive(Text("Ok")))
        })
        .overlay(
        
            ZStack{
                
                if downloadmodel.showDownloadProsess{
                    
                    DownLoadProgressView(progress: $downloadmodel.downLoadProgress)
                        .environmentObject(downloadmodel)
                    
                }
            }
        )
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
