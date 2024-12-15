(**************************************************************************)
(*                                                                        *)
(*  Copyright (C) Jean-Christophe Filliatre                               *)
(*                                                                        *)
(*  This software is free software; you can redistribute it and/or        *)
(*  modify it under the terms of the GNU Lesser General Public            *)
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

{v
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
v}

    Following OCaml conventions, indices are 0-based.

    For the width to be well-defined, some of the following functions
    assume a positive number of rows (and, to be consistent, a positive
    number of columns).
*)

type 'a t = 'a array array

type position = int * int
  (** A position is an ordered pair [(i,j)], where [i] is the row and
      [j] is the column. Rows and columns are 0-based. *)

val height: 'a t -> int
  (** Returns the number of rows. *)

val width: 'a t -> int
  (** Returns the number of columns. *)

val size: 'a t -> int * int
 (** both height and width, in that order *)

val make: int -> int -> 'a -> 'a t
  (** [make h w v] returns a new grid with height [h] and width [w],
      where all values are equal to [v].
      Raises [Invalid_argument] if [h<1] or [w<1].

      For [h>=1] and [w>=1], this is equivalent to [Array.make_matrix h w v]. *)

val init: int -> int -> (position -> 'a) -> 'a t
  (** [init h w f] returns a new grid with height [h] and width [w],
      where the value at position [p] is [f p].
      Raises [Invalid_argument] if [h<1] or [w<1]. *)

val copy: 'a t -> 'a t
  (** [copy g] returns a new grid that contains the same elements as [g] *)

val get: 'a t -> position -> 'a
  (** [get g p] returns the value at position [p].
      Raises [Invalid_argument] if the position is out of bounds. *)

val set: 'a t -> position -> 'a -> unit
  (** [set g p v] sets the value at position [p], with [v].
      Raises [Invalid_argument] if the position is out of bounds. *)

val inside: 'a t -> position -> bool
  (** [inside g p] indicates whether position [p] is a legal position in [g] *)

val north: position -> position
  (** the position above in the grid *)

val north_west: position -> position
  (** the position above left in the grid *)

val west : position -> position
  (** the position to the left in the grid *)

val south_west: position -> position
  (** the position below left in the grid *)

val south: position -> position
  (** the position below in the grid *)

val south_east: position -> position
  (** the position below right in the grid *)

val east : position -> position
  (** the position to the right in the grid *)

val north_east: position -> position
  (** the position above right in the grid *)

type direction = N | NW | W | SW | S | SE | E | NE
  (** the eight ways to move on the grid *)

val move: direction -> position -> position
  (** move a position in a given direction *)

val rotate_left: 'a t -> 'a t
  (** [rotate_left g] returns a new grid that is the left rotation of [g] *)

val rotate_right: 'a t -> 'a t
  (** [rotate_right g] returns a new grid that is the right rotation of [g] *)

val map: (position -> 'a -> 'b) -> 'a t -> 'b t
  (** [map f g] returns a fresh grid, with the size of the grid [g]
      and where the value at position [p] is given by [f p (get g p)] *)


(** {e The following functions that iterate or fold over the neighbors of [p]
    all begin by calling [f] on the cell north of [p] and rotate clockwise.} *)

val iter4: (position -> 'a -> unit) -> 'a t -> position -> unit
  (** [iter4 f g p] applies function [f] on the four neighbors of
      position [p] (provided they exist) *)

val iter8: (position -> 'a -> unit) -> 'a t -> position -> unit
  (** [iter8 f g p] applies function [f] on the eight neighbors of
      position [p] (provided they exist) *)

val fold4: (position -> 'a -> 'acc -> 'acc) -> 'a t -> position -> 'acc -> 'acc
  (** [fold4 f g p] folds function [f] on the four neighbors of
      position [p] (provided they exist) *)

val fold8: (position -> 'a -> 'acc -> 'acc) -> 'a t -> position -> 'acc -> 'acc
  (** [fold8 f g p] folds function [f] on the eight neighbors of
      position [p] (provided they exist) *)

  (** {e [iter] and [fold] both begin at the top left of the grid and move
      left to right in each row from top to bottom.} *)

val iter: (position -> 'a -> unit) -> 'a t -> unit
  (** [iter f g] applies function [f] at each position of the grid [g] *)

val fold: (position -> 'a -> 'acc -> 'acc) -> 'a t -> 'acc -> 'acc
  (** [fold f g] folds function [f] over each position of the grid [g] *)

val find: (position -> 'a -> bool) -> 'a t -> position
  (** [find f g] returns a position in [g] where [f] holds,
      or raises [Not_found] if there is none *)

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

val print_chars: Format.formatter -> char t -> unit
  (** prints a grid of characters using [Format.pp_print_char] *)

val read: in_channel -> char t
  (** [read c] reads a grid of characters from the input channel [c].
      Raises [Invalid_argument] if the lines do not have the same length,
      or there is no line at all. *)
