defmodule Xomodoro.Options.CollectableImpl do
  defimpl Collectable, for: Xomodoro.Options do
    use Xomodoro.Types
    alias Xomodoro.Options

    @type collector_t ::
            (Options.t(), {:cont, {any, any}} -> Options.t())
            | (Options.t(), :done -> Options.t())
            | (any, :halt -> :ok)

    @spec into(any()) :: pair(any(), collector_t())
    def into(acc) do
      collector = fn
        strct, {:cont, {kw, value}} -> %{strct | kw => value}
        strct, :done -> strct
        _, :halt -> :ok
      end

      {acc, collector}
    end
  end
end
