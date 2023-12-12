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

type 'a t = 'a array array

type position = int * int

let height g =
  Array.length g

let width g =
  Array.length g.(0)

let size g =
  height g, width g

let make h w v =
  if h < 1 || w < 1 then invalid_arg "Grid.make";
  Array.make_matrix h w v

let init h w f =
  if h < 1 || w < 1 then invalid_arg "Grid.init";
  Array.init h (fun i -> Array.init w (fun j -> f (i, j)))

let get g (i, j) =
  g.(i).(j)

let set g (i, j) v =
  g.(i).(j) <- v

let inside g (i, j) =
  0 <= i && i < height g && 0 <= j && j < width g

let north (i, j) = (i-1, j)
let south (i, j) = (i+1, j)
let west  (i, j) = (i, j-1)
let east  (i, j) = (i, j+1)

let iter4 f g p =
  let f p = if inside g p then f p (get g p) in
  f (north p);
  f (west  p);
  f (south p);
  f (east  p)

let iter8 f g (i, j) =
  for di = -1 to 1 do for dj = -1 to 1 do
    if di <> 0 || dj <> 0 then
      let p = (i+di, j+dj) in
      if inside g p then f p (get g p)
  done done

let iter f g =
  for i = 0 to height g - 1 do
    for j = 0 to width g - 1 do
      f (i, j) g.(i).(j)
    done
  done

let fold f g acc =
  let rec fold (i,j as p) acc =
    if i = height g then acc else
    if j = width g then fold (i+1,0) acc else
    fold (i,j+1) (f p g.(i).(j) acc) in
  fold (0,0) acc

let read c =
  let rec scan rows = match input_line c with
    | s -> scan (s :: rows)
    | exception End_of_file ->
        let row s = Array.init (String.length s) (String.get s) in
        let g = Array.map row (Array.of_list (List.rev rows)) in
        if Array.length g = 0 then invalid_arg "Grid.read";
        let w = Array.length g.(0) in
        for i = 1 to height g - 1 do
          if Array.length g.(i) <> w then invalid_arg "Grid.read"
        done;
        g
  in
  scan []

let print
  ?(bol = (fun _fmt _i -> ()))
  ?(eol = (fun  fmt _i -> Format.pp_print_newline fmt ()))
  ?(sep = (fun _fmt _p -> ()))
  p fmt g =
  for i = 0 to height g - 1 do
    bol fmt i;
    for j = 0 to width g - 1 do
      p fmt (i,j) g.(i).(j);
      if j < width g - 1 then sep fmt (i,j)
    done;
    eol fmt i
  done
