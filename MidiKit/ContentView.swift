//
//  ContentView.swift
//  MidiKit
//
//  Created by   imac on 06.11.2022.
//

import SwiftUI
import AudioKit


enum KeyType {
    case white, black
}

struct ContentView: View {
    
    @StateObject var conductor = MIDIMonitorConductor()
    
    var body: some View {
        let pressedKey = conductor.data.noteOn
        let untouchedKey = conductor.data.noteOff
        
        VStack(alignment: .trailing, spacing: 30) {
            VStack {
                Text("Note on: \(conductor.data.noteOn)")
                Text("Velocity: \(conductor.data.velocity)")
            }
            
            Text("noteOff: \(conductor.data.noteOff)")
            
            Text("pitchWheelValue: \(conductor.data.pitchWheelValue)")
            
            Text("controllerValue: \(conductor.data.controllerValue)")
            
            
            Keyboard(conductor: conductor, keyOn: pressedKey, keyOff: untouchedKey)
            
        }
        .font(.title)
        .padding()
        .onAppear { conductor.start() }
        .onDisappear { conductor.stop() }
    }
}

struct Keyboard: View {
    
    @State var blackKeys = [Int]()
    @ObservedObject var conductor: MIDIMonitorConductor
    
    let keyOn: Int
    let keyOff: Int
    
    
    var body: some View {
        
        HStack(alignment: .top, spacing: 0) {
            ForEach(0..<49) { note in
                if blackKeys.contains(note) {
                    Key(note, isPressed: note == keyOn, type: .black)
                } else {
                    Key(note, isPressed: note == keyOn, type: .white)
                }
            }
        }.onAppear { blackKeys = getBlack() }
    }
    
    
    func Key(_ note: Int, isPressed: Bool, type: KeyType) -> some View {
        Rectangle()
            .frame(width: 25, height: 130)
            .foregroundColor(isPressed ? .red : type == .white ? .white : .black)
            .border(.black, width: 1)
            .gesture(DragGesture(minimumDistance: 0, coordinateSpace: .local).onChanged { _ in
                conductor.instrument.play(noteNumber: MIDINoteNumber(note), velocity: 90, channel: 0)
            }.onEnded { _ in
                conductor.instrument.stop(noteNumber: MIDINoteNumber(note), channel: 0)
            })
       
    }
    
    private func getBlack() -> [Int] {
        var temp = [Int]()
        var key = 1
        temp.append(key)
        
        while key < 88 {
            key += 3
            temp.append(key)
            key += 2
            temp.append(key)
            key += 3
            temp.append(key)
            key += 2
            temp.append(key)
            key += 2
            temp.append(key)
        }
        
        return temp
    }
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}







