//
//  ContentView.swift
//  Certstream
//
//  Created by Felix Wehnert on 10.06.19.
//  Copyright © 2019 Felix Wehnert. All rights reserved.
//

import SwiftUI
import UIKit

struct ContentView : View {
    @EnvironmentObject private var api: API
    
    var body: some View {
        //UIView.setAnimationsEnabled(false)
        return NavigationView {
            List(api.certs) { cert in
                NavigationButton(destination: CertDetailView(cert: cert)) {
                    Text(cert.leaf_cert.domains.joined(separator: ", "))
                }
            }.navigationBarTitle(Text("\(api.certs.count) Certs"))
        }
        
    }
}

#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif
