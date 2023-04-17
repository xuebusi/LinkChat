//
//  ConfigView.swift
//  LinkChat
//
//  Created by link on 2023/3/31.
//

import SwiftUI

struct ConfigApiKeyView: View {
    @EnvironmentObject var vm: ChatViewModel
    @State var secretKey: String = ""
    @Binding var showSuccessBox: Bool
    @FocusState var isTextFieldFocused: Bool
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading) {
                Text("API密钥")
                    .font(.system(.caption))
                    .foregroundColor(.gray)
                    .padding(.leading, 5)
                HStack {
                    TextField("请输入您的API密钥", text: $secretKey)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .focused($isTextFieldFocused)
                    if !secretKey.isEmpty {
                        Button(action: {
                            secretKey = ""
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.secondary)
                        }
                    }
                }
                Text("请到OpenAI官网(https://openai.com)申请密钥。")
                    .font(.system(.caption))
                    .foregroundColor(.gray)
                Button {
                    secretKey = secretKey.trimmingCharacters(in: .whitespacesAndNewlines)
                    UserDefManager.set(key: Config.SECRET_KEY_NAME, value: "\(secretKey)")
                    vm.secretKey = self.secretKey
                    self.showSuccessBox = true
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Text("保存")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .foregroundColor(.primary)
                        .background(.cyan)
                        .cornerRadius(10)
                }
                .padding(.top, 10)
            }
            .onAppear {
                secretKey = UserDefManager.getString(key: Config.SECRET_KEY_NAME)
            }
            .padding()
        }
        .navigationTitle("API密钥")
        .navigationBarTitleDisplayMode(.inline)
        .gesture(
            DragGesture()
                .onChanged({ gesture in
                    let dragType = detectDrag(end: gesture.predictedEndLocation, start: gesture.location)
                    if dragType == .TopToBottom || dragType == .BottomToTop {
                        isTextFieldFocused = false
                    }
                })
        )
        .onTapGesture {
            isTextFieldFocused = false
        }
    }
}

struct ConfigView_Previews: PreviewProvider {
    static var previews: some View {
        ConfigApiKeyView(showSuccessBox: Binding.constant(false))
            .environmentObject(ChatViewModel(api: OpenAIAPI()))
    }
}
