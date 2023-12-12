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

(** {2 Grids aka two-dimensional arrays}

    Following conventions in mathematics, grids are considered rows first.
    Thus in the following, [height] refers to the first dimension
    and [width] to the second dimension.

             0   1       j      width-1
           +---+---+---+---+---+--+
        0  |   |   |   |   |   |  |
           +---+---+---+---+---+--+
        1  |   |   |   |   |   |  |
           +---+---+---+---+---+--+
        i  |   |   |   | X |   |  |
           +---+---+---+---+---+--+
  height-1 |   |   |   |   |   |  |
           +---+---+---+---+---+--+

    Following OCaml conventions, indices are 0-based.
*)

type 'a t = 'a array array

type position = int * int

val height: 'a t -> int

val width: 'a t -> int

val size: 'a t -> int * int
 (** both height and width, in that order *)

val make: int -> int -> 'a -> 'a t
  (** equivalent to [Array.make_matrix] *)

val init: int -> int -> (position -> 'a) -> 'a t

val get : 'a array array -> position -> 'a

val set : 'a array array -> position -> 'a -> unit

val inside : 'a array array -> position -> bool
  (** [inside g p] indicates whether position [p] is a legal position in [g] *)

val north: position -> position
val south: position -> position
val west : position -> position
val east : position -> position

val iter4: (position -> 'a -> unit) -> 'a array array -> position -> unit
  (** [iter4 f g p] applies function [f] on the four neightbors of
      position [p] (provided they exist) *)

val iter8: (position -> 'a -> unit) -> 'a array array -> position -> unit
  (** [iter4 f g p] applies function [f] on the eight neightbors of
      position [p] (provided they exist) *)

val iter: (position -> 'a -> unit) -> 'a array array -> unit
  (** [iter f g] applies function [f] on each position of the grid [g] *)

val fold: (position -> 'a -> 'acc -> 'acc) -> 'a array array -> 'acc -> 'acc
  (** [fold f g] folds function [f] over each position of the grid [g] *)

val print:
  ?bol:(Format.formatter -> int -> unit) ->
  ?eol:(Format.formatter -> int -> unit) ->
  ?sep:(Format.formatter -> position -> unit) ->
  (Format.formatter -> position -> 'a -> unit) ->
  Format.formatter -> 'a t -> unit
  (** [print pp fmt g] prints the grid [g] on formatter [fmt],
      using function [pp] to print each element.

      Function [bol] is called at the beginning of each line, and is passed
      the line number. The default function does nothing.

      Function [eol] is called at the end of each line, and is passed
      the line number. The default function calls [Format.pp_print_newline].

      Function [sep] is printed between two consecutive element on a given row
      (and is passed the position of the left one).
      The default function does nothing.
 *)

val read: in_channel -> char t
  (** [read c] reads a grid of characters from the input channel [c].
      Raises [Invalid_argument] if the lines do not have the same length,
      or there is no line at all. *)
