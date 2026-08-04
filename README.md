# Doors

Simple Oauth for elixir app

Doors is a modern Oauth Client and Server that prioritizes security, ease of use, and extensibility
in that order.

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `door` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:doors, "~> 0.1.0"}
  ]
end
```

## Usage
Doors is agnostic to your HTTP client, and data storage layer; It simply provides guiding
convenience functions you hook into your appilcation; allowing you to build your custom oauth flow
in a secure and extensible way.
