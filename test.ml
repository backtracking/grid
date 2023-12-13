(**************************************************************************)
(*                                                                        *)
(*  Copyright (C) Jean-Christophe Filliatre                               *)
(*                                                                        *)
(*  This software is free software; you can redistribute it and/or        *)
(*  modify it under the terms of the GNU Library General Public           *)
(*  License version 2.1, with the special exception on linking            *)
(*  described in file LICENSE.                                            *)
(*                                                                        *)
(*  This software is distributed in the hope that it will be useful,      *)
(*  but WITHOUT ANY WARRANTY; without even the implied warranty of        *)
(*  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.                  *)
(*                                                                        *)
(**************************************************************************)

open Format
open Grid

let sum g = fold (fun _ x s -> x+s) g 0

let g = init 5 5 (fun (i,j) -> i+j)
let () = assert (sum g = 100)

let print = print (fun fmt _ c -> pp_print_char fmt c)
let g = init 5 10 (fun (i,j) -> Char.chr (Char.code 'A' + i+j))

let () = assert (rotate_left g = rotate_right (rotate_right (rotate_right g)))
let () = assert (rotate_right g = rotate_left (rotate_left (rotate_left g)))
