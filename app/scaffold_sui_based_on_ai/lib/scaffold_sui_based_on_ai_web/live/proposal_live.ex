defmodule ScaffoldSuiBasedOnAIWeb.ProposalLive do
  use ScaffoldSuiBasedOnAIWeb, :live_view

    @impl true
    def mount(_params, _session, socket) do
        {:ok, socket}
    end

    @impl true
    def handle_event(_key, _params, socket) do
        {:noreply, socket}
    end

    def handle_params(_params, _url, socket) do
        {:noreply, socket}
    end

    def render(assigns) do
        ~H"""
            <.container class="mt-10 mb-32">
                <center><.h1>Submit a Proposal to the Public Dataset!</.h1></center>
                <br>
                <.select options={[SmartContractDataset: "smart_contract_dataset", dAppDataset: "dapp_dataset"]} field={:select} />
                <br>
                <.text_input placeholder="title"/>
                <br>
                <.text_input placeholder="content"/>
                <br>
                <a target="_blank" href="https://suiexplorer.com/object/0x6f4fd904cd0f377e4ced44bbcd0146737a04f5e8d0b734cc160ffd81443d1cd5?network=testnet">
                    <center><.button color="primary" label="Submit the Proposal⏎" variant="outline" /></center>
                </a>
            </.container>
        """
    end 
end