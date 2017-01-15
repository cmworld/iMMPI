import Foundation

extension MMPIRouter {
    final class EditingDelegate {
        weak var answersInputDelegate: TestAnswersInputDelegate?
        
        init(storage: TestRecordStorage) {
            self.storage = storage
        }

        fileprivate let storage: TestRecordStorage
    }
}


extension MMPIRouter.EditingDelegate: EditTestRecordViewControllerDelegate {
    func editTestRecordViewController(_ controller: EditTestRecordViewController,
                                      didFinishEditing record: TestRecordProtocol) {
        controller.dismiss(animated: true, completion: nil)

        if storage.contains(record) {
            storage.update(record)
        }
        else {
            storage.add(record)
        }

        NotificationCenter.default.post(
            Notification(
                name: .didEditRecord,
                object: record,
                userInfo: nil
            )
        )
    }


    func editTestRecordViewControllerDidCancel(_ controller: EditTestRecordViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
}


extension MMPIRouter.EditingDelegate: TestAnswersInputDelegate {
    func testAnswersViewController(_ controller: TestAnswersViewController,
                                   didSet answer: AnswerType,
                                   for statement: Statement,
                                   record: TestRecordProtocol) {
        answersInputDelegate?.testAnswersViewController(
            controller,
            didSet: answer,
            for: statement,
            record: record
        )
    }

    func testAnswersInputViewController(_ controller: TestAnswersViewController,
                                        didSet answers: TestAnswersProtocol,
                                        for record: TestRecordProtocol) {
        record.testAnswers = answers
        storage.update(record)
    }
}


extension Notification.Name {
    static let didEditRecord = Notification.Name(rawValue: "com.immpi.notifications.didEditRecord")
}
