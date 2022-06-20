type requestResult =
  | Data(array<TaskTypes.t>)
  | Loading
  | Error

type hookResult = {
  isCreating: bool,
  result: requestResult,
  taskName: string,
  handleCreateTask: ReactEvent.Mouse.t => unit,
  handleChange: ReactEvent.Form.t => unit,
}

let {queryOptions, useQuery, mutationOptions, useMutation} = module(ReactQuery)

let apiUrl = "http://localhost:3001"

let apiCodec = Jzon.array(TaskTypes.codec)

let handleFetch = _ => {
  open Promise

  Fetch.fetch(`${apiUrl}/tasks`, {"method": "GET"})
  ->then(response => Fetch.json(response))
  ->thenResolve(json => Jzon.decodeWith(json, apiCodec))
}

let handleCreateTask = (taskName: string) => {
  let newTask = {
    "name": taskName,
    "completed": false,
    "createdAt": Js.Date.make(),
  }

  Fetch.fetch(
    `${apiUrl}/tasks`,
    {
      "method": "POST",
      "body": Js.Json.stringifyAny(newTask),
      "headers": {
        "Content-Type": "application/json",
      },
    },
  )
}

let useTasks = () => {
  let (taskName, setTaskName) = React.useState(_ => "")

  let result = useQuery(
    queryOptions(
      ~queryKey="tasks",
      ~queryFn=handleFetch,
      ~refetchOnWindowFocus=ReactQuery.refetchOnWindowFocus(#bool(false)),
      (),
    ),
  )

  let handleRefetch = (_, _, _) => {
    setTaskName(_ => "")

    result.refetch({
      throwOnError: false,
      cancelRefetch: false,
    })
  }

  let {mutate: createTaskMutation, isLoading} = useMutation(
    mutationOptions(
      ~onSuccess=handleRefetch,
      ~mutationFn=handleCreateTask,
      ~mutationKey="new-task",
      (),
    ),
  )

  let handleCreateTask = _ => {
    createTaskMutation(. taskName, None)
  }

  let handleChange = event => {
    let target = ReactEvent.Form.target(event)

    setTaskName(_ => target["value"])
  }

  {
    isCreating: isLoading,
    taskName: taskName,
    handleChange: handleChange,
    handleCreateTask: handleCreateTask,
    result: switch result {
    | {isLoading: true} => Loading
    | {isError: true}
    | {data: Some(Error(_))} =>
      Error
    | {data: Some(Ok(tasks)), isLoading: false, isError: false} => Data(tasks)
    | _ => Error
    },
  }
}
