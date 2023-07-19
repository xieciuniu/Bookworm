//
//  DetailView.swift
//  Bookworm
//
//  Created by Hubert Wojtowicz on 20/07/2023.
//

import SwiftUI
import CoreData

struct DetailView: View {
    // book it show
    let book: Book
    
    // properties to delete alert
    @Environment(\.managedObjectContext) var moc
    @Environment(\.dismiss) var dismiss
    @State private var showingDeleteAlert = false
    
    var body: some View {
        ScrollView {
            // Header of book genre with image
            ZStack(alignment: .bottomTrailing) {
                Image(book.genre ?? "Fantasy")
                    .resizable()
                    .scaledToFit()
                
                Text(book.genre?.uppercased() ?? "FANTASY")
                    .font(.caption)
                    .fontWeight(.black)
                    .padding(8)
                    .foregroundColor(.white)
                    .background(.black.opacity(0.75))
                    .clipShape(Capsule())
                    .offset(x: -5, y: -5)
            }
            
            // date of adding review
            if book.date != nil {
                HStack{
                    Spacer()
                    Text("\(book.date!.formatted(date: .abbreviated, time: .shortened))")
                        .font(.caption2)
                        .padding()
                }
            }
            
            // Author of the book
            Text(book.author ?? "Unknown author")
                .font(.title)
                .foregroundColor(.secondary)
            
            // Book review
            Text(book.review ?? "No review")
                .padding()
            
            //Book rating
            RatingView(rating: .constant(Int(book.rating)))
                .font(.largeTitle)
        }
        // alert for deleting book
        .alert("Delete book", isPresented: $showingDeleteAlert) {
            Button("Delete", role: .destructive, action: deleteBook)
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("Are you sure?")
        }
        
        // Toolbar item initalizing delete proccess
        .toolbar {
            Button {
                showingDeleteAlert = true
            } label: {
                Label("Delete this book", systemImage: "trash")
            }
        }
        
        // Book title
        .navigationTitle(book.title ?? "Unknow Book")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    // Method to delete current book and dismiss this view
    func deleteBook() {
        moc.delete(book)
        
//        This lane will permamently delete book
        try? moc.save()
        //going back 
        dismiss()
    }
}

struct DetailView_Previews: PreviewProvider {
    //Creating context of core data object
    static let moc = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
    
    static var previews: some View {
        // Creating temperary object to give insight on how object should look
        let book = Book(context: moc)
        book.title = "Test book"
        book.author = "Test author"
        book.genre = "Fantasy"
        book.rating = 4
        book.review = "Test review"
        book.date = Date.now
        
        return NavigationView {
            DetailView(book: book)
        }
    }
}
