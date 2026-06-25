from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
import json
import random

app = FastAPI()

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

with open("questions.json", "r") as file:
    questions_db = json.load(file)

role_mapping = {
    "Software Engineer": "Software Engineer",
    "Frontend Developer": "Software Engineer",
    "Backend Developer": "Software Engineer",
    "Full Stack Developer": "Software Engineer",
    "Flutter Developer": "Software Engineer",
    "Android Developer": "Software Engineer",
    "iOS Developer": "Software Engineer",
    "Python Developer": "Software Engineer",
    "Java Developer": "Software Engineer",
    "C++ Developer": "Software Engineer",

    "Data Analyst": "Data Analyst",
    "Data Scientist": "Data Analyst",
    "Machine Learning Engineer": "Data Analyst",
    "AI Engineer": "Data Analyst",
    "Business Analyst": "Data Analyst",
    "Product Manager": "Data Analyst",

    "Cybersecurity Analyst": "Ethical Hacker",
    "Ethical Hacker": "Ethical Hacker",
    "Network Engineer": "Ethical Hacker",
    "System Administrator": "Ethical Hacker",

    "Cloud Engineer": "Software Engineer",
    "AWS Engineer": "Software Engineer",
    "DevOps Engineer": "Software Engineer",
    "Site Reliability Engineer": "Software Engineer",

    "Database Administrator": "Software Engineer",
    "QA Engineer": "Software Engineer",
    "Test Engineer": "Software Engineer",

    "UI/UX Designer": "Software Engineer",
    "Blockchain Developer": "Software Engineer",
    "Game Developer": "Software Engineer",
    "Embedded Systems Engineer": "Software Engineer"
}

hr_pool = [
    "Tell me about yourself.",
    "Why should we hire you?",
    "What are your strengths?",
    "What are your weaknesses?",
    "Describe a challenge you faced and how you solved it.",
    "How do you handle pressure?",
    "Why do you want to work for our company?",
    "Where do you see yourself in 5 years?",
    "Tell me about a time you worked in a team.",
    "How do you manage deadlines?",
    "What motivates you?",
    "How do you handle criticism?",
    "Tell me about your biggest achievement.",
    "Describe a conflict you faced in a team.",
    "What are your career goals?",
    "How do you prioritize tasks?",
    "What makes you different from other candidates?",
    "Tell me about a failure and what you learned.",
    "How do you learn new technologies?",
    "Why are you interested in this role?"
]

@app.get("/")
def home():
    return {
        "message": "InterviewPrep AI Backend Running"
    }

@app.get("/questions")
def get_questions(role: str, difficulty: str):

    category = role_mapping.get(
        role,
        "Software Engineer"
    )

    question_pool = questions_db.get(
        category,
        {}
    ).get(
        difficulty,
        []
    )

    if len(question_pool) >= 5:
        technical_questions = random.sample(
            question_pool,
            5
        )
    else:
        technical_questions = question_pool

    hr_questions = random.sample(
        hr_pool,
        5
    )

    return {
        "role": role,
        "category": category,
        "difficulty": difficulty,
        "technical_questions": technical_questions,
        "hr_questions": hr_questions
    }