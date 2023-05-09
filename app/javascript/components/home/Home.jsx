import React from "react";
import { Link } from "react-router-dom";
import QuestionBox from "./QuestionBox";
import { QuestionPresenter } from "./question_presenter";

const BASE_URL = 'https://shark-app-i8ino.ondigitalocean.app';
const BOOK_COVER = `/cover.png`;

const BOOK_LINK = "https://math.hws.edu/graphicsbook/";
const WEBSITE_LINK = "https://www.karo.codes/";
const GITHUB_LINK = "https://github.com/KaroCodes/YXNrbXlib29r";

const DEFAULT_QUESTION = "What is the Introduction to Computer Graphics about?";
const questionPresenter = new QuestionPresenter(BASE_URL, DEFAULT_QUESTION);

export default Home = () => {
    return (
        <div className="container">
            <div className="home">
                <div className="header">
                    <Link to={BOOK_LINK} target="_blank">
                        <img src={BOOK_COVER} loading="lazy" />
                    </Link>
                    <h1>Ask Not-My Book</h1>
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