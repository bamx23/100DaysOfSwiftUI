//
//  ContentView.swift
//  Bookworm
//
//  Created by Nikolay Volosatov on 11/15/19.
//  Copyright © 2019 BX23. All rights reserved.
//

import SwiftUI
import CoreData

struct PushButton: View {
    let title: String
    @Binding var isOn: Bool

    private let onColors = [Color.red, Color.yellow]
    private let offColors = [Color(white: 0.6), Color(white: 0.4)]

    var body: some View {
        Button(title) {
            self.isOn.toggle()
        }
        .padding()
        .background(LinearGradient(gradient: Gradient(colors: isOn ? onColors : offColors),
                               startPoint: .top,
                               endPoint: .bottom))
        .foregroundColor(.white)
        .clipShape(Capsule())
        .shadow(radius: isOn ? 0 : 10)

    }
}

extension Book {
    var dateString: String {
        guard let date = date else {
            return "no date"
        }
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

struct ContentView: View {
    @Environment(\.managedObjectContext) var moc

    @FetchRequest(entity: Book.entity(),
                  sortDescriptors: [
                    NSSortDescriptor(keyPath: \Book.title, ascending: true),
                    NSSortDescriptor(keyPath: \Book.author, ascending: true),
                  ]) var books: FetchedResults<Book>

    @State private var showingAddScreen = false

    func deleteBooks(at offsets: IndexSet) {
        for offset in offsets {
            let book = books[offset]
            moc.delete(book)
        }
        try? moc.save()
    }

    var body: some View {
        NavigationView {
            List{
                ForEach(books, id: \.id) { book in
                    NavigationLink(destination: DetailView(book: book)) {
                        EmojiRatingView(rating: book.rating)
                            .font(.largeTitle)

                        VStack(alignment: .leading) {
                            Text(book.title ?? "No Title")
                                .font(.headline)
                                .foregroundColor(book.rating == 1 ? .red : .primary)
                            Text(book.author ?? "Unknown Author")
                                .foregroundColor(.secondary)
                            Text(book.dateString)
                                .foregroundColor(.secondary)
                        }
                    }
                }
                .onDelete(perform: deleteBooks)
            }
            .navigationBarTitle("Bookworm")
            .navigationBarItems(leading:EditButton(), trailing: Button(action: {
                self.showingAddScreen.toggle()
            }) {
                Image(systemName: "plus")
            })
            .sheet(isPresented: $showingAddScreen) {
                AddBookView().environment(\.managedObjectContext, self.moc)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environment(\.managedObjectContext, NSPersistentContainer(name: "Bookworm").viewContext)
    }
}
