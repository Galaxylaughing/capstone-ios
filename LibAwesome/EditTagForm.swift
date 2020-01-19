//
//  EditTagForm.swift
//  LibAwesome
//
//  Created by Sabrina on 1/9/20.
//  Copyright © 2020 SabrinaLowney. All rights reserved.
//

import SwiftUI

struct EditTagForm: View {
    @Binding var showForm: Bool
    @EnvironmentObject var env: Env
    
    @State private var error: ErrorAlert?
    
    // holds the form's version of the info about the env tag
    @State var tagToEdit: TagList.Tag
    @State var bookChecklist: [CheckListItem] = []
    
    
    fileprivate func saveButton() -> some View {
        return Button(action: { self.editTag() }) {
            Text("Save Tag")
        }
            // disable if no title or authors
            .disabled(self.tagToEdit.name == "" || self.tagToEdit.books.count == 0)
            .alert(item: $error, content: { error in
                AlertHelper.alert(reason: error.reason)
            })
    }
    
    fileprivate func cancelButton() -> some View {
        return Button(action: { self.showForm = false }) {
            Text("Cancel")
        }
    }
    
    var body: some View {
        NavigationView {
            VStack {
                Text("\(self.tagToEdit.displayName())")
                
                Form {
                    Section(header: Text("tag name")) {
                        TextField("tag", text: $tagToEdit.name)
                            .lineLimit(nil)
                            .autocapitalization(.none)
                    }
                    
                    BookUpdate( bookChecklist: self.$bookChecklist )
                }
            }
            .navigationBarTitle("Update Tag", displayMode: .inline)
            .navigationBarItems(leading: cancelButton(), trailing: saveButton())
        }
        .onAppear(perform: {self.buildBookChecklist()})
    }
    
    func buildBookChecklist() {
        var checklist: [CheckListItem] = []
        // convert env books to checklist items
        for book in self.env.bookList.books {
            // determine if they should be checked or not by comparing with tagToEdit's books
            var isChecked: Bool = false
            if self.tagToEdit.books.contains(book) {
                isChecked = true
            }
            let checklistitem = CheckListItem(
                isChecked: isChecked,
                content: book.title,
                identifier: book.id)
            checklist.append(checklistitem)
        }
        // sort checklist alphabetically
        let alphaChecklist = checklist.sorted(by: {$0 < $1})
        self.bookChecklist = alphaChecklist
    }
    
    func unBuildBookChecklist() -> [Int] {
        // assign correct book ids based on checklist
        var bookIds = self.tagToEdit.bookIds()
        for book in self.bookChecklist {
            let alreadyOnTag = bookIds.contains(book.identifier!)
            
            if book.isChecked && !alreadyOnTag {
                bookIds.append(book.identifier!)
            } else if !book.isChecked {
                // remove any unchecked books from tagToEdit
                if let index = bookIds.firstIndex(of: book.identifier!) {
                    bookIds.remove(at: index)
                }
            }
        }
        return bookIds
    }
    
    func editTag() {
        let newBookIds = self.unBuildBookChecklist()
        print("TAG'S BOOKS:", newBookIds)
        
        let cleanTagName = EncodingHelper.encodeTagName(tagName: self.env.tagToEdit.name)
        let cleanNewTagName = EncodingHelper.encodeTagName(tagName: self.tagToEdit.name)
        
        print("ENV.TAGTOEDIT: \(cleanTagName)")
        print("SELF.TAGTOEDIT: \(cleanNewTagName)")
        
        // make PUT to update tag
        let response = APIHelper.putTag(
            token: self.env.user.token,
            tagName: cleanTagName,
            newTagName: cleanNewTagName,
            books: newBookIds)
        
        if response["success"] != nil {
            // ensure all the books have the correct tags
            let newUncleanTagName = self.tagToEdit.name
            let newTagName = cleanNewTagName

            CallAPI.getBooksAndTags(env: self.env)
            
            // check the books that need to have the tag
            // build tag's book list from book ids
            var taggedBooks: [BookList.Book] = []
            for bookId in newBookIds {
                if let index = self.env.bookList.books.firstIndex(where: {$0.id == bookId}) {
                    let foundBook = self.env.bookList.books[index]
                    if !foundBook.tags.contains(newTagName) {
                        foundBook.tags.append(newTagName)
                    }
                    taggedBooks.append(foundBook)
                }
            }
            let newTagToEdit = TagList.Tag(name: newUncleanTagName, books: taggedBooks)
            print("I'M BACK WITH: \(newTagToEdit) \(newTagToEdit.name)")
            for book in newTagToEdit.books {
                print("-- \(book.title)")
            }
            
            var currentBookList = self.env.tag.books
            for book in taggedBooks {
                if !currentBookList.contains(book) {
                    currentBookList.append(book)
                }
            }
            for (index, book) in currentBookList.enumerated() {
                if !taggedBooks.contains(book) {
                    print("book", book, book.title)
                    // potentially could be deleted
                    var hasPrefix: Bool = false
                    for tag in book.tags {
                        print("tag", tag)
                        // does the tag have the prefix
                        let prefix = cleanTagName + "__" // check for old tag name + __
                        if tag.hasPrefix(prefix) {
                            hasPrefix = true
                            break
                        }
                    }
                    if !hasPrefix {
                        // remove book from current book list
                        currentBookList.remove(at: index)
                    }
                }
            }
            let newTag = TagList.Tag(name: newUncleanTagName, books: currentBookList)
                            
            // update tag in environment
            DispatchQueue.main.async {
                self.env.tagToEdit = newTagToEdit
                self.env.tag = newTag
                
                if newTag.books.count == 0 {
                    NavView.goBack(env: self.env)
                }
            }
            
            // should dismiss sheet if success
            self.showForm = false
        } else if response["error"] != nil {
            // should pop up error if failure
            self.error = ErrorAlert(reason: response["error"]!)
        } else {
            self.error = ErrorAlert(reason: "Unknown error")
        }
        
    }
    
}

struct EditTagForm_Previews: PreviewProvider {
    @State static var showForm = true
    
    static var tag1 = TagList.Tag(
        name: "fantasy",
        books: [exampleBook])
    static var tagToEdit = TagList.Tag(name: "fantasy", books: [exampleBook])
    
    static var exampleBook = BookList.Book(
        id: 1,
        title: "Good Omens",
        authors: [
            "Neil Gaiman",
            "Terry Pratchett",
    ])
    static var tagList = TagList(tags: [tag1])
    static var env = Env(
        user: Env.defaultEnv.user,
        bookList: Env.defaultEnv.bookList,
        authorList: Env.defaultEnv.authorList,
        seriesList: Env.defaultEnv.seriesList,
        tagList: tagList,
        tag: tag1,
        tagToEdit: Env.defaultEnv.tagToEdit)
    
    static var previews: some View {
        EditTagForm(showForm: self.$showForm, tagToEdit: self.tagToEdit)
            .environmentObject(self.env)
    }
}
