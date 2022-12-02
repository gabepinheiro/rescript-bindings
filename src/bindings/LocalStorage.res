type t

@val
external localStorage: t = "localStorage"

@send external getItem: (t, ~key: string) => Js.Nullable.t<string> = "getItem"
@send external setItem: (t, string, option<string>) => unit = "setItem"
@send external removeItem: (t, ~key: string) => unit = "removeItem"
@send external clear: t => unit = "clear"

let getItem = (~key) => localStorage->getItem(~key)
let setItem = (. ~key, ~value) => localStorage->setItem(key, value)
let removeItem = (~key) => localStorage->removeItem(~key)
let clear = () => localStorage->clear
