import React from "react";
import { Link } from "react-router-dom";
import cover from "./assets/cover.png";
import QuestionBox from "./QuestionBox";
import { QuestionPresenter } from "./question_presenter";

const BOOK_LINK = "https://www.amazon.com/Minimalist-Entrepreneur-Great-Founders-More/dp/0593192397";
const WEBSITE_LINK = "https://www.karo.codes/";
const GITHUB_LINK = "https://github.com/KaroCodes/YXNrbXlib29r";

const questionPresenter = new QuestionPresenter();

export default Home = () => {
    return (
        <div className="container">
            <div className="home">
                <div className="header">
                    <Link to={BOOK_LINK} target="_blank">
                        <img src={cover} loading="lazy" />
                    </Link>
                    <h1>Ask My Book</h1>
                </div>
                <div className="main">
                    <p>This is an experiment in using AI to make my book's content more accessible. Ask a question and AI'll answer it in real-time:</p>
                    <QuestionBox questionPresenter={questionPresenter} />
                </div>
                <div className="footer">
                    <p>Project by <Link to={WEBSITE_LINK} target="_blank">KaroCodes</Link> • <Link to={GITHUB_LINK} target="_blank">Fork on GitHub</Link></p>
                </div>
            </div>
        </div>
    )
};