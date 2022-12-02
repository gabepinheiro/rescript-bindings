type t

@val
external localStorage: t = "localStorage"

@send external getItem: (t, ~key: string) => Js.Nullable.t<string> = "getItem"
@send external setItem: (t, string, option<string>) => unit = "setItem"

let getItem = (~key) => localStorage->getItem(~key)

let setItem = (. ~key, ~value) => localStorage->setItem(key, value)
