//
//  AddViewController.swift
//  Notes
//
//  Created by Aleksandr Bolotov on 05.07.2022.
//

import UIKit
import Speech

class AddViewController: UIViewController {
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale.init(identifier: "ru"))
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()

    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var recordButton: UIButton! {
        didSet {
            recordButton.isEnabled = false
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupSpeechRecognizer()
    }

    @IBAction func onTapRecordButton(_ sender: Any) {
        if audioEngine.isRunning {
            audioEngine.stop()
            recognitionRequest?.endAudio()
            recordButton.isEnabled = false
            recordButton.setTitle("Начать запись", for: .normal)
        } else {
            startRecording()
            recordButton.setTitle("Остановить запись", for: .normal)
        }
    }

    private func setupSpeechRecognizer() {
        speechRecognizer?.delegate = self
        SFSpeechRecognizer.requestAuthorization { status in
            var buttonState = false

            switch status {
            case .authorized:
                buttonState = true
            case .denied, .notDetermined, .restricted:
                buttonState = false
            @unknown default:
                fatalError()
            }

            DispatchQueue.main.async {
                self.recordButton.isEnabled = buttonState
            }
        }
    }

    private func startRecording() {
        if recognitionTask != nil {
            recognitionTask?.cancel()
            recognitionTask = nil
        }

        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(AVAudioSession.Category.record)
            try audioSession.setMode(AVAudioSession.Mode.measurement)
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            fatalError("Не удалось настроить аудиосессию")
        }

        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()

        let inputNode = audioEngine.inputNode

        guard let recognitionRequest = recognitionRequest else {
            fatalError("Не могу создать экземпляр запроса")
        }

        recognitionRequest.shouldReportPartialResults = true

        recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest) { [weak self]
            result, error in

            guard let self = self else { return }

            var isFinal = false

            if result != nil {
                self.textView.text = result?.bestTranscription.formattedString
                isFinal = (result?.isFinal)!
            }

            if error != nil || isFinal {
                self.audioEngine.stop()
                inputNode.removeTap(onBus: 0)

                self.recognitionRequest = nil
                self.recognitionTask = nil

                self.recordButton.isEnabled = true
            }
        }

        let format = inputNode.outputFormat(forBus: 0)

        inputNode.installTap(onBus: 0, bufferSize: 1024, format: format) {
            buffer, _ in
            self.recognitionRequest?.append(buffer)
        }

        audioEngine.prepare()

        do {
            try audioEngine.start()
        } catch {
            fatalError("AudioEngine не запускается")
        }
    }
}

extension AddViewController: SFSpeechRecognizerDelegate {
    func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
        recordButton.isEnabled = available
    }
}
