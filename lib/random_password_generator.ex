defmodule RandomPasswordGenerator do
  @moduledoc """
  A module for generating random passwords based on given parameters.

  ## Parameters:
  - `length`: Length of the password (default is 20 if no options are specified).
  - `symbols`: Include symbols in the password (default is true if no options are specified).
  - `numbers`: Include numbers in the password (default is true if no options are specified).
  - `lowletters`: Include lowercase letters in the password (default is true if no options are specified).
  - `upletters`: Include uppercase letters in the password (default is true if no options are specified).

  ## Example:
      iex> password = RandomPasswordGenerator.generate_password(length: 16, symbols: true, numbers: true)
      iex> String.length(password) == 16 and Regex.match?(~r/[\W_]/, password) and Regex.match?(~r/\d/, password)
  """

  @uppercase_letters ~c"ABCDEFGHIJKLMNOPQRSTUVWXYZ"
  @lowercase_letters ~c"abcdefghijklmnopqrstuvwxyz"
  @symbols ~c"!@#$%^&*()-_=+[]{}|;:,.<>?/"
  @default_length 20

  @doc """
  Generates a random password based on the provided options.
  """
  def generate_password(opts \\ []) do
    opts = apply_defaults_if_no_options(opts)

    length = get_length(opts)
    available_chars = build_available_chars(opts, length)

    Enum.take_random(available_chars, length)
    |> List.to_string()
  end

  defp apply_defaults_if_no_options(opts) do
    required_keys = [:symbols, :numbers, :lowletters, :upletters]

    required_keys
    |> Enum.all?(&(not Keyword.has_key?(opts, &1)))
    |> case do
      true ->
        Keyword.merge(opts,
          symbols: true,
          numbers: true,
          lowletters: true,
          upletters: true,
          length: get_length(opts)
        )

      false ->
        opts
    end
  end

  def random_numbers_list(length), do: do_random_numbers_list(length, [])

  defp do_random_numbers_list(length, list) when length > 0,
    do: do_random_numbers_list(length - 1, [random_number() | list])

  defp do_random_numbers_list(_, list), do: list

  defp random_number,
    do: Integer.to_string(:rand.uniform(10) - 1)

  defp build_available_chars(opts, length) do
    []
    |> maybe_add_chars(Keyword.fetch(opts, :numbers), random_numbers_list(length))
    |> maybe_add_chars(Keyword.fetch(opts, :lowletters), @lowercase_letters)
    |> maybe_add_chars(Keyword.fetch(opts, :upletters), @uppercase_letters)
    |> maybe_add_chars(Keyword.fetch(opts, :symbols), @symbols)
  end

  defp maybe_add_chars(acc, {:ok, true}, chars), do: acc ++ chars
  defp maybe_add_chars(acc, _add?, _chars), do: acc

  defp get_length(opts) do
    Keyword.get(opts, :length, @default_length)
  end

  @doc """
  Displays help information on how to use the password generator.
  """
  def help do
    IO.puts("""
    Password Generator Help:
    ------------------------
    Parameters (all optional):
    --length LENGTH       Length of the password (default is 20 if no options are specified).
    --symbols             Include symbols in the password.
    --numbers             Include numbers in the password.
    --lowletters          Include lowercase letters in the password.
    --upletters           Include uppercase letters in the password.
    --help                Display this help message.

    Example usage:
    elixir lib/random_password_generator.ex --length 16 --symbols --numbers --lowletters --upletters
    """)
  end

  def main(args \\ []) do
    switches = [
      length: :integer,
      symbols: :boolean,
      numbers: :boolean,
      lowletters: :boolean,
      upletters: :boolean,
      help: :boolean
    ]

    {opts, _rest, _invalid} = OptionParser.parse(args, switches: switches)

    if opts[:help] do
      help()
    else
      password = generate_password(opts)
      IO.puts("Generated password: #{password}")
    end
  end
end

if function_exported?(Mix, :project, 0) do
  # Running in Mix environment; do nothing
else
  RandomPasswordGenerator.main(System.argv())
end
