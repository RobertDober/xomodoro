defmodule Xomodoro.Options do

  use Xomodoro.Types

  defstruct \
    help: false,
    palette: "default",
    silent: false,
    time: "25",
    verbose: false,
    version: false


  @type t :: %__MODULE__{
    help: boolean(),
    palette: String.t(),
    silent: boolean(),
    time: number(),
    verbose: boolean(),
    version: boolean()
  }
  @type positional_args_t :: OptionParser.argv()
  @type parsed_t :: {t(), positional_args_t()}
  @type result_t :: either(parsed_t())


  @spec parse(positional_args_t()) :: result_t()
  def parse args do
    OptionParser.parse(args, strict: switches(), aliases: aliases())
    |> transform()
  end


  # For OptionParser
  #--------------------------------

  @spec aliases() :: Keyword.t()
  defp aliases, do: [h: :help, p: :palette, s: :silent, t: :time, V: :verbose,  v: :version]

  @spec switches() :: Keyword.t()
  defp switches do
    # Lots of duplication here
    [
      help: :boolean,
      palette: :string,
      silent: :boolean,
      time: :number,
      verbose: :boolean,
      version: :boolean
    ]
  end

  # For __MODULE__
  #--------------------------------

  @spec make_struct( OptionParser.parsed() ) :: t
  defp make_struct(options) do
    options
    |> Enum.into(%__MODULE__{})
  end

  @spec transform( parsed_options_t() ) :: result_t()
  defp transform parsed_options
  defp transform( {options, positional, []} ) do
    transform_ok(make_struct(options), positional)
  end
  defp transform( {_, _, errors} ) do
    {:error, "Illegal options #{inspect errors}"}
  end

  @spec transform_ok( t(), positional_args_t() ) :: result_t()
  defp transform_ok(options, positional)
  defp transform_ok(%{silent: true, verbose: true}, _) do
    {:error, "Must not use --silent and --verbose"}
  end
  defp transform_ok(options, positional) do
    {:ok, {options, positional}}
  end

end
