//
//  ContentView.swift
//  WordScramble
//
//  Created by Nikolay Volosatov on 10/23/19.
//  Copyright © 2019 BX23. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State private var usedWords = [String]()
    @State private var rootWord = ""
    @State private var newWord = ""
    @State private var score = 0

    @State private var errorTitle = ""
    @State private var errorMessage = ""
    @State private var showingError = false

    func startGame() {
        guard let filePath = Bundle.main.url(forResource: "start", withExtension: "txt") else {
            fatalError("File not found")
        }
        guard let fileContent = try? String(contentsOf: filePath) else {
            fatalError("Can't read the file")
        }
        let words = fileContent.split(separator: "\n").map { s in s.trimmingCharacters(in: .whitespacesAndNewlines) }
        guard let randomWord = words.randomElement() else {
            fatalError("Can't get a random word")
        }

        usedWords = []
        rootWord = randomWord
        newWord = ""
        score = 0
    }

    func addWord() {
        let normalizedWord = newWord.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        guard normalizedWord.count != 0 else {
            return
        }
        guard runChecks(word: normalizedWord) else {
            return
        }
        usedWords.insert(normalizedWord, at: 0)
        score += normalizedWord.count
        newWord = ""
    }

    func wordError(title: String, message: String) {
        errorTitle = title
        errorMessage = message
        showingError = true
    }

    func runChecks(word: String) -> Bool {
        guard isOriginal(word: word) else {
            wordError(title: "Word used already", message: "Be more original.")
            return false
        }
        guard isLongEnough(word: word) else {
            wordError(title: "Word too short", message: "Try adding more letters.")
            return false
        }
        guard isNotSameWord(word: word) else {
            wordError(title: "Word is the same", message: "You can't use the original one.")
            return false
        }
        guard isPossible(word: word) else {
            wordError(title: "Word not recognized", message: "You can't just make them up, you know!")
            return false
        }
        guard isReal(word: word) else {
            wordError(title: "Word not possible", message: "That isn't a real word.")
            return false
        }
        return true
    }

    func isOriginal(word: String) -> Bool {
        !usedWords.contains(word)
    }

    func isLongEnough(word: String) -> Bool {
        word.count >= 3
    }

    func isNotSameWord(word: String) -> Bool {
        word != rootWord
    }

    func isPossible(word: String) -> Bool {
        var letters = rootWord.reduce(into: [Character:Int]()) { (value, ch) in
            value[ch] = (value[ch] ?? 0) + 1
        }
        for ch in word {
            if (letters[ch] ?? 0) == 0 {
                return false
            }
            letters[ch]! -= 1
        }
        return true
    }

    func isReal(word: String) -> Bool {
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: word.utf16.count)
        let misspelledRange = checker.rangeOfMisspelledWord(in: word,
                                                            range: range,
                                                            startingAt: 0,
                                                            wrap: false,
                                                            language: "en")
        return misspelledRange.location == NSNotFound
    }

    var body: some View {
        NavigationView {
            VStack {
                VStack {
                    Text("Score")
                        .font(.headline)

                    //Text("\(score)")
                    Image(systemName: "\(score).circle")
                        .font(.largeTitle)
                }
                .accessibilityElement(children: .ignore)
                .accessibility(label: Text("Your score is \(score)"))

                TextField("Enter your word", text: $newWord, onCommit: addWord)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .autocapitalization(.none)
                    .padding()

                List(usedWords, id: \.self) { word in
                    HStack {
                        Image(systemName: "\(word.count).circle")
                        Text(word)
                    }
                    .accessibilityElement(children: .ignore)
                    .accessibility(label: Text("\(word), \(word.count) letters"))
                }
                .accessibility(label: Text("List of words"))
            }
            .navigationBarTitle(rootWord)
            .onAppear(perform: startGame)
            .navigationBarItems(trailing: Button(action: startGame) {
                HStack {
                    Image(systemName: "arrow.uturn.left.circle")
                    Text("Restart")
                }
            })
            .alert(isPresented: $showingError) {
                Alert(title: Text(errorTitle), message: Text(errorMessage), dismissButton: .default(Text("OK")))
            }
            .animation(.easeIn)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
