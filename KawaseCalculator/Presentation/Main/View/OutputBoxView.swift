//
//  OutputBoxView.swift
//  KawaseCalculator
//
//  Created by Chon, Felix | Felix | MESD on 2022/09/29.
//

import SwiftUI

struct OutBoxView: View {

    var symbol: String
    var value: String
    
    var body: some View {
        HStack {
            Text(symbol)
            Text(value)
                .font(.system(size: 30))
                .textContentType(.oneTimeCode)
                .multilineTextAlignment(.trailing)
        }
    }
}
#if DEBUG
struct OutBoxView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            OutBoxView(symbol: "USD", value: "23200")
        }
    }
}
#endif
