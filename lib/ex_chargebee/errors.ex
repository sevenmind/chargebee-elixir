defmodule ExChargebee.ErrorHelpers do
  def message(value) do
    if is_map(value.response) and Map.has_key?(value.response, "message") do
      """
      #{value.message}: #{value.response["message"]}

      #{inspect(Map.drop(value.response, ["message"]))}
      """
    else
      value.message
    end
  end
end

defmodule ExChargebee.UnauthorizedError do
  defexception message: "Unauthorized", path: nil, data: nil, response: nil

  defdelegate message(value), to: ExChargebee.ErrorHelpers
end

defmodule ExChargebee.InvalidRequestError do
  defexception message: "Invalid request", path: nil, data: nil, response: nil

  defdelegate message(value), to: ExChargebee.ErrorHelpers
end

defmodule ExChargebee.NotFoundError do
  defexception message: "Not found", path: nil, data: nil, response: nil

  defdelegate message(value), to: ExChargebee.ErrorHelpers
end

defmodule ExChargebee.RateLimitError do
  defexception message: "Request limit exceeded", path: nil, data: nil, response: nil

  defdelegate message(value), to: ExChargebee.ErrorHelpers
end

# IncorrectDataFormatError is unused?
defmodule ExChargebee.IncorrectDataFormatError do
  defexception message: "Unknown", path: nil, data: nil, response: nil

  defdelegate message(value), to: ExChargebee.ErrorHelpers
end

defmodule ExChargebee.UnknownError do
  defexception message: "Unknown", path: nil, data: nil, response: nil

  defdelegate message(value), to: ExChargebee.ErrorHelpers
end
