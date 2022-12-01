module App = {
  @react.component
  let make = () => <h1> {`Hello from ReScript + React`->React.string} </h1>
}

let element = ReactDOM.querySelector("#root")
switch element {
| Some(el) => ReactDOM.render(<App />, el)
| None => Js.log("Element root not found")
}
