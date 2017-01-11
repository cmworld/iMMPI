import UIKit

/// This class presents interface suitable to entering answers for the MMPI test 
/// in order starting with first and finishing with last question.
///
/// This view controller has a set of toolbar items which provide the means to enter 
/// positive/negative answers to each statement. A current statement is displayed as usual, 
/// all other (not currently selected) statements are dimmed so the attention of the user
/// is focused on a single selected statement.
final class TestAnswersInputViewController: TestAnswersTableViewControllerBase {
    @objc @IBOutlet fileprivate var answersInputView: UIView?
    fileprivate var statementIndex: Int = 0
}



extension TestAnswersInputViewController {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadQuestionnaireAsyncIfNeeded()
    }
}


extension TestAnswersInputViewController {
    fileprivate func setStatementIndex(_ index: Int) {
        guard let questionnaire = questionnaire else {
            return
        }

        if 0 <= index && index < questionnaire.statementsCount {
            statementIndex = index
            tableView?.reloadData()
            tableView?.scrollToRow(at: IndexPath(row: index, section: 0), at: .middle, animated: false)
            title = String(format: Strings.format_N_of_M, statementIndex+1, questionnaire.statementsCount)
        }
    }


    @discardableResult
    fileprivate func setPreviousStatementIndex() -> Bool {
        if statementIndex > 0 {
            setStatementIndex(statementIndex - 1)
            return true
        }
        else {
            return false
        }
    }


    @discardableResult
    fileprivate func setNextStatementIndex() -> Bool {
        guard let questionnaire = questionnaire else {
            return false
        }

        if let statement = questionnaire.statement(at: statementIndex) {
            if statementIndex < questionnaire.statementsCount - 1
                && record?.testAnswers.answer(for: statement.statementID) != .unknown {
                setStatementIndex(statementIndex + 1)
                return true
            }
        }

        return false
    }


    fileprivate func recordAnswer(_ answer: AnswerType) {
        guard let record = record else {
            return
        }

        if let statement = questionnaire?.statement(at: statementIndex) {
            setAnswer(answer, for: statement)
        }

        if false == setNextStatementIndex() {
            try? router?.displayAnalysis(for: record, sender: self)
        }
    }
}


extension TestAnswersInputViewController {
    @objc @IBAction fileprivate func prevButtonAction(_ sender: Any?) {
        setPreviousStatementIndex()
    }


    @objc @IBAction fileprivate func nextButtonAction(_ sender: Any?) {
        setNextStatementIndex()
    }


    @objc @IBAction fileprivate func negativeAnswerButtonAction(_ sender: Any?) {
        recordAnswer(.negative)
    }


    @objc @IBAction fileprivate func positiveAnswerButtonAction(_ sender: Any?) {
        recordAnswer(.positive)
    }
}


extension TestAnswersInputViewController {
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath) as! StatementTableViewCell

        let alpha: CGFloat = (statementIndex == indexPath.row) ? 1.0 : 0.125

        cell.statementIDLabel?.alpha = alpha
        cell.statementTextLabel?.alpha = alpha
        cell.statementAnswerLabel?.alpha = alpha

        return cell
    }
}
