defmodule ChargebeeElixir.UnauthorizedError do
  defexception message: "Unauthorized", path: nil, data: nil
end

defmodule ChargebeeElixir.InvalidRequestError do
  defexception message: "Invalid request", path: nil, data: nil
end

defmodule ChargebeeElixir.NotFoundError do
  defexception message: "Not found", path: nil, data: nil
end

defmodule ChargebeeElixir.UnknownError do
  defexception message: "Unknown", path: nil, data: nil
end

defmodule ChargebeeElixir.IncorrectDataFormatError do
  defexception message: "Unknown", path: nil, data: nil
end
