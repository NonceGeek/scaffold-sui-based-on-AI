# scaffold-sui-based-on-AI
AI-based Sui smart contract and dApp scaffolding, empowering developers to rapidly develop and learn.

## 0x01 Short Introduction

AI-based Scaffold Sui is a smart contract and dApp programming assistant built on OpenAI and the AI database [Embedbase](https://embedbase.xyz/). 

**Problems:** Smart contract and dApp learning have a steep learning curve, especially for self-learners, requiring a substantial investment of time and effort.

**Vision:** Move developers can quickly get started and master development skills, while AI can handle tedious and repetitive tasks, saving them valuable time and effort.

OUR OPNION: `AI ≠ Programmer, AI = Programmer’s Copilot`.

## 0x02 Project Structure

```
.
├── README.md
├── app
│   └── backend_py
|   └── frontend
├── data_resources
│   └── README.md
└── governancer
		└── smart_contract
		└── sdk
```

### 2.1App

The main app of `scaffold-sui-based-on-AI`, including the backend and the frontend.

![image-20230626172829275](https://p.ipic.vip/c5yvae.png)

*<center>the diagram of how to generate smart contract</center>*

![image-20230626172928862](https://p.ipic.vip/l06tcx.png)

*<center>the diagram of how to generate dApp</center>*

### 2.2 Data Resources

The data resources that we transform them as the **public vector dataset**, so they could be called by the program related to the AI.

> 💡Smart Contract Library and dApp Library will be automatically updated by identifying and judging the latest Repo on Github.

Including these types of dataset now: 

* **Public Document of SUI:**  Sui public documentation, serving general knowledge.
* **Projects Library:** Project documentation, collecting Move projects with excellent code quality.
* **Smart Contract Library:** Sui smart contract documentation, serving the development of smart contracts. 
* **dApp Library:** Sui dApp documentation, serving the development of dApps.

### 2.3 Governancer

The governancer is the smart contract about the `write` to dataset, so that the dataset could be managed in     DAO way.

![image-20230626173626688](https://p.ipic.vip/ygpd88.png)

## 0x03 Technical Features

* Dynamic & Smart Data Source:  Regularly intelligently crawl data sources and upload them as public vector datasets.
* Smart DSLer: Slice Sui Smart Contract and dApp source code into atomic pieces so it could be uyload to the open vector dataset. 
* Open Dataset Governance: Governance the public datasets by the DAO System on chain.

> 💡Public vector datasets could be used by any AI-based Program related to Move. 





