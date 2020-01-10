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
                Text("\(self.tagToEdit.name)")
                
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
            if self.tagToEdit.books.contains(book.id) {
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
    
    func onChecklistSubmit() {
        for book in self.bookChecklist {
            print(String(book.identifier!), book.content, book.isChecked)
        }
    }
    
    func unBuildBookChecklist() {
        // assign correct book ids to self.tagToEdit based on checklist
        for book in self.bookChecklist {
            
            let alreadyOnTag = self.tagToEdit.books.contains(book.identifier!)
            
            if book.isChecked && !alreadyOnTag {
                self.tagToEdit.books.append(book.identifier!)
            } else if !book.isChecked {
                // remove any unchecked books from tagToEdit
                if let index = self.tagToEdit.books.firstIndex(of: book.identifier!) {
                    self.tagToEdit.books.remove(at: index)
                }
            }
        }
    }
    
    func editTag() {
        self.onChecklistSubmit() // should print current checklist values
        self.unBuildBookChecklist()
        print("TAG'S BOOKS:", self.tagToEdit.books)
        
        // make PUT to update tag
        let response = APIHelper.putTag(
            token: self.env.user.token,
            tagName: self.env.tag.name,
            newTagName: self.tagToEdit.name,
            books: self.tagToEdit.books)
        
        let old_name = self.env.tag.name
        if response["success"] != nil {
            if let newTag = EncodingHelper.makeTag(data: response["success"]!) {
                print("I'M BACK WITH:", newTag, newTag.name, newTag.books)
                            
                // update tag in environment
                DispatchQueue.main.async {
                    self.env.tag = newTag
                }
                
                // find tag in main taglist
                let tempTagList = self.env.tagList
                if let index = self.env.tagList.tags.firstIndex(where: {$0.name == old_name}) {
                    tempTagList.tags[index] = newTag
                    DispatchQueue.main.async {
                        self.env.tagList = tempTagList
                    }
                    
                    let tempBookList = BookList(bookList: self.env.bookList)
                    let updatedTagBooks = newTag.books
                    for book in tempBookList.books {
                        // if any of the books have the old tag name
                        if let index = book.tags.firstIndex(where: {$0 == old_name}) {
                            // is their id in the new tag's book list?
                            // if yes, update the tag name
                            if updatedTagBooks.contains(book.id) {
                                book.tags[index] = newTag.name
                            }
                            // if not, remove the tag from the book
                            else {
                                book.tags.remove(at: index)
                            }
                        } else if newTag.books.contains(book.id) { // the un-tagged book is in the new tag's list
                            // add the tag to this book
                            book.tags.append(newTag.name)
                        }
                    }
                    
                    DispatchQueue.main.async {
                        self.env.bookList = tempBookList
                    }
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
        books: [1])
    static var tagToEdit = TagList.Tag(name: "fantasy", books: [1])
    
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
        tag: tag1)
    
    static var previews: some View {
        EditTagForm(showForm: self.$showForm, tagToEdit: self.tagToEdit)
            .environmentObject(self.env)
    }
}
