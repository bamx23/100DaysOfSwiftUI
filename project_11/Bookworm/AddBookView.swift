//
//  AddBookView.swift
//  Bookworm
//
//  Created by Nikolay Volosatov on 11/16/19.
//  Copyright © 2019 BX23. All rights reserved.
//

import SwiftUI

struct AddBookView: View {
    @Environment(\.managedObjectContext) var moc
    @Environment(\.presentationMode) var presentationMode

    @State private var title = ""
    @State private var author = ""
    @State private var rating = 3
    @State private var genre = Genre.defaultGenre
    @State private var review = ""

    private func addBook() {
        let newBook = Book(context: moc)
        newBook.id = UUID()
        newBook.title = title
        newBook.author = author
        newBook.rating = Int16(rating)
        newBook.genre = genre.rawValue
        newBook.review = review
        newBook.date = Date()

        try? moc.save()
    }

    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Name of book", text: $title)
                    TextField("Author's name", text: $author)
                        .textContentType(.name)

                    Picker("Genre", selection: $genre) {
                        ForEach(Genre.allCases, id: \.self) {
                            Text($0.title)
                        }
                    }
                }

                Section {
                    RatingView(rating: $rating, label: "Rating")
                    TextField("Write a review", text: $review)
                }

                Section {
                    Button("Save") {
                        self.addBook()
                        self.presentationMode.wrappedValue.dismiss()
                    }
                }
            }
            .navigationBarTitle("Add Book")
        }
    }
}

struct AddBookView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            AddBookView()
        }
    }
}
