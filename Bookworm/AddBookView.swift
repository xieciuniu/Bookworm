//
//  AddBookView.swift
//  Bookworm
//
//  Created by Hubert Wojtowicz on 20/07/2023.
//

import SwiftUI

struct AddBookView: View {
    // property that store managed object context
    @Environment(\.managedObjectContext) var moc
    
    // properties to store information about new book
    @State private var title = ""
    @State private var author = ""
    @State private var rating = 3
    @State private var genre = "Fantasy"
    @State private var review = ""
    @State private var date = Date.now
    
    // Validation for adding new book
//    static let newBookValidation = {
//        if title.isEmpty || author.isEmpty {
//            return false
//        }
//
//        return true
//    }
    
    //picker for storing genre options
    let genres = ["Fantasy", "Horror", "Kids", "Mystery", "Poetry", "Romance", "Thriller"]

    //propety that will dismiss this view after using button
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Name of book", text: $title)
                    TextField("Author's name", text: $author)
                    
                    Picker("Genre", selection: $genre) {
                        ForEach(genres, id: \.self) {
                            Text($0)
                        }
                    }
                }
                
                Section {
                    TextEditor(text: $review)
                    
                    RatingView(rating: $rating)
                } header: {
                    Text("Write a review")
                }
                
                Section {
                    Button("Save") {
                        // creating new Book record
                        let newBook = Book(context: moc)
                        newBook.id = UUID()
                        newBook.title = title
                        newBook.author = author
                        newBook.rating = Int16(rating)
                        newBook.genre = genre
                        newBook.review = review
                        newBook.date = date
                        
                        //saving new record
                        try? moc.save()
                        
                        //dismissing view
                        dismiss()
                    }
                    .disabled({if title.isEmpty || author.isEmpty {
                        return true
                    }
                        return false
                    }())
                }
            }
            .navigationTitle("Add Book")
        }
    }
}

struct AddBookView_Previews: PreviewProvider {
    static var previews: some View {
        AddBookView()
    }
}
