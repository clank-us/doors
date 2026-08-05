defmodule Doors.CodeFlow.AuthorizeTest do
  use ExUnit.Case, async: true

  describe "prepare" do
    test "creates querystring if params are valid" do
      assert {:error, %Ecto.Changeset{} = changeset} = Doors.CodeFlow.Authorize.prepare(%{})
      assert {:client_id, {"can't be blank", [validation: :required]}} in changeset.errors

      params = %{
        client_id: "client1",
        redirect_uri: "https://oauth.tools/callback/code",
        scope: "name email profile openid projects:write"
      }

      assert {_data, query_string} = Doors.CodeFlow.Authorize.prepare(params) |> dbg()
      assert query_string =~ "name%20email"
      assert query_string =~ "client_id=client1"
      assert query_string =~ "response_type=code"
      assert query_string =~ "code_challenge="
      refute query_string =~ "code_verifier="
    end
  end

  describe "prepare_changeset" do
    test "generates flow-specific fields" do
      params = %{
        client_id: "client1",
        redirect_uri: "https://oauth.tools/callback/code",
        scope: "name email profile openid projects:write"
      }

      assert {:ok, data} =
               params
               |> Doors.CodeFlow.Authorize.prepare_changeset()
               |> Ecto.Changeset.apply_action(:prepare)

      assert data.state |> String.length() == 22
      assert data.nonce |> String.length() == 22
      assert data.code_challenge |> String.length() == 43
      assert data.code_verifier |> String.length() == 43
    end
  end
end
