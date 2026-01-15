//
//  CharacterDetailView.swift
//  RickyMortyApp
//
//  Created by Angel Tejedor on 14/01/26.
//

import SwiftUI

struct CharacterDetailView: View {
    @StateObject private var viewModel: CharacterDetailViewModel
    
    init(viewModel: CharacterDetailViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        content
            .navigationTitle("Details")
            .navigationBarTitleDisplayMode(.inline)
            .task {
                await viewModel.loadCharacter()
            }
    }
    
    @ViewBuilder
    private var content: some View {
        switch viewModel.state {
        case .loading:
            LoadingView()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            
        case .error(let message):
            ErrorView(message: message) {
                Task { await viewModel.retry() }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
        case .loaded(let character):
            characterContent(character)
        }
    }
    
    // MARK: - Character Content
    
    private func characterContent(_ character: Character) -> some View {
        ScrollView {
            VStack(spacing: 24) {
                characterImage(url: character.image)
                
                Text(character.name)
                    .font(.title.bold())
                    .multilineTextAlignment(.center)
                
                statusBadge(character.status)
                
                infoGrid(character)
                
                episodeSection(character)
            }
            .padding()
        }
    }
    
    // MARK: - Character Image
    
    private func characterImage(url: String) -> some View {
        AsyncImage(url: URL(string: url)) { image in
            image
                .resizable()
                .aspectRatio(contentMode: .fill)
        } placeholder: {
            Rectangle()
                .fill(Color.gray.opacity(0.3))
                .overlay { ProgressView() }
        }
        .frame(width: 200, height: 200)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(radius: 8)
    }
    
    // MARK: - Status Badge
    
    private func statusBadge(_ status: CharacterStatus) -> some View {
        HStack(spacing: 6) {
            Circle()
                .fill(statusColor(status))
                .frame(width: 10, height: 10)
            
            Text(status.rawValue)
                .font(.subheadline.weight(.medium))
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .background(statusColor(status).opacity(0.15))
        .clipShape(Capsule())
    }
    
    private func statusColor(_ status: CharacterStatus) -> Color {
        switch status {
        case .alive: return .green
        case .dead: return .red
        case .unknown: return .gray
        }
    }
    
    // MARK: - Info Grid
    
    private func infoGrid(_ character: Character) -> some View {
        LazyVGrid(columns: [
            GridItem(.flexible()),
            GridItem(.flexible())
        ], spacing: 16) {
            infoItem(title: "Species", value: character.species, icon: "person.fill")
            infoItem(title: "Gender", value: character.gender.rawValue, icon: "figure.stand")
            infoItem(title: "Origin", value: character.origin.name, icon: "globe")
            infoItem(title: "Location", value: character.location.name, icon: "mappin.circle.fill")
        }
        .padding()
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
    
    private func infoItem(title: String, value: String, icon: String) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Label(title, systemImage: icon)
                .font(.caption)
                .foregroundStyle(.secondary)
            
            Text(value)
                .font(.subheadline.weight(.medium))
                .lineLimit(2)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    // MARK: - Episode Section
    
    private func episodeSection(_ character: Character) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Label("Episodes", systemImage: "tv.fill")
                .font(.headline)
            
            Text("\(character.episode.count) episode\(character.episode.count == 1 ? "" : "s")")
                .font(.subheadline)
                .foregroundStyle(.secondary)
            
            if !character.episode.isEmpty {
                VStack(alignment: .leading, spacing: 4) {
                    ForEach(character.episode.prefix(5), id: \.self) { episodeURL in
                        if let episodeNumber = episodeURL.split(separator: "/").last {
                            Text("Episode \(String(episodeNumber))")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                    
                    if character.episode.count > 5 {
                        Text("... and \(character.episode.count - 5) more")
                            .font(.caption)
                            .foregroundStyle(.tertiary)
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

#Preview {
    let apiClient = APIClient()
    let repository = CharacterRepositoryImpl(apiClient: apiClient)
    let viewModel = CharacterDetailViewModel(characterId: 1, repository: repository)
    
    return NavigationStack {
        CharacterDetailView(viewModel: viewModel)
    }
}
