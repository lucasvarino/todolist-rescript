let s = React.string
let map = (itens, fn) => itens->Js.Array2.mapi((item,key) => fn(item, key->Js.Int.toString))->React.array 