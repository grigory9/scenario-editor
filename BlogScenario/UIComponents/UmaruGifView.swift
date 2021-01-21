//
//  UmaruGifView.swift
//  BlogScenario
//
//  Created by  userauto on 08.01.2021.
//

import SwiftUI

struct UmaruGifView: View {
    var body: some View {
		SwiftUIGIFPlayerView(gifName: "UmaruGif")
				.aspectRatio(CGSize(width: 1.9, height: 1.0), contentMode: .fit)
				.clipShape(Circle())
				.overlay(Circle().stroke(Color.white, lineWidth: 4.0))
				.shadow(radius: 12)
    }
}

struct UmaruGifView_Previews: PreviewProvider {
    static var previews: some View {
        UmaruGifView()
    }
}
