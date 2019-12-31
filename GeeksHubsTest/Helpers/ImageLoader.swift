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
    @State var nameString: String?
    
    var size: CGFloat?

    init(withURL url: String?, nameString: String, size: CGFloat) {
        imageLoader = ImageLoader(urlString:url ?? "")
        self.nameString = nameString
        self.size = size
    }

    var body: some View {
        VStack {
            Image(uiImage: image ?? UIImage(imageLiteralResourceName: nameString ?? "avatar"))
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width:size, height:size)
        }.onReceive(imageLoader.objectWillChange) { data in
            self.image = UIImage(data: data) ?? UIImage()
        }
    }
}
