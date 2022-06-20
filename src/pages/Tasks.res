open Ancestor.Default
open Render
open Assets

let formatDate = date => date->Js.Date.fromString->DateFns.format("dd/MM/yy hh:mm")

module EmptyState = {
  @react.component
  let make = () => {
    <Box
      minH=[xs(40.0->#rem)]
      display=[xs(#flex)]
      flexDirection=[xs(#column)]
      alignItems=[xs(#center)]
      justifyContent=[xs(#center)]>
      <Base tag=#img mb=[xs(3)] width=[xs(200->#px)] src=emptyState />
      <Typography
        tag=#h1
        m=[xs(0)]
        mb=[xs(1)]
        textAlign=[xs(#center)]
        fontSize=[xs(2.4->#rem)]
        fontWeight=[xs(#bold)]
        letterSpacing=[xs(-0.055->#em)]
        color=[xs(Theme.Colors.white)]>
        {`Não há tarefas pendentes`->s}
      </Typography>
      <Typography
        tag=#p
        m=[xs(0)]
        textAlign=[xs(#center)]
        fontSize=[xs(1.8->#rem)]
        letterSpacing=[xs(-0.03->#em)]
        color=[xs(Theme.Colors.grayLight)]>
        {`Adicione sua primeira tarefa utilizando o campo acima`->s}
      </Typography>
    </Box>
  }
}

module ErrorMessage = {
  @react.component
  let make = () => {
    <Box
      minH=[xs(40.0->#rem)]
      display=[xs(#flex)]
      flexDirection=[xs(#column)]
      alignItems=[xs(#center)]
      justifyContent=[xs(#center)]>
      <Typography
        tag=#h1
        m=[xs(0)]
        mb=[xs(1)]
        textAlign=[xs(#center)]
        fontSize=[xs(2.4->#rem)]
        fontWeight=[xs(#bold)]
        letterSpacing=[xs(-0.055->#em)]
        color=[xs(Theme.Colors.white)]>
        {`Ocorreu algo inesperado`->s}
      </Typography>
      <Typography
        tag=#p
        m=[xs(0)]
        textAlign=[xs(#center)]
        fontSize=[xs(1.8->#rem)]
        letterSpacing=[xs(-0.03->#em)]
        color=[xs(Theme.Colors.grayLight)]>
        {`Ocorreu um erro, por favor tente novamente`->s}
      </Typography>
    </Box>
  }
}

module TaskItem = {
  @react.component
  let make = (~name, ~createdAt, ~completed) => {
    <Box
      mb=[xs(2)]
      px=[xs(3)]
      py=[xs(2)]
      bgColor=[xs(Theme.Colors.grayDark)]
      borderRadius=[xs(1)]
      display=[xs(#flex)]
      justifyContent=[xs(#"space-between")]
      alignItems=[xs(#center)]>
      <Box>
        <Typography
          tag=#p
          m=[xs(0)]
          mb=[xs(1)]
          fontSize=[xs(1.8->#rem)]
          color=[xs(Theme.Colors.white)]
          letterSpacing=[xs(-0.035->#em)]>
          {name->s}
        </Typography>
        <Typography
          tag=#p
          m=[xs(0)]
          fontSize=[xs(1.4->#rem)]
          color=[xs(Theme.Colors.grayLight)]
          letterSpacing=[xs(-0.035->#em)]>
          {createdAt->s}
        </Typography>
      </Box>
      <Checkbox checked=completed />
    </Box>
  }
}

module Spinner = {
  @react.component
  let make = () => {
    <Box
      minH=[xs(40.0->#rem)]
      width=[xs(100.0->#pct)]
      display=[xs(#flex)]
      justifyContent=[xs(#center)]
      alignItems=[xs(#center)]>
      <Base tag=#img src=spinner width=[xs(5.6->#rem)]/>
    </Box>
  }
}

module NewTaskInput = {
  @react.component
  let make = () => {
    <Box>
      <Typography
        tag=#label
        m=[xs(0)]
        letterSpacing=[xs(-0.035->#em)]
        fontWeight=[xs(#bold)]
        fontSize=[xs(2.4->#rem)]
        lineHeight=[xs(3.1->#rem)]
        color=[xs(Theme.Colors.white)]>
        {`Nova Tarefa`->s}
      </Typography>
      <Box mt=[xs(2)] position=[xs(#relative)]>
        <Input placeholder="Compras da Semana" />
        <Box position=[xs(#absolute)] right=[xs(8->#px)] top=[xs(8->#px)]>
          <Button> `Adicionar` </Button>
        </Box>
      </Box>
    </Box>
  }
}

@react.component
let make = () => {
  let result = TasksHook.useTasks()

  <Box display=[xs(#flex)] flexDirection=[xs(#column)] alignItems=[xs(#center)]>
    <Box display=[xs(#flex)] justifyContent=[xs(#center)] tag=#header> <img src=logo /> </Box>
    <Box
      mt=[xs(10)]
      maxW=[xs(63.4->#rem)]
      width=[xs(100.0->#pct)]
      display=[xs(#flex)]
      flexDirection=[xs(#column)]>
      <NewTaskInput />
      <Box mt=[xs(4)]>
        {switch result {
        | Loading => <Spinner />
        | Error => <ErrorMessage />
        | Data([]) => <EmptyState />
        | Data(tasks) =>
          tasks->map(({name, completed, createdAt}, key) => {
            <TaskItem key name completed createdAt={createdAt->formatDate} />
          })
        }}
      </Box>
    </Box>
  </Box>
}
