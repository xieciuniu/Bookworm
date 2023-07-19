//
//  ContentView.swift
//  Bookworm
//
//  Created by Hubert Wojtowicz on 19/07/2023.
//

import SwiftUI
// Day 53 first exesrcise - making button with @Binding which change properties in different struct
//struct PushButton: View {
//    let title: String
//    @Binding var isOn: Bool
//
//    var onColor = [Color.red, Color.yellow]
//    var offColor = [Color(white: 0.6), Color(white: 0.4)]
//
//    var body: some View {
//        Button(title) {
//            isOn.toggle()
//        }
//        .padding()
//        .background(LinearGradient(gradient: Gradient(colors: isOn ? onColor : offColor), startPoint: .top, endPoint: .bottom))
//        .foregroundColor(.white)
//        .clipShape(Capsule())
//        .shadow(radius: isOn ? 0 : 5)
//    }
//}

struct ContentView: View {
//    Day 53
//    //Day 53 first exercise
//    @State private var remeberMe = false
//    Day 53 second exercise
//    @AppStorage("notes") private var notes = ""
//    Day 53 third exercise - First use of CoreData in project
//    Adding propperty that describe how we hundle Student from CoreData
//    I want to use student as normal array
//    @FetchRequest(sortDescriptors: []) var students: FetchedResults<Student>
//    Adding property to adding and saving objects, where I ask for current managed object context
//    @Environment(\.managedObjectContext) var moc

    // property that store context
    @Environment(\.managedObjectContext) var moc
    // request of download from CoreData
    @FetchRequest(sortDescriptors: [SortDescriptor(\.title), SortDescriptor(\.author)]) var books: FetchedResults<Book>
    
    //property used to show screen that add book
    @State private var showingAddScreen = false
    
    var body: some View {
        //        Day 53
        //        Day 53 first exercise
        //        VStack {
        //            PushButton(title: "Remember Me", isOn: $remeberMe)
        //            Text(remeberMe ? "ON" : "OFF")
        //        }
        //        Day 53 second exercise
        //        NavigationView {
        //            TextEditor(text: $notes)
        //                .frame(width: 200, height: 200)
        //                .navigationTitle("Notes")
        //                .padding()
        //        }
        //        Day 53 third exercise
        //        VStack {
        ////            List of students in Student CoreData
        //            List(students) { student in
        //                Text(student.name ?? "Unknown")
        //            }
        //
        ////            Button that will add random Student to our Core Data
        //            Button("Add") {
        ////                Creating random student
        //                let firstName = ["Ginny", "Harry", "Hermione", "Luna", "Ron"]
        //                let lastName = ["Granger", "Lovegood", "Potter", "Weasley"]
        //
        //                let chosenFirstName = firstName.randomElement()!
        //                let chosenLastName = lastName.randomElement()!
        //
        ////                Adding student to class
        //                let student = Student(context: moc)
        //                student.id = UUID()
        //                student.name = "\(chosenFirstName) \(chosenLastName)"
        //
        ////                Saving record into CoreData Entities
        //                try? moc.save()
        //            }
        //        }
        NavigationView {
            List {
                ForEach(books) { book in
                    NavigationLink {
                        DetailView(book: book)
                    } label: {
                        HStack {
                            EmojiRatingView(rating: book.rating)
                                .font(.largeTitle)
                            
                            VStack(alignment: .leading) {
                                Text(book.title ?? "Unknown Title")
                                    .font(.headline)
                                    .foregroundColor( Int(book.rating) == 1 ? .red : .primary)
                                Text(book.author ?? "Unknown Author")
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                }
                .onDelete(perform: deleteBooks)
            }
                .navigationTitle("BookWorm")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            showingAddScreen.toggle()
                        } label: {
                            Label("Add Book", systemImage: "plus")
                        }
                    }
                    ToolbarItem(placement: .navigationBarLeading) {
                        EditButton()
                    }
                }
                .sheet(isPresented: $showingAddScreen) {
                    AddBookView()
                }
        }
    }
    
    //function to delete items from CoreData
    func deleteBooks(at offsets: IndexSet) {
        for offset in offsets {
            //finding book in fetch request
            let book = books[offset]
            
            //delete it from the context
            moc.delete(book)
        }
        
        // save the context
        try? moc.save()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView() 
    }
}
