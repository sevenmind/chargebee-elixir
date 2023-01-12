defmodule ExChargebee.UnauthorizedError do
  defexception message: "Unauthorized", path: nil, data: nil
end

defmodule ExChargebee.InvalidRequestError do
  defexception message: "Invalid request", path: nil, data: nil
end

defmodule ExChargebee.NotFoundError do
  defexception message: "Not found", path: nil, data: nil
end

defmodule ExChargebee.RateLimitError do
  defexception message: "Request limit exceeded", path: nil, data: nil
end

# IncorrectDataFormatError is unused?
defmodule ExChargebee.IncorrectDataFormatError do
  defexception message: "Unknown", path: nil, data: nil
end

defmodule ExChargebee.UnknownError do
  defexception message: "Unknown", path: nil, data: nil, response: nil
end
