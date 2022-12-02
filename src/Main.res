type user = {
  name: string,
  age: int,
}

type users = Empty | Data(array<user>) | Error

let userCodec = Jzon.object2(
  ({name, age}) => (name, age),
  ((name, age)) => Ok({name, age}),
  Jzon.field("name", Jzon.string),
  Jzon.field("age", Jzon.int),
)

let storageCodec = Jzon.array(userCodec)

module App = {
  @react.component
  let make = () => {
    let (state, setState) = React.useState(_ =>
      switch LocalStorage.getItem(~key="@users")->Js.Nullable.toOption {
      | Some(value) => {
          let json = try Js.Json.parseExn(value) catch {
          | _ => failwith("Error parsing JSON String")
          }

          let result = json->Jzon.decodeWith(storageCodec)
          switch result {
          | Ok(users) => Data(users)
          | Error(_) => Error
          }
        }

      | None => Empty
      }
    )

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

    Js.log(state)

    <div>
      <h1> {`Hello from ReScript + React`->React.string} </h1>
      {switch state {
      | Empty => <h2> {`Empty [ ]`->React.string} </h2>
      | Data(users) => {
          let str = users->Js.Json.stringifyAny
          switch str {
          | Some(value) => <p> {value->React.string} </p>
          | _ => React.null
          }
        }

      | Error => <h2> {`Temos um erro!!!`->React.string} </h2>
      }}
      <button onClick=handleClick> {`Adicionar User`->React.string} </button>
    </div>
  }
}

let element = ReactDOM.querySelector("#root")
switch element {
| Some(el) => ReactDOM.render(<App />, el)
| None => Js.log("Element root not found")
}
