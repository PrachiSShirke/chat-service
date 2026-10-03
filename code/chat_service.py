import os
from pathlib import Path

from dotenv import load_dotenv

from langchain_google_genai import ChatGoogleGenerativeAI
from langchain_core.prompts import ChatPromptTemplate, MessagesPlaceholder
from langchain_core.output_parsers import StrOutputParser
from langchain_core.chat_history import InMemoryChatMessageHistory
from langchain_core.messages import HumanMessage, AIMessage


# Load variables from the .env file in the same folder as this module
load_dotenv(Path(__file__).resolve().with_name(".env"))


# Gemini reads the GOOGLE_API_KEY environment variable
llm = ChatGoogleGenerativeAI(
    model="gemini-3.8-flash",
    temperature=0,
    google_api_key=os.getenv("GOOGLE_API_KEY")
)

prompt = ChatPromptTemplate.from_messages([
    ("system", "You are a helpful assistant who is good at recommending books."),
    MessagesPlaceholder(variable_name="messages")
])

chain = prompt | llm | StrOutputParser()

chat_history = InMemoryChatMessageHistory()


def chat(user_message: str) -> str:
    chat_history.add_messages([
        HumanMessage(content=user_message)
    ])

    response = chain.invoke({
        "messages": chat_history.messages
    })

    chat_history.add_messages([
        AIMessage(content=response)
    ])

    return response