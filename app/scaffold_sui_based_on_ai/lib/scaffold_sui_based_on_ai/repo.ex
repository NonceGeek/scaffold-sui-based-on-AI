defmodule ScaffoldSuiBasedOnAI.Repo do
  use Ecto.Repo,
    otp_app: :scaffold_sui_based_on_ai,
    adapter: Ecto.Adapters.Postgres
end
