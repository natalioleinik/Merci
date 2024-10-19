//
//  JournalArchiveView.swift
//  Merci
//
//  Created by Natali Oleinik on 10/19/24.
//

import SwiftUI

struct JournalArchiveView: View {
    @ObservedObject var gratitudeManager = GratitudeManager.shared

    var body: some View {
        NavigationStack {
            VStack {
                Text("Gratitude Archive")
                    .font(.largeTitle)
                    .foregroundColor(.pink)
                    .padding()

                List {
                    ForEach(gratitudeManager.gratitudeEntries.indices, id: \.self) { index in
                        VStack(alignment: .leading) {
                            Text(gratitudeManager.gratitudeEntries[index].gratitude)
                                .font(.body)
                            Text("\(gratitudeManager.gratitudeEntries[index].date, formatter: itemFormatter)")
                                .font(.footnote)
                                .foregroundColor(.gray)
                        }
                    }
                    .onDelete(perform: deleteEntry)
                }
            }
            .navigationTitle("Archive")
        }
    }

    private func deleteEntry(at offsets: IndexSet) {
        for index in offsets {
            gratitudeManager.deleteEntry(at: index)
        }
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    formatter.timeStyle = .short
    return formatter
}()

#Preview {
    JournalArchiveView()
}
