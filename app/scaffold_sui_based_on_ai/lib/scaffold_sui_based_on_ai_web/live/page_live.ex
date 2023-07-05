defmodule ScaffoldSuiBasedOnAIWeb.PageLive do

  alias ScaffoldSuiBasedOnAI.DivenChatInteractor
  alias ScaffoldSuiBasedOnAI.ExChatServiceInteractor
  use ScaffoldSuiBasedOnAIWeb, :live_view
  
  @embedbase_id "Sui-smart-contracts-fragment-by-structure"
  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     assign(socket,
      form: to_form(%{}, as: :f),
      question_now: "What is Sui?",
      question_now_2: "Give me the examples about the Struct?",
      question_now_3: "Give me the examples about the Function?",
      question_now_4: "Give me the examples about the Event?",
      question_now_5: "Give me the examples about the Spec?"
     )}
  end

  @impl true
  def handle_params(%{"page" => num, "question" => "intro_apt_obj_model"}, _uri, socket) do
    answer = """
# Object

The [Object model](https://github.com/Sui-labs/Sui-core/blob/main/Sui-move/framework/Sui-framework/sources/object.move) allows Move to represent a complex type as a set of resources stored within a single address and offers a rich capability model that allows for fine-grained resource control and ownership management.

In the object model, an NFT or token can place common token data within a Token resource, object data within an ObjectCore resource, and then specialize into additional resources as necessary. For example, a Player object could define a player within a game and be an NFT at the same time. The ObjectCore itself stores both the address of the current owner and the appropriate data for creating event streams.

## [Comparison with the account resources model](https://Sui.dev/standards/Sui-object#comparison-with-the-account-resources-model)

The existing Sui data model emphasizes the use of the store ability within Move. Store allows for a struct to exist within any struct that is stored on-chain. As a result, data can live anywhere within any struct and at any address. While this provides great flexibility it has many limitations:

1. Data is not be guaranteed to be accessible, for example, it can be placed within a user-defined resource that may violate expectations for that data, e.g., a creator attempting to burn an NFT put into a user-defined store. This can be confusing to both the users and creators of this data.
2. Data of differing types can be stored to a single data structure (e.g., map, vector) via `any`, but for complex data types `any` incurs additional costs within Move as each access requires deserialization. It also can lead to confusion if API developers expect that a specific any field changes the type it represents.
3. While resource accounts allow for greater autonomy of data, they do so inefficiently for objects and do not take advantage of resource groups.
4. Data cannot be recursively composable, because Move currently prohibits recursive data structures. Furthermore, experience suggests that true recursive data structures can lead to security vulnerabilities.
5. Existing data cannot be easily referenced from entry functions, for example, supporting string validation requires many lines of code. Attempting to make tables directly becomes impractical as keys can be composed of many types, thus specializing to support within entry functions becomes complex.
6. Events cannot be emitted from data but from an account that may not be associated with the data.
7. Transferring logic is limited to the APIs provided in the respective modules and generally requires loading resources on both the sender and receiver adding unnecessary cost overheads.

> 💡Object is a core primitive in Sui Move and created via the object module at 0x1::object.

Reference: 

> Code: https://github.com/Sui-labs/Sui-core/blob/main/Sui-move/framework/Sui-framework/sources/object.move
>
> Document: https://Sui.dev/standards/#object
"""

    {
      :noreply, 
      assign(socket, 
        page: String.to_integer(num),
        answer: answer
      )
    }
  end

  @impl true
  def handle_params(%{"page" => num, "question" => "Sui_design_token_model"}, _uri, socket) do

  answer = """
## [Token standard comparison](https://Sui.dev/guides/nfts/Sui-token-comparison/#token-standard-comparison)

In Ethereum or even the whole blockchain world, the Fungible Token (FT) was initially introduced by [EIP-20](https://eips.ethereum.org/EIPS/eip-20), and Non-Fungible Token (NFT) was defined in [EIP-721](https://eips.ethereum.org/EIPS/eip-721). Later, [EIP-1155](https://eips.ethereum.org/EIPS/eip-1155) was proposed to combine FT and NFT or even Semi-Fungible Token (SFT) into the one standard.

One deficiency of the Ethereum token contract is each token having to deploy individual contract code onto a contract account to distinguish it from other tokens even if it simply differs by name. Solana account model enables another pattern where code can be reused so that one generic program operates on various data. To create a new token, you could create an account that can mint tokens and more accounts that can receive them. The mint account itself uniquely determines the token type instead of contract account, and these are all passed as arguments to the one contract deployed to some executable account.

The Sui token standard shares some similarities with Solana, especially how it covers FT, NFT and SFT in one standard and also has a similar generic token contract, which also implicitly defines token standard. Basically, instead of deploying a new ERC20 smart contract for each new token, all you need to do is call a function in the contract with necessary arguments. Depending on what function you call, the token contract will mint/transfer/burn/... tokens.

### [Token identification](https://Sui.dev/guides/nfts/Sui-token-comparison/#token-identification)

Sui identifies a token by its `TokenId` that includes `TokenDataId` and `property_version`. The `property_version` shares the same concept with *Edition Account* in Solana, but there is no explicit counterpart in Ethereum as it is not required in any token standard interface.

`TokenDataId` is a globally unique identifier of token group sharing all the metadata except for `property_version`, including token creator address, collection name and token name. In Ethereum, the same concept is implemented by deploying a token contract under a unique address so an FT type or a collection of NFTs is identified by different contract addresses. In Solana, the similar concept for token identifier is implemented as mint account, each of which will represent one token type. In Sui, a creator account can have multiple token types created by giving different collections and token names.

### [Token categorization](https://Sui.dev/guides/nfts/Sui-token-comparison/#token-categorization)

it is critical to understand, in Sui, how to categorize different tokens to expect different sets of features:

- `Fungible Token`: Each FT has one unique `TokenId`, which means tokens sharing the same creator, collection, name and property version are fungible.
- `Non-Fungible Token`: NFTs always have different `TokenId`s, but it is noted that NFTs belonging to the same collection (by nature also the same creator) will share the same `creator` and `collection` fields in their `TokenDataId`s.
- `Semi-Fungible Token`: The crypto communities lack a common definition for SFT. The only consensus is SFTs are comparatively new types of tokens that combine the properties of NFTs and FTs. Usually this is realized via the customized logic based on different customized properties.

It's worth noting that Solana has an `Edition` concept that represents an NFT that was copied from a Master Edition NFT. This can apply to use cases such as tickets in that they are almost exactly the same except for some properties, for example, serial numbers or seats for tickets. They could be implemented in Sui by bumping the token `property_version` and mutating corresponding fields in `token_properties`. In a nutshell, `Edition` is to Solana token is what `property_version` is to Sui token; but there is no similar concept in Ethereum token standard.

### Token metadata[](https://Sui.dev/guides/nfts/Sui-token-comparison/#token-metadata)

Sui token has metadata defined in `TokenData` with the multiple fields that describe widely acknowledged property data that needs to be understood by dapps. To name a few fields:

- `name`: The name of the token. It must be unique within a collection.
- `description`: The description of the token.
- `uri`: A URL pointer to off-chain for more information about the token. The asset could be media such as an image or video or more metadata in a JSON file.
- `supply`: The total number of units of this token.
- `token_properties`: a map-like structure containing optional or customized metadata not covered by existing fields.

In Ethereum, only a small portion of such properties are defined as methods, such as `name()`, `symbol()`, `decimals()`, `totalSupply()` of ERC-20; or `name()` and `symbol()` and `tokenURI()` of the optional metadata extension for ERC-721; ERC-1155 also has a similar method `uri()` in its own optional metadata extension. Therefore, for tokens on Ethereum, that token metadata is not standardized so that dapps have to take special treatment case by case, which incurs unnecessary overhead for developers and users.

In Solana, the Token Metadata program offers a Metadata Account defining numerous metadata fields associated with a token as well, including `collection` which is defined in `TokenDataId` in Sui. Unfortunately, it fails to provide on-chain property with mutability configuration, which could improve the usability of the token standard by enabling more innovative smart contract logic based on on-chain properties. SFT is a good example of this. Instead, the `Token Standard` field introduced to Token Metadata v1.1.0 only provides `attributes` as a container to hold customized properties. However, it is neither mutable nor on-chain, as an off-chain JSON standard.

Reference: 

> Code: https://github.com/Sui-labs/Sui-core/tree/main/Sui-move/framework/Sui-token/sources
>
> Document: https://Sui.dev/guides/nfts/Sui-token-comparison/#token-standard-comparison

"""
    {
      :noreply, 
      assign(socket, 
        page: String.to_integer(num),
        answer: answer
      )
    }
  end

  @impl true
  def handle_params(%{"page" => num, "question" => "use_Sui_cli"}, _uri, socket) do
    answer = """
The `Sui` tool is a command line interface (CLI) for developing on the Sui blockchain, debugging, and for node operations. This document describes how to use the `Sui` CLI tool. To download or build the CLI, follow [Install Sui CLI](https://Sui.dev/tools/install-cli/).

Reference:

> Document: https://Sui.dev/tools/Sui-cli-tool/use-Sui-cli
"""
    {
      :noreply, 
      assign(socket, 
        page: String.to_integer(num),
        answer: answer
      )
    }
  end


  @impl true
  def handle_params(%{"page" => num}, _uri, socket) do
    {
      :noreply, 
      assign(socket, 
      page: String.to_integer(num))
    }
  end

  @impl true
  def handle_params(%{}, _uri, socket) do
    {
      :noreply, 
      assign(socket, 
      page: 1)
    }
  end

  def handle_event("change-input", %{"_target" => ["f", "question_input"], "f" => %{"question_input" => question}}, socket) do
    {
      :noreply, 
      assign(socket,
        question_now: question
      )
    }
  end

  def handle_event("change-input", %{"_target" => ["f", "question_input_2"], "f" => %{"question_input_2" => question_2}}, socket) do
    {
      :noreply, 
      assign(socket,
        question_now_2: question_2
      )
    }
  end

  def handle_event("change-input", %{"_target" => ["f", "question_input_3"], "f" => %{"question_input_3" => question}}, socket) do
    {
      :noreply, 
      assign(socket,
        question_now_3: question
      )
    }
  end

  def handle_event("change-input", %{"_target" => ["f", "question_input_4"], "f" => %{"question_input_4" => question}}, socket) do
    {
      :noreply, 
      assign(socket,
        question_now_4: question
      )
    }
  end

  def handle_event("change-input", %{"_target" => ["f", "question_input_5"], "f" => %{"question_input_5" => question}}, socket) do
    {
      :noreply, 
      assign(socket,
        question_now_5: question
      )
    }
  end

  def handle_event("submit", %{"f" => f}, socket) do
    do_handle_event(f, socket.assigns.page, socket)
  end

  def do_handle_event(%{"question_input" => question}, 1, socket) do
    {:ok,
      %{
        code: 0,
        data: %{
          answer: answer
        }
      }
    } = DivenChatInteractor.chat(question)
    {
      :noreply, 
      assign(socket,
        answer: answer
      )
    }
  end

  def do_handle_event(%{"question_input_2" => question}, 2, socket) do
    search_and_ask(question, socket)
  end

  def search_and_ask(question, socket) do
    # search the dataset about the question.
    # get the answer by the GPT.
    {:ok, %{similarities: similarities}} = 
      EmbedbaseInteractor.search_data(@embedbase_id, question)
      similarities = handle_search_results(similarities)
    # prompt = Enum.reduce(similarities, "Here are the code examples: ```", fn elem, acc -> 
    #   acc <> elem.data <> "\n"
    # end)

    # prompt = prompt <> "```"

    # {:ok, %{choices: [%{"message" => %{"content" => content}}]}} = ExChatServiceInteractor.chat(:chatable, "gpt-3.5-turbo", prompt, question)
    {
      :noreply, 
      assign(socket,
        # answer: content,
        search_result: similarities
      )
    }
  end

  def handle_search_results(similarities) do
    Enum.map(similarities, fn elem -> 
      url = 
        case elem.metadata.file_name do
          "hello_blockchain" ->
            "https://github.com/Sui-labs/Sui-core/blob/main/Sui-move/move-examples/hello_blockchain/sources/hello_blockchain.move"
          "hello_prover" ->
            "https://github.com/Sui-labs/Sui-core/blob/main/Sui-move/move-examples/hello_prover/sources/prove.move"
          "common_account" ->
            "https://github.com/Sui-labs/Sui-core/blob/main/Sui-move/move-examples/common_account/sources/common_account.move"
          "iterable_table" ->
            "https://github.com/Sui-labs/Sui-core/blob/main/Sui-move/move-examples/data_structures/sources/iterable_table.move"
        end
      Map.put(elem, :url, url)
    end)
  end

  def do_handle_event(%{"question_input_3" => question}, 3, socket) do
    search_and_ask(question, socket)
  end

  def do_handle_event(%{"question_input_4" => question}, 4, socket) do
    search_and_ask(question, socket)
  end

  def do_handle_event(%{"question_input_5" => question}, 5, socket) do
    search_and_ask(question, socket)
  end

  @impl true
  def render(assigns) do
    ~H"""
      <.container class="mt-10 mb-32">
        <center><.h1>Scaffold Sui based on AI <br>Contract Copilot</.h1>
        <br>
        <.h5>
          AI-based Scaffold Sui is a smart contract and dApp programming copilot built on OpenAI and the AI database Embedbase.
        </.h5>
        <br>
        <a href="https://app.embedbase.xyz/datasets/faa9934d-36a5-4f8c-9e33-36f437004cbb" target="_blank">
          <.button color="secondary" label="Visit the Public Vector Dataset about Sui Smart Contract" variant="shadow" />
        </a>
        <br><br>
        <a href="/submit_proposal">
          <.button color="white" label="Submit an on-chain Proposal to the  Public Vector Dataset about Sui Smart Contract" variant="shadow" />
        </a>
        <br><br>

        </center>
        <.form for={@form} phx-change="change-input" phx-submit="submit">
          <%= case @page do %>
          <%= 1 -> %>
            <.text_input form={@form} field={:question_input} placeholder="What is Sui?" value={assigns[:question_now]}/>
            <br>
            <center><.button color="primary" label="Get Smart Answer ⏎" variant="outline" /></center>
            <br>
            <.p>Recommend Questions:</.p>
            <br>
            <a href="?page=1&question=intro_apt_obj_model">
              <div class="flex items-start">
                  <.alert color="info" label="Introduce the Sui Object Model?" />
              </div>
            </a>
            <a href="?page=1&question=Sui_design_token_model">
              <div class="flex items-start mt-4">
                <.alert color="success" label="How does Sui design Token Model?" />
              </div>
            </a>
            <a href="?page=1&question=use_Sui_cli">
              <div class="flex items-start mt-4">
                <.alert color="warning" label="How could I use Sui CLI?" />
              </div>
            </a>
          <%= 2 -> %>
            <.text_input form={@form} field={:question_input_2} placeholder="Give me the examples about the Struct?" value={assigns[:question_now_2]}/>
            <br>
            <center><.button color="primary" label="Get Smart Answer ⏎" variant="outline" /></center>
            <br>
          <%= 3 -> %>
            <.text_input form={@form} field={:question_input_3} placeholder="Give me the examples about the Function?" value={assigns[:question_now_3]}/>
            <br>
            <center><.button color="primary" label="Get Smart Answer ⏎" variant="outline" /></center>
            <br>
          <%= 4 -> %>
            <.text_input form={@form} field={:question_input_4} placeholder="Give me the examples about the Event?" value={assigns[:question_now_4]}/>
            <br>
            <center><.button color="primary" label="Get Smart Answer ⏎" variant="outline" /></center>
            <br>

          <%= 5 -> %>
            <.text_input form={@form} field={:question_input_5} placeholder="Give me the examples about the Spec?" value={assigns[:question_now_5]}/>
            <br>
            <center><.button color="primary" label="Get Smart Answer ⏎" variant="outline" /></center>
            <br>
          <%= _others -> %>
            # TODO
          <% end %>
          <br>
          <%= if not is_nil(assigns[:answer]) do %>
            <%= raw(Earmark.as_html!(assigns[:answer])) %>
          <% end %>
          <%= if not is_nil(assigns[:search_result]) do %>
            <.p>Search Results in <a href="https://app.embedbase.xyz/datasets/faa9934d-36a5-4f8c-9e33-36f437004cbb" target="_blank">Dataset</a>: </.p>
            <.table>
              <thead>
                <.tr>
                  <.th>Result</.th>
                  <.th>Data Source</.th>
                  <.th>Data Type</.th>
                </.tr>
              </thead>
              <tbody>
              <%= for elem <- assigns[:search_result] do %>
                <.tr>
                  <.td><%= elem.data %></.td>
                  <.td><a href={"#{elem.url}"} style="color:blue" target="_blank"><%= elem.metadata.file_name %></a></.td>
                  <.td><%= elem.metadata.type %></.td>
                </.tr>
              <% end %>
              </tbody>
            </.table>
          <% end %>
        </.form>
        <br>
        <center>
        <span>
            <.link href={~p"/?page=1"} style="color:blue">Step 0x01 - Basic Concept Study</.link> |
            <.link href={~p"/?page=2"} style="color:blue">Step 0x02 - Buidl the Structs</.link>
            <br>
            <.link href={~p"/?page=3"} style="color:blue">Step 0x03 - Buidl the Functions</.link> | 
            <.link href={~p"/?page=4"} style="color:blue">Step 0x04 - Buidl the Events</.link> | 
            <.link href={~p"/?page=5"} style="color:blue">Step 0x05 - Buidl the Specs(Optional)</.link> | 
            <.link href={~p"/?page=6"} style="color:blue">Step 0x06 - Generate the Tests for the Contract</.link>
            <br>
            <.link href={~p"/?page=7"} style="color:blue">Step 0x07 - Generate README of the Smart Contract</.link>
          </span>
        </center>
      </.container>
    """
  end
end
