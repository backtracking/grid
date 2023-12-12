
open Grid

let g = init 5 5 (fun (i,j) -> i+j)

let s = fold (fun _ x s -> x+s) g 0
let () = assert (s = 100)

