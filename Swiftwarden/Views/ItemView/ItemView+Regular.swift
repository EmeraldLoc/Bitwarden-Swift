import Foundation
import NukeUI
import SwiftUI

extension ItemView {
    var RegularView: some View {
        return AnyView (
            Group{
                HStack{
                    Button {
                        Task {
                            if let cipher{
                                try await account.user.deleteCipher(cipher:cipher, api: account.api)
                            }
                            account.selectedCipher = Cipher()
                        }
                        self.cipher = nil
                    } label: {
                        Text("Delete")
                    }
                    Spacer()
                    Button {
                        editing = true
                        
                    } label: {
                        Text("Edit")
                    }
                }
                VStack{
                    let name = cipher?.name ?? ""
                    let username = cipher?.login?.username ?? " "
                    let password = cipher?.login?.password ?? " "
                    HStack{
                        if let hostname{
                            LazyImage(url: account.api.getIcons(host: hostname))
                            { state in
                                if let image = state.image {
                                    image.resizable()
                                }
                            }
                            .clipShape(Circle())
                            .frame(width: 35, height: 35)
                        } else {
                            Image(systemName: "lock.circle")
                                .resizable()
                                .frame(width: 35, height: 35)
                        }
                        VStack{
                            Text(name)
                                .font(.system(size: 15))
                                .fontWeight(.semibold)
                                .frame(maxWidth: .infinity, alignment: .topLeading)
                            Text(verbatim: "Login")
                                .font(.system(size: 10))
                                .frame(maxWidth: .infinity, alignment: .topLeading)
                            
                        }
                        Button (action: {
                            favourite = !favourite
                            
                            let index = account.user.getCiphers(deleted: true).firstIndex(of: account.selectedCipher)
                            
                            
                            account.selectedCipher.favorite = favourite
                            Task {
                                do{
                                    try await account.user.updateCipher(cipher: account.selectedCipher, api: account.api, index: index)
                                } catch {
                                    print(error)
                                }
                                
                            }
                            
                        } ){
                            if (favourite) {
                                Image(systemName: "star.fill")
                                    .foregroundColor(.yellow)
                            } else {
                                Image(systemName: "star")
                                
                            }
                        }.buttonStyle(.plain)
                        
                        
                    }
                    Divider()
                    Field(
                        title: "Username",
                        content: username,
                        buttons: {
                            Copy(content: username)
                        })
                    Field(
                        title: "Password",
                        content: (showPassword ? password : String(repeating: "•", count: password.count)),
                        buttons: {
                            Hide(toggle: $showPassword)
                            Copy(content: password)
                        })
                    if let hostname{
                        Field(
                            title: "Website",
                            content: hostname,
                            buttons: {
                                Open(link: hostname)
                                Copy(content: hostname)
                            })
                    }
                    
                }
                Spacer()
            }
            )
            
        }
}