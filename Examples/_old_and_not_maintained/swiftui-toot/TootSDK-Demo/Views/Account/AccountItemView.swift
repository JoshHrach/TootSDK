//
//  AccountItemView.swift
//  SwiftUI-Toot
//
//  Created by dave on 21/12/22.
//

import SwiftUI

struct AccountItemView<Content: View>: View {
    var description: String
    var value: String?

    let content: Content

    init(
        description: String,
        value: String? = nil,
        @ViewBuilder content: () -> Content = { EmptyView() }
    ) {
        self.description = description
        self.value = value
        self.content = content()
    }

    var body: some View {
        HStack {
            Text(description + ": ")
            content
            Text(value ?? "")
            Spacer()
        }
    }
}
