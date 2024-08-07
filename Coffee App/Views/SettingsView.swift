import SwiftUI

struct SettingsView: View {
    @Binding var selectedTab: Int
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.black.edgesIgnoringSafeArea(.all)
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        Text("Brew Log is a passion project designed and developed by a single person - me, Kas 👋")
                            .foregroundColor(.white)
                            .padding(.top, 20)
                            .padding(.leading, 30)
                            .padding(.trailing, 65)
                        
                        Text("I hope you find it useful and enjoy using the app. If you like it, please leave a review in the app store and share it with fellow coffee enthusiasts. Happy brewing! ☕️")
                            .foregroundColor(.white)
                            .padding(.leading, 30)
                            .padding(.trailing, 70)
                        
                        VStack(spacing: 0) {
                            SettingsRow(icon: "star", text: "Rate")
                            SettingsRowDivider()
                            SettingsRow(icon: "lock", text: "Privacy Policy")
                            SettingsRowDivider()
                            SettingsRow(icon: "doc.text", text: "Terms of Service")
                            SettingsRowDivider()
                            SettingsRow(icon: "square.and.arrow.up", text: "Share")
                        }
                        .background(Color(hex: "1C1C1E"))
                        .cornerRadius(10)
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                    }
                }
            }
            .navigationBarTitle("Settings", displayMode: .inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        selectedTab = 0
                    }) {
                        HStack {
                            Image(systemName: "chevron.left")
                            Text("Back")
                        }
                    }
                }
            }
        }
    }
}

struct SettingsRow: View {
    let icon: String
    let text: String
    
    var body: some View {
        HStack {
            ZStack {
                RoundedRectangle(cornerRadius: 6)
                    .fill(Color(hex: "98989E"))
                    .frame(width: 30, height: 30)
                Image(systemName: icon)
                    .foregroundColor(.white)
            }
            Text(text)
                .foregroundColor(.white)
                .padding(.leading, 4)
            Spacer()
            Image(systemName: "chevron.right")
                .foregroundColor(Color(hex: "5A595F"))
        }
        .padding()
        .background(Color(hex: "1C1C1E"))
    }
}

struct SettingsRowDivider: View {
    var body: some View {
        HStack {
            Spacer()
                .frame(width: 46)
            Rectangle()
                .fill(Color.gray.opacity(0.3))
                .frame(height: 0.5)
        }
        .background(Color(hex: "1C1C1E"))
    }
}


struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(selectedTab: .constant(2))
            .preferredColorScheme(.dark)
    }
}
