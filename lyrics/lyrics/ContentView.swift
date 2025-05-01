//
//  ContentView.swift
//  lyrics
//
//  Created by MacBook on 22/04/25.
//

import SwiftUI

struct ContentView: View {
    @State private var currentLyric = 0
    @State private var lyrics = [
        "without a doubt, I say you're the one who understands me best",
        "two become one",
        "split my heart",
        "i want to move forward, just waiting for the right time",
        "i feel what you’re feeling",
        "without a doubt, I say you're the one who understands me best",
        "two become one",
        "split my heart",
        "i want to move forward, just waiting for the right time"
    ]
    @State private var displayedText = ""
    @State private var typingSpeed = 0.1
    @State private var isTyping = false
    @State private var isStarted = false // Menambahkan state untuk melacak apakah tombol mulai sudah ditekan

    var body: some View {
        VStack {
            
            Spacer()
            
            Text(displayedText)
                .font(.custom("PixelifySans-Regular", size: 28))  // Gunakan font kustom di sini
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(20)
                .lineLimit(nil)
                .multilineTextAlignment(.center)
                .onAppear {
                    if isStarted {
                        showLyric(currentLyric)
                    }
                }
            
            Spacer()
            
            if !isStarted { // Jika belum dimulai, tampilkan tombol mulai
                Button(action: startLyrics) {
                    Text("start")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.gray.opacity(0.1))
        .onTapGesture {
            if isStarted { // Lanjutkan ke lirik selanjutnya hanya jika sudah dimulai
                nextLyric()
            }
        }
    }
    
    func startLyrics() {
        isStarted = true
        showLyric(currentLyric)
    }
    
    func showLyric(_ index: Int) {
        guard index < lyrics.count else { return }
        displayedText = ""
        isTyping = true
        typeWriter(lyrics[index], index: 0)
    }

    func typeWriter(_ text: String, index: Int) {
        guard index < text.count else {
            isTyping = false
            return
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + typingSpeed) {
            displayedText += String(text[text.index(text.startIndex, offsetBy: index)])
            typeWriter(text, index: index + 1)
        }
    }

    func nextLyric() {
        if isTyping {
            displayedText = lyrics[currentLyric]
            isTyping = false
        } else {
            currentLyric = (currentLyric + 1) % lyrics.count
            showLyric(currentLyric)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
