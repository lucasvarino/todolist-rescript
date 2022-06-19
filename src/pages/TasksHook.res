let apiUrl = "http://localhost:3001"

module Fetch = {
  type response

  @send external json: (response) => Js.Promise.t<Js.Json.t> = "json"
  @val external fetch: (string, {..}) => Js.Promise.t<response> = "fetch"
}

let handleFetch = () => {
  open Promise

  Fetch.fetch(`${apiUrl}/tasks`, {"method": "GET"})
  ->then(response => Fetch.json(response))
}

let _ = handleFetch()

let useTasks = () => {
  ()
}
