//
//  ImageLoader.swift
//  GeeksHubsTest
//
//  Created by De La Cruz, Eduardo on 31/12/2019.
//  Copyright © 2019 De La Cruz, Eduardo. All rights reserved.
//

import SwiftUI
import UIKit
import Combine

class ImageLoader: ObservableObject {
    
    var objectWillChange = PassthroughSubject<Data, Never>()
    var data = Data() {
        didSet {
            objectWillChange.send(data)
        }
    }

    init(urlString: String) {
        guard let url = URL(string: urlString) else { return }
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
            DispatchQueue.main.async {
                self.data = data
            }
        }
        task.resume()
    }
}

struct ImageView: View {

    @ObservedObject var imageLoader: ImageLoader
    @State var image: UIImage? = nil

    init(withURL url:String) {
        imageLoader = ImageLoader(urlString:url)
    }

    var body: some View {
        VStack {
            Image(uiImage: image ?? UIImage(imageLiteralResourceName: "Avatar"))
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width:150, height:150)
        }.onReceive(imageLoader.objectWillChange) { data in
            self.image = UIImage(data: data) ?? UIImage()
        }
    }
}
