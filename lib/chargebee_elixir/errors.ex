defmodule ChargebeeElixir.UnauthorizedError do
  defexception message: "Unauthorized", path: nil, data: nil
end

defmodule ChargebeeElixir.InvalidRequestError do
  defexception message: "Invalid request", path: nil, data: nil
end

defmodule ChargebeeElixir.NotFoundError do
  defexception message: "Not found", path: nil, data: nil
end


defmodule ChargebeeElixir.RateLimitError do
  defexception message: "Request limit exceeded", path: nil, data: nil
end

# IncorrectDataFormatError is unused?
defmodule ChargebeeElixir.IncorrectDataFormatError do
  defexception message: "Unknown", path: nil, data: nil
end

defmodule ChargebeeElixir.UnknownError do
  defexception message: "Unknown", path: nil, data: nil, response: nil
end
