defmodule RandomPasswordGeneratorTest do
  use ExUnit.Case
  doctest RandomPasswordGenerator
  import ExUnit.CaptureIO

  test "generates password with default options when no options are provided" do
    password = RandomPasswordGenerator.generate_password()
    assert String.length(password) == 20
    assert password =~ ~r/[A-Z]/
    assert password =~ ~r/[a-z]/
    assert password =~ ~r/\d/
    assert password =~ ~r/[!@#$%^&*()\-\_=+\[\]{}|;:,.<>?\/]/
  end

  test "generates password with specified length" do
    password = RandomPasswordGenerator.generate_password(length: 16)
    assert String.length(password) == 16
  end

  test "generates password with only numbers" do
    password =
      RandomPasswordGenerator.generate_password(
        symbols: false,
        lowletters: false,
        upletters: false,
        numbers: true
      )

    assert String.length(password) == 20
    assert password =~ ~r/^\d+$/
  end

  test "generates password with only lowercase letters" do
    password =
      RandomPasswordGenerator.generate_password(
        symbols: false,
        lowletters: true,
        upletters: false,
        numbers: false
      )

    assert String.length(password) == 20
    assert password =~ ~r/^[a-z]+$/
  end

  test "generates password with only uppercase letters" do
    password =
      RandomPasswordGenerator.generate_password(
        symbols: false,
        lowletters: false,
        upletters: true,
        numbers: false
      )

    assert String.length(password) == 20
    assert password =~ ~r/^[A-Z]+$/
  end

  test "generates password with only symbols" do
    password =
      RandomPasswordGenerator.generate_password(
        symbols: true,
        lowletters: false,
        upletters: false,
        numbers: false
      )

    assert String.length(password) == 20
    assert password =~ ~r/^[!@#$%^&*\(\)\-_=+\[\]{}\|;:,.<>?\/]+$/
  end

  test "help function displays help message" do
    output = capture_io(fn -> RandomPasswordGenerator.help() end)
    assert output =~ "Password Generator Help:"
  end

  test "main function generates password with default options" do
    output = capture_io(fn -> RandomPasswordGenerator.main([]) end)
    assert output =~ ~r/^Generated password: .+/
  end

  test "main function generates password with length and only upletters and symbols" do
    output =
      capture_io(fn ->
        RandomPasswordGenerator.main(["--length", "16", "--symbols", "--upletters"])
      end)

    [_, password] = String.split(output, ": ")

    password = String.trim(password)

    assert String.length(password) == 16
    assert password =~ ~r/[A-Z]/
    assert password =~ ~r/[!@#$%^&*()\-_=+\[\]{}\|;:,.<>?\/]/
    refute password =~ ~r/[a-z]/
    refute password =~ ~r/\d/
  end
end
