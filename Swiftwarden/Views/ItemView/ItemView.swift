import Foundation
import NukeUI
import SwiftUI

enum RepromptState {
    case none
    case require
    case unlocked
    
    func reprompt() -> Bool {
        return self != .none
    }
    
    func toInt() -> Int {
        if self == .none {
            return 0
        } else {
            return 1
        }
    }
    
    static func fromInt(_ value: Int) -> RepromptState {
        if value == 0 {
            return .none
        } else {
            return .require
        }
    }
    
}



struct ItemView: View {
    @State var cipher: Cipher?
    @EnvironmentObject var account: Account

    @State var favorite: Bool

    @State var showPassword = false

    @State var editing: Bool = false
    @State var reprompt: RepromptState = .none

    init (cipher: Cipher?){
        _cipher = State(initialValue: cipher)
        if let repromptInt = cipher?.reprompt {
            reprompt = RepromptState.fromInt(repromptInt)
        }
        _favorite = State(initialValue:cipher?.favorite ?? false)
        
        editing = false
        showPassword = false
    }
    var body: some View {
            GroupBox {
                if cipher != nil {
                    if !editing {
                        PasswordView(cipher: self.$cipher, editing: $editing, reprompt: $reprompt, account: account)
                            .padding(20)
                            .frame(maxWidth: 800)
                    } else {
                        PasswordEditing(cipher: $cipher, editing: $editing, account: account)
                            .padding(20)
                            .frame(maxWidth: 800)
                    }

                }

        }
        .frame(maxWidth: .infinity, alignment: .topLeading)
        .toolbar {
            ToolbarItem {
                Spacer()
            }
        }
//        .onAppear {
////            name = cipher?.name ?? ""
////            username = cipher?.login?.username ?? ""
////            password = cipher?.login?.password ?? ""
////            if let uris = cipher?.login?.uris {
////                self.uris = uris
////            }
//        }
    }

    struct ItemView_Previews: PreviewProvider {
        static var previews: some View {
            let cipher = Cipher(login: Login(password: "test", username: "test"), name: "Test")
            let account = Account()

            Group {
//                ItemView(cipher: cipher, favorite: true, reprompt: $reprompt)
//                    .environmentObject(account)
            }
        }
    }
}
