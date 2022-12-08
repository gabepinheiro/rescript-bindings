let root = ReactDOM.querySelector("#root")

switch root {
| Some(element) => ReactDOM.render(<LocalStorageExample />, element)
| None => Js.log("Root element not found")
}
