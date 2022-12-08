module Optional = {
  let return = a => Some(a)
}

type user = {
  name: string,
  age: int,
}

let codec = Jzon.object2(
  ({name, age}) => (name, age),
  ((name, age)) => Ok({name, age}),
  Jzon.field("name", Jzon.string),
  Jzon.field("age", Jzon.int),
)

let usersCodec = Jzon.array(codec)

let getUsers = () => {
  let users = LocalStorage.getItem(~key="@users")->Js.Nullable.toOption

  users->Belt.Option.flatMap(result => result->Jzon.decodeStringWith(usersCodec)->Optional.return)
}

type state = Loading | Error | Empty | Data(array<user>)

@react.component
let make = () => {
  let (state, setState) = React.useState(_ => Loading)

  React.useEffect0(() => {
    Js.Global.setTimeout(() => {
      let result =
        getUsers()
        ->Belt.Option.map(
          value => value->Belt.Result.map(users => Data(users))->Belt.Result.getWithDefault(Error),
        )
        ->Belt.Option.getWithDefault(Empty)

      setState(_ => result)
    }, 2000)->ignore

    None
  })

  let handleClick = _ => {
    let newUser = {
      name: "John Doe",
      age: 20,
    }

    setState(value =>
      switch value {
      | Empty => {
          LocalStorage.setItem(. ~key="@users", ~value=Js.Json.stringifyAny([newUser]))
          Data([newUser])
        }

      | Data(users) => {
          let newUsers = users->Js.Array2.concat([newUser])
          LocalStorage.setItem(. ~key="@users", ~value=Js.Json.stringifyAny(newUsers))
          Data(newUsers)
        }

      | _ => value
      }
    )
  }

  <div>
    <h1> {`Hello from ReScript + React`->React.string} </h1>
    {switch state {
    | Loading => <h2> {`Loading...`->React.string} </h2>
    | Empty => <h2> {`Empty [ ]`->React.string} </h2>
    | Data(users) =>
      <div>
        <code> {`${users->Jzon.encodeStringWith(usersCodec)}`->React.string} </code>
      </div>

    | Error => <h2> {`Temos um erro!!!`->React.string} </h2>
    }}
    <button onClick=handleClick> {`Adicionar user`->React.string} </button>
  </div>
}
