import Combine
import SwiftUI

struct OnScroll: ViewModifier {
    @Binding var offset: CGFloat

    func body(content: Content) -> some View {
        return VStack {
            GeometryReader { geometry -> ForEach<Range<Int>, Int, EmptyView> in
                let newOffset = geometry.frame(in: .global).minY
                if self.offset != newOffset { self.offset = newOffset }
                return ForEach(0..<0) { _ -> EmptyView in
                    assertionFailure()
                    return EmptyView()
                }
            }
            content
        }
    }
}

final class Store: ObservableObject {
    @Published var offset: CGFloat = 0 {
        didSet {
            print(offset)
        }
    }
}

struct MyScrollView: View {
    var body: some View {
        MyView().environmentObject(Store())
    }
}

struct MyView: View {
    @EnvironmentObject var store: Store

    var body: some View {
        VStack {
            Text("\(store.offset)")
            ScrollView {
                VStack {
                    ScrollContent(store: store)
                        .modifier(OnScroll(offset: self.$store.offset))
                }
            }
        }
    }
}

struct ScrollContent: View {
    @ObservedObject var store: Store

    var body: some View {
        print("I can print offset: \(store.offset)")
        return Text("foo")
    }
}

#if DEBUG
struct MyScrollView_Previews: PreviewProvider {
    static var previews: some View {
        MyScrollView()
    }
}
#endif
