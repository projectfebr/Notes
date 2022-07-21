//
//  AddViewController.swift
//  Notes
//
//  Created by Aleksandr Bolotov on 05.07.2022.
//

import UIKit
import Speech
import CoreData

class AddViewController: UIViewController {
    enum Constants {
        static let alertSuccesTitle = "Выполнено"
        static let alertSuccesMessage = "Заметка создана"
        static let alertFailureTitle = "Ошибка"
        static let alertFailureMessage = "Не удалось создать заметку"
        static let removeSpaces = "Удалить пробелы"
        static let removeDots = "Удалить точки"
        static let removeCommas = "Удалить запятые"
        static let badFormatter = "Форматтер с nil"
        static let ok = "Ок"
        static let cancel = "Отменить"
    }

    private let speechRecognizer = SFSpeechRecognizer(locale: Locale.init(identifier: "ru"))
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()
    private var imagePicker: ImagePicker!
    private var textFormatter: TextFormatterProtocol?

    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var recordButton: UIButton! {
        didSet {
            recordButton.isEnabled = false
        }
    }
    @IBOutlet weak var imageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupSpeechRecognizer()
        imagePicker = ImagePicker(presentationController: self, delegate: self)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Создать", style: .plain, target: self, action: #selector(saveNote))
#if DEBUG
        textView.text = """
        Du (du hast, du hast, du hast, du hast).
        Hast viel geweint (geweint,  geweint,     geweint,  geweint).
        Im Geist getrennt (getrennt,  getrennt,     getrennt,  getrennt).
        Im Herz vereint (vereint, vereint, vereint, vereint).
        Wir (wir sind, wir sind, wir sind, wir sind)
        Sind schon sehr lang zusammen (ihr seid, ihr seid, ihr seid, ihr seid),
        Dein Atem kalt (so kalt, so kalt, so kalt, so kalt),
        Das Herz in Flammen (so heiß, so heiß, so heiß, so heiß).
        Du (du kannst, du kannst, du kannst, du kannst),
        Ich (ich weiß, ich weiß, ich weiß, ich weiß),
        Wir (wir sind, wir sind, wir sind, wir sind),
        Ihr (ihr bleibt, ihr bleibt, ihr bleibt, ihr bleibt).

        Deutschland! Mein Herz in Flammen,
        Will dich lieben und verdammen.
        Deutschland! Dein Atem kalt,
        So jung, und doch so alt.
        Deutschland!
        """
#endif
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
    @IBAction func onTapFormatButton(_ sender: Any) {
        showActionSheetWithFormatOptions()
    }
    @IBAction func onTapImageButton(_ sender: UIButton) {
        imagePicker.present(from: sender)
    }

    @objc func saveNote() {
        let note = Note(image: imageView.image, date: Date(), text: textView.text)
        do {
            try StorageService.save(note: note)
            showInfoAlert(withTitle: Constants.alertSuccesTitle, withMessage: Constants.alertSuccesMessage)
        } catch {
            showInfoAlert(withTitle: Constants.alertFailureTitle, withMessage: Constants.alertFailureMessage)
        }
    }

    private func showInfoAlert(withTitle title: String, withMessage mesasage: String) {
        let alert = UIAlertController(title: title, message: mesasage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: Constants.ok, style: .default))
        self.present(alert, animated: true)
    }

    private func showActionSheetWithFormatOptions() {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

        actionSheet.addAction(UIAlertAction(title: Constants.removeSpaces, style: .default, handler: { [unowned self] _ in
            self.textFormatter = RemoveSpacesTextFormatter.init(onFormatDate: updateTextView)
            self.formatTextView()
        }))
        actionSheet.addAction(UIAlertAction(title: Constants.removeDots, style: .default, handler: { [unowned self] _ in
            self.textFormatter = RemoveDotsTextFormatter.init(onFormatDate: updateTextView)
            self.formatTextView()
        }))
        actionSheet.addAction(UIAlertAction(title: Constants.removeCommas, style: .default, handler: { [unowned self] _ in
            self.textFormatter = RemoveCommasTextFormatter.init(onFormatDate: updateTextView)
            self.formatTextView()
        }))
        actionSheet.addAction(UIAlertAction(title: Constants.badFormatter, style: .default, handler: { [unowned self] _ in
            self.textFormatter = BadTextFormatter.init(onFormatDate: updateTextView)
            self.formatTextView()
        }))
        actionSheet.addAction(UIAlertAction(title: Constants.cancel, style: .cancel))
        self.present(actionSheet, animated: true)
    }

    private func formatTextView() {
        textFormatter?.format(text: textView.text)
    }

    private func updateTextView(_ text: String?) {
        guard let text = text else {
            showInfoAlert(withTitle: "Оiибка форматтера", withMessage: "В onFormateDate пришел nil")
            return
        }
        textView.text = text
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

//MARK: Implements SFSpeechRecognizerDelegate
extension AddViewController: SFSpeechRecognizerDelegate {
    func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
        recordButton.isEnabled = available
    }
}

//MARK: Implements ImagePickerDelegate
extension AddViewController: ImagePickerDelegate {
    func didSelect(image: UIImage?) {
        imageView.image = image
    }
}
