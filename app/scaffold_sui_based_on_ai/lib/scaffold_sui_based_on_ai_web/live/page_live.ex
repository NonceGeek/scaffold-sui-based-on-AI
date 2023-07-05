defmodule ScaffoldSuiBasedOnAIWeb.PageLive do

  alias ScaffoldSuiBasedOnAI.DivenChatInteractor
  alias ScaffoldSuiBasedOnAI.ExChatServiceInteractor
  use ScaffoldSuiBasedOnAIWeb, :live_view
  
  @embedbase_id "sui-smart-contracts-fragment-by-structure"
  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     assign(socket,
      form: to_form(%{}, as: :f),
      question_now: "What is Sui?",
      question_now_2: "Give me the examples about the Object?",
      question_now_3: "Give me the examples about the Function?",
      question_now_4: "Give me the examples about the Event?",
      question_now_5: "Give me the examples about the Spec?"
     )}
  end

  @impl true
  def handle_params(%{"page" => num, "question" => "intro_sui_obj_model"}, _uri, socket) do
    answer = """
Sui Object Model, balabala...
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
SUi Token Model, balabala...
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
Sui CLI, balabala...
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
          "move_tutorial" ->
            "https://github.com/MystenLabs/sui/blob/main/sui_programmability/examples/move_tutorial/sources/my_module.move"
          "sandwich" ->
            "https://github.com/MystenLabs/sui/blob/main/sui_programmability/examples/basics/sources/sandwich.move"
          _ ->
            "https://github.com/MystenLabs/sui/blob/main/sui_programmability/examples"
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
            <a href="?page=1&question=intro_sui_obj_model">
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
            <.text_input form={@form} field={:question_input_2} placeholder="Give me the examples about the Object?" value={assigns[:question_now_2]}/>
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
            <.link href={~p"/?page=2"} style="color:blue">Step 0x02 - Buidl the Objects</.link>
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
