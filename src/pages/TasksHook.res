module Task = {
  type t = {
    id: int,
    name: string,
    completed: bool,
    createdAt: string,
  }

  let codec = Jzon.object4(
    ({id, name, completed, createdAt}) => (id, name, completed, createdAt),
    ((id, name, completed, createdAt)) =>
      {id: id, name: name, completed: completed, createdAt: createdAt}->Ok,
    Jzon.field("id", Jzon.int),
    Jzon.field("name", Jzon.string),
    Jzon.field("completed", Jzon.bool),
    Jzon.field("createdAt", Jzon.string),
  )
}


module Fetch = {
  type response

  @send external json: response => Js.Promise.t<Js.Json.t> = "json"
  @val external fetch: (string, {..}) => Js.Promise.t<response> = "fetch"
}

let {queryOptions, useQuery} = module(ReactQuery)


let apiUrl = "http://localhost:3001"

let apiCodec = Jzon.array(Task.codec)

let handleFetch = _ => {
  open Promise

  Fetch.fetch(`${apiUrl}/tasks`, {"method": "GET"})
  ->then(response => Fetch.json(response))
  ->thenResolve(json => Jzon.decodeWith(json, apiCodec))
}

let _ = handleFetch()

//TODO: fix this

let useTasks = () => {
  let result = useQuery(queryOptions(
    ~queryKey="tasks",
    ~queryFn=handleFetch,
    ~refetchOnWindowFocus=ReactQuery.refetchOnWindowFocus(#bool(false)),
    ()
  ))
  
  Js.log(result)

  result
}
