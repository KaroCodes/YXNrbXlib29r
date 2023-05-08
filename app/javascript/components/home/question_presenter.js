import axios from 'axios';

export class QuestionPresenter {

    constructor(baseUrl, defaultQuestion) {
        this.baseUrl = baseUrl;
        this.defaultQuestion = defaultQuestion;
    }

    getDefaultQuestion() {
        return this.defaultQuestion;
    }

    async getAnswer(question) {
        const queryParams = new URLSearchParams({ question })
        const askQuestionUrl = `${this.baseUrl}/ask?${queryParams.toString()}`
        return axios.get(askQuestionUrl).then((res) => res.data.answer);
    }

    async answerRandomQuestion() {
        const randomQuestionUrl = `${this.baseUrl}/random`
        return axios.get(randomQuestionUrl).then((res) => res.data);
    }
}
