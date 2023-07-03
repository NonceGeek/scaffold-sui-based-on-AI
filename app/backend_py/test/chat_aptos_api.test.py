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


def ask_question_about_aptos(q: str):
    aptos_info = """Welcome! Aptos is a Layer 1 for everyone. In the Ohlone language, "Aptos" means "The People." This site is here to help you grow a web3 ecosystem project that benefits the entire world through easier development, more reliable services, faster transactions, and a supportive, decentralized family. This documentation will help you develop applications for the Aptos blockchain, run nodes, and be a part of the blossoming Aptos community. This documentation covers both basic and advanced topics. Here you will find concepts, how-to guides, quickstarts, tutorials, API references, code examples, release notes, and more."""
    payload = json.dumps(
        {
            "history": ["human: what is aptos", f"Bot: {aptos_info}"],
            "question": q,
            "space_name": "aptos",
            "model_name": "gpt-3.5-turbo",
            "prompt_name": "aptos",  # 非必填参数，默认则是 master
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
        return f"ask_question_about_aptos error: {str(e)}"


questions = """如何在 mac 电脑上通过命令行安装 aptos

aptos 比起其他区块链的优势是什么

如何快速学习  move 语言，请推荐一些网站""".split(
    "\n\n"
)

for q in questions:
    ask_question_about_aptos(q)
    time.sleep(3)
