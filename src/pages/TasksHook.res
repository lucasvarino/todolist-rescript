

let {queryOptions, useQuery} = module(ReactQuery)

let apiUrl = "http://localhost:3001"

let apiCodec = Jzon.array(TaskTypes.codec)

let handleFetch = _ => {
  open Promise

  Fetch.fetch(`${apiUrl}/tasks`, {"method": "GET"})
  ->then(response => Fetch.json(response))
  ->thenResolve(json => Jzon.decodeWith(json, apiCodec))
}

let _ = handleFetch()

type requestResult =
  | Data(array<TaskTypes.t>)
  | Loading
  | Error

let useTasks = () => {
  let result = useQuery(
    queryOptions(
      ~queryKey="tasks",
      ~queryFn=handleFetch,
      ~refetchOnWindowFocus=ReactQuery.refetchOnWindowFocus(#bool(false)),
      (),
    ),
  )

  switch result {
  | {isLoading: true} => Loading
  | {isError: true}
  | {data: Some(Error(_))} =>
    Error
  | {data: Some(Ok(tasks)), isLoading: false, isError: false} => Data(tasks)
  | _ => Error
  }
}
