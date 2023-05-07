import React from "react";

export default QuestionBox = ({ questionPresenter }) => {
    const [question, setQuestion] = React.useState(questionPresenter.getDefaultQuestion());
    const [answer, setAnswer] = React.useState(null);

    const onQuestionChange = React.useCallback((e) => {
        setQuestion(e.target.value);
        setAnswer(null);
    }, [setQuestion, setAnswer]);

    const onAnswerClick = React.useCallback(async () => {
        if (!question) {
            alert('Please ask a question!');
            return;
        }
        const answer = await questionPresenter.getAnswer(question);
        setAnswer(answer);
    }, [questionPresenter, question, setAnswer]);

    const onAnswerRandomQuestionClick = React.useCallback(async () => {
        const record = await questionPresenter.answerRandomQuestion();
        setQuestion(record.question);
        setAnswer(record.answer);
    }, [questionPresenter, setQuestion, setAnswer]);

    const onAskAnotherQuestionClick = React.useCallback(() => {
        setAnswer(null);
    }, [setAnswer]);

    return (
        <div className="questionbox">
            <textarea
                name="question"
                value={question}
                onChange={onQuestionChange}
            />
            {answer ? (
                <div className="answer">
                    <p><b>Answer:</b> {answer}</p>
                    <button className="secondary" onClick={onAskAnotherQuestionClick}>Ask another question</button>
                </div>
            ) : (
                <div className="buttons">
                    <button className="primary" onClick={onAnswerClick}>Ask question</button>
                    <button className="secondary" onClick={onAnswerRandomQuestionClick}>I'm feeling lucky</button>
                </div >
            )}
        </div >
    )
};
