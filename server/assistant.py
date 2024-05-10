from langchain_openai import ChatOpenAI
from langchain_core.prompts import ChatPromptTemplate
from langchain_core.output_parsers import StrOutputParser

openai_proxy = "http://192.168.0.211:7890"

class Assistant:
    def __init__(self):
        self.llm = ChatOpenAI(openai_proxy=openai_proxy)
        self.output_parser = StrOutputParser()

    def chat(self, inputs):
        prompt = ChatPromptTemplate.from_messages([
            ("system", "You are a helpful assistant. Please help me with the following task. You should aware that the user are using speech-to-text software, so the text may not be perfect. Please ask for clarification if needed. Make your response clear and concise."),
        ])
        prompt.extend(inputs)
        chain = prompt | self.llm | self.output_parser
        return chain.invoke({})