import Foundation

extension AnalysisScore {
    /// A pair of `positive` and `negative` statement identifier collections, 
    /// which is used for raw score computation.
    typealias _RawMatchesKey = (positive: [StatementIdentifier], negative: [StatementIdentifier])

    /// Gender-based pair of `positive` and `negative` statement identifier collections,
    /// which is used for raw score computation.
    typealias RawMatchesKey = GenderBasedValue<_RawMatchesKey>

    /// A filter function used for ignoring some of the statements in the questionnaire.
    ///
    /// - Parameter identifier: identifier of the statement to check for validity.
    /// - Returns: a boolean value corresponding to whether the statement is valid or not.
    typealias StatementsFilter = (_ identifier: StatementIdentifier) -> Bool


    /// Returns a score computed by counting the number of matches between the given `TestAnswersProtocol` instance
    /// and predefined sets of positive and negative statements.
    ///
    /// - Parameters:
    ///    - statements: a gender-based pair of statement identifier collections, which are used for counting matches,
    ///    - filter:     a filter function, which eliminates invalid statements from the computation. 
    ///                  Statement identifiers are filtered before counting matches, so filtered out statements do not
    ///                  affect the computation in any way.
    ///
    /// - Returns: an `AnalysisScore` instance, which performs the computation. The returned value is a total number
    ///            of answers in the given record, which match the values provided by the `statements` parameter.
    static func raw(_ statements: RawMatchesKey,
                    filter includeStatement: @escaping StatementsFilter
                        = AnalysisScore.defaultStatementsFilter) -> AnalysisScore {
        return AnalysisScore(value: .specific({ gender in { answers in
            let selectedStatements = statements.value(for: gender)

            let positiveMatches = selectedStatements.positive
                .filter(includeStatement)
                .reduce(0, { matches, identifier in
                    return answers.answer(for: identifier) == .positive ? matches + 1 : matches
                })

            let negativeMatches = selectedStatements.negative
                .filter(includeStatement)
                .reduce(0, { matches, identifier in
                    return answers.answer(for: identifier) == .negative ? matches + 1 : matches
                })

            return Double(positiveMatches + negativeMatches)
            }}))
    }


    /// A syntactic sugar overload for raw matches computation, which is independent on the `Gender`.
    ///
    /// - Parameters:
    ///    - positive: a collection of positive statement identifiers for matching,
    ///    - negative: a collection of negative statement identifiers for matching,
    ///    - filter:   a filter function, which eliminates invalid statements from the computation.
    ///
    /// - Returns: an `AnalysisScore` instance, which performs the computation. The returned value is a total number
    ///            of answers in the given record, which match the values provided by the `positive` and `negative`
    ///            parameters.
    static func raw(positive: [StatementIdentifier],
                    negative: [StatementIdentifier],
                    filter includeStatement: @escaping StatementsFilter
                        = AnalysisScore.defaultStatementsFilter) -> AnalysisScore {
        return .raw(.common((positive: positive, negative: negative)), filter: includeStatement)
    }
}
