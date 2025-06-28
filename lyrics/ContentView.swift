//
//  ContentView.swift
//  lyrics
//
//  Created by hery on 20/06/25.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.colorScheme) private var colorScheme  // Add this line here at the top with other state variables
    
    @State private var currentLyric = 0
    @State private var lyrics = [
        "I'd like to make myself believe.........",
        "That planet Earth.........",
        "turns slowly",
        "it's hard to say that I'd rather stay awake",
        "when I'm asleep",
        "Cause everything is never as it seems",
        "When I fall asleep"
    ]
    @State private var displayedText = ""
    @State private var typingSpeed = 0.08
    @State private var isTyping = false
    @State private var isStarted = false
    @State private var lyricDisplayTime: Double = 0.5
    
    // Music player states
    @State private var isPlaying = false
    @State private var currentTime: Double = 30
    @State private var totalTime: Double = 180
    @State private var volume: Double = 0.7
    
    // Timer for auto progression
    @State private var autoProgressTimer: Timer?

    var body: some View {
        VStack {
            Spacer()
            
            // Lyrics Display
            lyricsView
            
            Spacer()
            
            // Music Player
            musicPlayerView
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(colorScheme == .dark ? Color.black.opacity(0.9) : Color.gray.opacity(0.1))
        .onTapGesture {
            if isStarted {
                nextLyric()
            }
        }
        .onDisappear {
            // Clean up timers when view disappears
            autoProgressTimer?.invalidate()
            autoProgressTimer = nil
        }
    }
    
    // MARK: - View Components
    private var lyricsView: some View {
        Text(displayedText)
            .font(.custom("PixelifySans-Regular", size: 28))
            .foregroundColor(colorScheme == .dark ? .white : .black)
            .frame(maxWidth: .infinity, alignment: .center)
            .padding(20)
            .lineLimit(nil)
            .multilineTextAlignment(.center)
    }
    
    private var musicPlayerView: some View {
        VStack(spacing: 16) {
            songInfoView
            progressBarView
            controlButtonsView
            volumeControlView
        }
        .padding(24)
        .background(playerBackgroundView)
        .padding(.horizontal, 20)
        .padding(.bottom, 40)
    }
    
    private var songInfoView: some View {
        VStack(spacing: 8) {
            Text("♪ Fireflies ♪")
                .font(.custom("PixelifySans-Regular", size: 18))
                .fontWeight(.semibold)
                .foregroundColor(colorScheme == .dark ? .white : .black)
            Text("Owl City")
                .font(.custom("PixelifySans-Regular", size: 14))
                .foregroundColor(colorScheme == .dark ? .gray.opacity(0.8) : .gray)
        }
        .padding(.top, 8)
    }
    
    private var progressBarView: some View {
        VStack(spacing: 8) {
            HStack(spacing: 2) {
                ForEach(0..<15, id: \.self) { index in
                    progressBlock(index: index)
                }
            }
            
            HStack {
                Text(timeString(from: currentTime))
                    .font(.custom("PixelifySans-Regular", size: 12))
                    .foregroundColor(colorScheme == .dark ? .white : .black)
                Spacer()
                Text(timeString(from: totalTime))
                    .font(.custom("PixelifySans-Regular", size: 12))
                    .foregroundColor(colorScheme == .dark ? .white : .black)
            }
            .padding(.horizontal, 8)
        }
    }
    
    private func progressBlock(index: Int) -> some View {
        RoundedRectangle(cornerRadius: 2)
            .fill(Double(index) < (currentTime / totalTime * 15) ? Color.green : (colorScheme == .dark ? Color.gray.opacity(0.5) : Color.gray.opacity(0.3)))
            .frame(width: 16, height: 6)
            .overlay(
                RoundedRectangle(cornerRadius: 2)
                    .stroke(colorScheme == .dark ? Color.white.opacity(0.2) : Color.black.opacity(0.2), lineWidth: 0.5)
            )
    }
    
    private var controlButtonsView: some View {
        HStack(spacing: 25) {
            previousButton
            playPauseButton
            nextButton
        }
    }
    
    private var previousButton: some View {
        Button(action: previousTrack) {
            RoundedRectangle(cornerRadius: 8)
                .fill(colorScheme == .dark ? Color.gray.opacity(0.3) : Color.white)
                .frame(width: 44, height: 44)
                .overlay(
                    Text("◄◄")
                        .font(.custom("PixelifySans-Regular", size: 16))
                        .foregroundColor(colorScheme == .dark ? .white : .black)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(colorScheme == .dark ? Color.white.opacity(0.2) : Color.black.opacity(0.3), lineWidth: 1)
                )
                .shadow(color: colorScheme == .dark ? .white.opacity(0.05) : .black.opacity(0.1), radius: 2, x: 1, y: 1)
        }
    }
    
    private var playPauseButton: some View {
        let buttonBackground = RoundedRectangle(cornerRadius: 12)
            .fill(isPlaying ?
                  (colorScheme == .dark ? Color.red.opacity(0.3) : Color.red.opacity(0.1)) :
                  (colorScheme == .dark ? Color.green.opacity(0.3) : Color.green.opacity(0.1)))
            .frame(width: 56, height: 56)
        
        let buttonText = Text(isPlaying ? "■" : "►")
            .font(.custom("PixelifySans-Regular", size: 24))
            .foregroundColor(isPlaying ? Color.red : Color.green)
        
        let buttonBorder = RoundedRectangle(cornerRadius: 12)
            .stroke(isPlaying ? Color.red.opacity(0.4) : Color.green.opacity(0.4), lineWidth: 2)
        
        let buttonShadow = buttonBackground
            .overlay(buttonText)
            .overlay(buttonBorder)
            .shadow(color: colorScheme == .dark ? .white.opacity(0.05) : .black.opacity(0.15), radius: 3, x: 2, y: 2)
        
        return Button(action: togglePlayPause) {
            buttonShadow
        }
    }
    
    private var nextButton: some View {
        Button(action: nextTrack) {
            RoundedRectangle(cornerRadius: 8)
                .fill(colorScheme == .dark ? Color.gray.opacity(0.3) : Color.white)
                .frame(width: 44, height: 44)
                .overlay(
                    Text("►►")
                        .font(.custom("PixelifySans-Regular", size: 16))
                        .foregroundColor(colorScheme == .dark ? .white : .black)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(colorScheme == .dark ? Color.white.opacity(0.2) : Color.black.opacity(0.3), lineWidth: 1)
                )
                .shadow(color: colorScheme == .dark ? .white.opacity(0.05) : .black.opacity(0.1), radius: 2, x: 1, y: 1)
        }
    }
    
    private var volumeControlView: some View {
        VStack(spacing: 6) {
            HStack {
                Text("Volume")
                    .font(.custom("PixelifySans-Regular", size: 12))
                    .foregroundColor(colorScheme == .dark ? .white : .black)
                
                HStack(spacing: 1) {
                    ForEach(0..<8, id: \.self) { index in
                        volumeBlock(index: index)
                    }
                }
                
                Text("♪")
                    .font(.custom("PixelifySans-Regular", size: 12))
                    .foregroundColor(colorScheme == .dark ? .white : .black)
            }
            
            Slider(value: $volume, in: 0...1)
                .opacity(0.01)
                .frame(height: 16)
        }
    }
    
    private func volumeBlock(index: Int) -> some View {
        let fillColor = Double(index) < (volume * 8) ?
                       (colorScheme == .dark ? Color.blue.opacity(0.9) : Color.blue.opacity(0.7)) :
                       (colorScheme == .dark ? Color.gray.opacity(0.4) : Color.gray.opacity(0.2))
        
        let block = RoundedRectangle(cornerRadius: 1)
            .fill(fillColor)
            .frame(width: 12, height: 8)
        
        let borderColor = colorScheme == .dark ? Color.white.opacity(0.2) : Color.black.opacity(0.2)
        let border = RoundedRectangle(cornerRadius: 1)
            .stroke(borderColor, lineWidth: 0.5)
        
        return block.overlay(border)
    }
    
    private var playerBackgroundView: some View {
        RoundedRectangle(cornerRadius: 16)
            .fill(colorScheme == .dark ? Color.black.opacity(0.7) : Color.white)
            .overlay(paperTextureOverlay)
            .overlay(borderOverlay)
            .shadow(color: colorScheme == .dark ? .white.opacity(0.05) : .black.opacity(0.15), radius: 8, x: 0, y: 4)
    }
    
    private var paperTextureOverlay: some View {
        RoundedRectangle(cornerRadius: 16)
            .fill(
                LinearGradient(
                    gradient: Gradient(colors: [
                        colorScheme == .dark ? Color.gray.opacity(0.1) : Color.white,
                        colorScheme == .dark ? Color.black.opacity(0.4) : Color.gray.opacity(0.05),
                        colorScheme == .dark ? Color.gray.opacity(0.1) : Color.white
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
    }
    
    private var borderOverlay: some View {
        RoundedRectangle(cornerRadius: 16)
            .stroke(colorScheme == .dark ? Color.white.opacity(0.1) : Color.black.opacity(0.1), lineWidth: 1)
    }
    
    // MARK: - Music Player Functions
    func togglePlayPause() {
        isPlaying.toggle()
        if isPlaying {
            if !isStarted {
                isStarted = true
                currentLyric = 0
                showLyric(currentLyric)
            }
            startProgressTimer()
        } else {
            autoProgressTimer?.invalidate()
            autoProgressTimer = nil
        }
    }
    
    func previousTrack() {
        if currentLyric > 0 {
            currentLyric -= 1
        } else {
            currentLyric = lyrics.count - 1
        }
        
        if isStarted {
            autoProgressTimer?.invalidate()
            showLyric(currentLyric)
        }
    }
    
    func nextTrack() {
        if isStarted {
            nextLyric()
        }
    }
    
    func startProgressTimer() {
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            if isPlaying && currentTime < totalTime {
                currentTime += 1
            } else {
                timer.invalidate()
            }
        }
    }
    
    func timeString(from timeInterval: Double) -> String {
        let minutes = Int(timeInterval) / 60
        let seconds = Int(timeInterval) % 60
        return String(format: "%d:%02d", minutes, seconds)
    }
    
    // MARK: - Lyrics Functions
    func showLyric(_ index: Int) {
        guard index >= 0 && index < lyrics.count else { return }
        displayedText = ""
        isTyping = true
        typeWriter(lyrics[index], index: 0)
    }

    func typeWriter(_ text: String, index: Int) {
        guard index < text.count else {
            isTyping = false
            if isPlaying {
                startAutoProgression()
            }
            return
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + typingSpeed) {
            displayedText += String(text[text.index(text.startIndex, offsetBy: index)])
            typeWriter(text, index: index + 1)
        }
    }
    
    func startAutoProgression() {
        autoProgressTimer?.invalidate()
        
        autoProgressTimer = Timer.scheduledTimer(withTimeInterval: lyricDisplayTime, repeats: false) { _ in
            if isPlaying && isStarted {
                nextLyric()
            }
        }
    }

    func nextLyric() {
        autoProgressTimer?.invalidate()
        autoProgressTimer = nil
        
        if isTyping {
            displayedText = lyrics[currentLyric]
            isTyping = false
            if isPlaying {
                startAutoProgression()
            }
        } else {
            currentLyric = (currentLyric + 1) % lyrics.count
            showLyric(currentLyric)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()
                .preferredColorScheme(.light)
                .previewDisplayName("Light Mode")
            
            ContentView()
                .preferredColorScheme(.dark)
                .previewDisplayName("Dark Mode")
        }
    }
}
