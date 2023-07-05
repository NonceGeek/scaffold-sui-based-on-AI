defmodule ScaffoldSuiBasedOnAI.DivenChatInteractor do
    require Logger
    def chat(question, history \\ []) do
        Logger.info("question: #{question}")
        payload = 
            %{
                history: history,
                question: question,
                space_name: "sui",
                model_name: "gpt-3.5-turbo",
                prompt_name: "sui",  # 非必填参数，默认则是 master
            }
        ExHttp.http_post(Constants.get_diven_url(), payload, 5)
    end
end