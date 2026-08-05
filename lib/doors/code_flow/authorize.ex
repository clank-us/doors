defmodule Doors.CodeFlow.Authorize do
  alias Doors.Utils

  use Ecto.Schema

  import Ecto.Changeset

  @primary_key false

  embedded_schema do
    field(:client_id, :string)
    field(:response_type, Ecto.Enum, values: [:code], default: :code)
    field(:redirect_uri, :string)
    field(:state, :string)
    field(:scope, :string)
    field(:code_verifier, :string)
    field(:code_challenge, :string)
    field(:code_challenge_method, Ecto.Enum, values: [:S256], default: :S256)
    field(:prompt, Ecto.Enum, values: [:consent, :none], default: :none)
    field(:nonce, :string)
  end

  @doc """
  ## Step 1 of the Oauth Code flow.
  Take required parameters and return a proper query-string to append to any url wth your http
  client
  """
  def prepare(%{} = params) do
    data = params |> prepare_changeset() |> apply_action(:pepare)

    case data do
      {:ok, valid} -> {data, to_query_string(valid)}
      other -> other
    end
  end

  def prepare_changeset(%{} = params) do
    fields = ~w[client_id redirect_uri scope]a

    %__MODULE__{}
    |> cast(params, fields)
    |> validate_required(fields)
    |> put_state()
    |> put_state()
    |> put_nonce()
    |> put_challenges()
  end

  defp to_query_string(%__MODULE__{} = schema) do
    schema
    |> Map.from_struct()
    |> Map.delete(:code_verifier)
    |> URI.encode_query(:rfc3986)
  end

  defp put_state(%{valid?: false} = changeset), do: changeset
  defp put_state(changeset), do: put_change(changeset, :state, Utils.random_encode(16))

  defp put_nonce(%{valid?: false} = changeset), do: changeset
  defp put_nonce(changeset), do: put_change(changeset, :nonce, Utils.random_encode(16))

  defp put_challenges(%{valid?: false} = changeset), do: changeset

  defp put_challenges(changeset) do
    alg = get_field(changeset, :code_challenge_method)
    code_verifier = Utils.random_encode(32)
    code_challenge = Utils.hash_encode(code_verifier, alg)

    changeset
    |> put_change(:code_verifier, code_verifier)
    |> put_change(:code_challenge, code_challenge)
  end
end
