//
//  CertDetailView.swift
//  Certstream
//
//  Created by Felix Wehnert on 24.06.19.
//  Copyright © 2019 Felix Wehnert. All rights reserved.
//

import SwiftUI

struct CertDetailView : View {
    let cert: CertstreamEntry
    
    var body: some View {
        
        Form {
            Section(header: Text("Fingerprint")) {
                Text(cert.leaf_cert.fingerprint)
            }
            
            Section(header: Text("Domains")) {
                ForEach(cert.leaf_cert.domains.identified(by: \.self)) { domain in
                    Text(domain)
                }
            }
            
            Section(header: Text("Issuer")) {
                Text(cert.chain.first?.subject.CN ?? "N/A")
            }
        }
            .environment(\.minimumScaleFactor, 0.5)

        
    }
}
