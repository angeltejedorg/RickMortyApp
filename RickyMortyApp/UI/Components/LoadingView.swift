//
//  LoadingView.swift
//  RickyMortyApp
//
//  Created by Angel Tejedor on 14/01/26.
//

import SwiftUI

struct LoadingView: View {
    var body: some View {
        VStack(spacing: 16) {
            ProgressView()
                .scaleEffect(1.5)
            Text("Loading...")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
    }
}

#Preview {
    LoadingView()
}
