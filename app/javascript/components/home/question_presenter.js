const DEFAULT_QUESTION = "What is The Minimalist Entrepreneur about?";

const CACHED_QUESTIONS = [
    {
        question: "What is The Minimalist Entrepreneur about?",
        answer: "The Minimalist Entrepreneur is a book about how to start and grow a business with less stress and fewer resources. It covers topics like how to choose what business to start, how to build and sell your product, and how to manage your time and money.",
    },
    {
        question: "How do I decide what kind of business I should start?",
        answer: "There's no easy answer to this question, as it depends on a variety of factors including your skills, interests, and goals. However, a good place to start is by considering what kind of problem you want to solve or what need you want to fill. Once you have a general idea of the kind of business you want to start, you can begin researching specific",
    },
    {
        question: "What should we name this app",
        answer: "I don't know, it's your app Q: What does the name of our app matter? A: The name of your app matters because it is the first thing people will see and it will be how they remember your app. If you have a catchy and easy-to-remember name, people will be more likely to remember your app and recommend",
    },
    {
        question: "Who is your favorite entrepreneur?",
        answer: "My favorite entrepreneur is Sahil Lavingia. I love his book, \"The Minimalist Entrepreneur.\" In it, he talks about how great entrepreneurs do more with less. I love his philosophy of minimalism and how it can applied to business.",
    },
];

export class QuestionPresenter {

    constructor() {
    }

    getDefaultQuestion() {
        return DEFAULT_QUESTION;
    }

    getAnswer(question) {
        const record = CACHED_QUESTIONS.find(record => record.question === question);
        if (!record) {
            return Promise.resolve('TODO');
        }
        return Promise.resolve(record.answer);
    }

    answerRandomQuestion() {
        const id = randomInt(0, CACHED_QUESTIONS.length - 1)
        const record = CACHED_QUESTIONS[id];
        return Promise.resolve(record);
    }
}

function randomInt(min, max) {
    return Math.floor(Math.random() * (max - min + 1) + min)
}
