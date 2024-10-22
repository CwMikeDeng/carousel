//
//  Carousel.swift
//  Carousel
//
//  Created by mikedeng on 2024/10/22.
//


import SwiftUI

struct Carousel: View {
    
//    private let itemWidth: CGFloat = 120
    private let list: [Color] = [.red, .blue, .green]
    
//    private var totalElements: Int {
//       list.count * 3
//    }

    private let itemWidth: CGFloat
    private let itemPadding: CGFloat
    private var itemWidthAndPadding: CGFloat {
        itemWidth + itemPadding * 2
    }

    private let actualList: [Color] =  [.red, .blue, .green, .red, .blue, .green, .red, .blue, .green]

    @State private var contentOffset: CGFloat = 0.0

    init(itemWidth: CGFloat, itemPadding: CGFloat = 0) {
        self.itemWidth = itemWidth
        self.itemPadding = itemPadding
    }
    
    var body: some View {
        VStack {
            LazyHStack(spacing: 0) {
                ForEach(0..<actualList.count, id: \.self) { index in
                    Text(actualList[index].description)
                        .frame(width: itemWidth)
                        .frame(height: 100) // TODO: Remove
                        .background(
                            RoundedRectangle(cornerSize: CGSize(width: 10, height: 10), style: .continuous)
                                .fill(actualList[index])
                        )
                        .padding(.horizontal, itemPadding)
                }
            }
            .gesture(
                DragGesture()
//                    .onChanged { value in
//                        print("\(value.translation.width)")
//                    }
                    .onEnded { value in
                        withAnimation {
                            let dragItems = (value.translation.width / itemWidth).rounded()
                            let abs = abs(dragItems)

                            guard abs >= 1 else {
                                return
                            }
                            
                            if dragItems > 0 {
                                contentOffset += itemWidthAndPadding
                            }
                            if dragItems < 0 {
                                contentOffset -= itemWidthAndPadding
                            }
                        }

                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            if contentOffset < -itemWidthAndPadding * CGFloat(list.count - 1) {
                                contentOffset += itemWidthAndPadding * CGFloat(list.count)
                            }
                            if contentOffset > itemWidthAndPadding * CGFloat(list.count - 1) {
                                contentOffset -= itemWidthAndPadding * CGFloat(list.count)
                            }
                        }
                    }
            )
            .offset(x: contentOffset, y: 0.0)
            .fixedSize()
        }
    }
    
    // TODO: auto scroll
}

struct CarouselView_Previews: PreviewProvider {
    static var previews: some View {
        Carousel(itemWidth: 100, itemPadding: 10)
    }
}
