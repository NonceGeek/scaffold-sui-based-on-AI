import requests
import json
import time
import os

# 获取当前脚本所在目录的绝对路径
current_dir = os.path.dirname(os.path.abspath(__file__))
print(current_dir)

url = "http://127.0.0.1:5000/chat"


def append_str_to_file(s):
    with open(f"{current_dir}/text.txt", "a", encoding="utf-8") as f:
        f.write(s + "\n")
    f.close()


def ask_question_about_sui(q: str):
    sui_info = """Sui (swē) is the water element in Japanese philosophy. The power of the sui element lies in its fluidity—its ability to easily adapt to and transform any environment. Similarly, the Sui platform seeks to provide a flexible network that you can leverage to shape the web3 landscape.The Sui platform is built on Sui Move, which is derived from the core Move programming language. This documentation assumes that you have a basic working knowledge of Move. To learn more about the differences between core Move and Sui Move, see How Sui Move differs from core Move.For a deep dive into Sui technology, see the Sui Smart Contracts Platform white paper."""
    payload = json.dumps(
        {
            "history": ["human: what is sui", f"Bot: {sui_info}"],
            "question": q,
            "space_name": "sui",
            "model_name": "gpt-3.5-turbo",
            "prompt_name": "sui",  # 非必填参数，默认则是 master
        }
    )
    headers = {"Content-Type": "application/json"}

    try:
        ask_info = f"user question: {q}. waiting..."
        append_str_to_file(ask_info)
        print(ask_info)
        response = requests.request("POST", url, headers=headers, data=payload)
        answer_info = f'gpt: {response.json()["data"]["answer"]}'
        append_str_to_file(answer_info)
        print(answer_info)

        return response.text
    except Exception as e:
        return f"ask_question_about_sui error: {str(e)}"


questions = """如何在 mac 电脑上通过命令行安装 sui

sui 比起其他区块链的优势是什么

如何快速学习  move 语言，请推荐一些网站""".split(
    "\n\n"
)

for q in questions:
    ask_question_about_sui(q)
    time.sleep(3)
