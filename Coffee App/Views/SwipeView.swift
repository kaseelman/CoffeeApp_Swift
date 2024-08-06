import SwiftUI

struct SwipeView<Content: View>: View {
    let content: Content
    let onDelete: () -> Void
    let onToggleStatus: () -> Void
    let isFinished: Bool
    
    @State private var offset: CGFloat = 0
    @State private var showingButtons = false
    
    init(@ViewBuilder content: @escaping () -> Content, onDelete: @escaping () -> Void, onToggleStatus: @escaping () -> Void, isFinished: Bool) {
        self.content = content()
        self.onDelete = onDelete
        self.onToggleStatus = onToggleStatus
        self.isFinished = isFinished
    }
    
    var body: some View {
        ZStack {
            HStack(spacing: 0) {
                Spacer()
                Button(action: onToggleStatus) {
                    Image(systemName: isFinished ? "arrow.counterclockwise" : "checkmark")
                        .foregroundColor(.white)
                        .frame(width: 60, height: 60)
                        .background(isFinished ? Color.blue : Color.green)
                }
                Button(action: onDelete) {
                    Image(systemName: "trash")
                        .foregroundColor(.white)
                        .frame(width: 60, height: 60)
                        .background(Color.red)
                }
            }
            
            content
                .background(Color(hex: "#1C1C1D"))
                .cornerRadius(15)
                .offset(x: offset)
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            if value.translation.width < 0 {
                                offset = max(value.translation.width, -120)
                                showingButtons = true
                            }
                        }
                        .onEnded { value in
                            withAnimation {
                                if value.translation.width < -60 {
                                    offset = -120
                                } else {
                                    offset = 0
                                    showingButtons = false
                                }
                            }
                        }
                )
        }
    }
}
