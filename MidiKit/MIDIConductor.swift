//
//  MIDIConductor.swift
//  MidiKit
//
//  Created by   imac on 06.11.2022.
//

import AudioKit
import CoreMIDI
import SwiftUI

class MIDIMonitorConductor: ObservableObject, HasAudioEngine {
    
    struct MIDIMonitorData {
        var noteOn = 0
        var velocity = 0
        var noteOff = 0
        var channel = 0
        var afterTouch = 0
        var afterTouchNoteNumber = 0
        var programChange = 0
        var pitchWheelValue = 0
        var controllerNumber = 0
        var controllerValue = 0
    }
    
    @Published var data = MIDIMonitorData()
    
    let midi = MIDI()
    let engine = AudioEngine()
    var instrument = MIDISampler(name: "Instrument 1")

    init() {
        engine.output = instrument
        midi.openInput()
        midi.addListener(self)
        
        // Load EXS file, SoundFonts or WAV files
        do {
            if let fileURL = Bundle.main.url(
                forResource: "Sounds/Samples/sawPiano",
                withExtension: "exs"
            ) {
                try instrument.loadInstrument(url: fileURL)
            } else { Log("❌ Could not find file") }
        }
        catch { Log("❌ Could not load instrument") }
        
        do { try engine.start() }
        catch { Log("❌ AudioKit did not start!") }
        midi.openOutput()
    }

    func stop() {
        engine.stop()
        midi.closeAllInputs()
        midi.clearListeners()
    }

}
