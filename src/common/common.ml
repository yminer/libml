(******************************************************************
  [LibML - Machine Learning Library]
  http://libml.org
  Copyright (C) 2002 - 2003  LAGACHERIE Matthieu RICORDEAU Olivier
  
  This program is free software; you can redistribute it and/or
  modify it under the terms of the GNU General Public License
  as published by the Free Software Foundation; either version 2
  of the License, or (at your option) any later version. This
  program is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  GNU General Public License for more details. You should have
  received a copy of the GNU General Public License
  along with this program; if not, write to the Free Software
  Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307,
  USA.
  
  SPECIAL NOTE (the beerware clause):
  This software is free software. However, it also falls under the beerware
  special category. That is, if you find this software useful, or use it
  every day, or want to grant us for our modest contribution to the
  free software community, feel free to send us a beer from one of
  your local brewery. Our preference goes to Belgium abbey beers and
  irish stout (Guiness for strength!), but we like to try new stuffs.

  Authors:
  Matthieu LAGACHERIE
  E-mail : matthieu@libml.org
  
  Olivier RICORDEAU
  E-mail : olivier@libml.org

 ****************************************************************)

(**
  Common functions (utilities). No class or module here.
*)

(**
  Converts a string which represents a float array to a real float array.
  Ex: "[2;0.5;3]" -> [|2.;0.5;3.|]
  @return The corresponding float array.
*)
let float_array_of_string str =
  let token = ref "" and
    list = ref [] in
  let rec arrayFromStringRec str =
    match String.sub str 0 1 with
      | "[" -> arrayFromStringRec (String.sub str 1 (String.length str - 1)) 
      | ";" -> list := !list@[float_of_string !token];
	  token := "";
	  arrayFromStringRec (String.sub str 1 (String.length str - 1)) 
      | "]" -> list := !list@[float_of_string !token]
      | _ as c -> token := Printf.sprintf "%s%s" !token c;
	  arrayFromStringRec (String.sub str 1 (String.length str - 1)) 
  in arrayFromStringRec str; Array.of_list !list;;

(**
  Converts a float array to a string.
  Ex: [|2.;0.5;3.|] -> "[2;0.5;3]"
  @return The corresponding string.
*)
let string_of_float_array array =
  let len = Array.length array - 1 and
    str = ref "[" in
    begin
      str := if len >= 0 then
	Printf.sprintf "%s%s" !str (string_of_float(array.(0))) else !str;
      for i = 1 to len do
	str := Printf.sprintf "%s;%s" !str (string_of_float(array.(i)));
      done;
      str := Printf.sprintf "%s]" !str;
      !str
    end;;

(**
  Converts a int array to a string.
  Ex: [|2;0;3|] -> "[2;0;3]"
  @return The corresponding string.
*)
let string_of_int_array array =
  let len = Array.length array - 1 and
    str = ref "[" in
    begin
      str := if len >= 0 then
	Printf.sprintf "%s%s" !str (string_of_int(array.(0))) else !str;
      for i = 1 to len do
	str := Printf.sprintf "%s;%s" !str (string_of_int(array.(i)));
      done;
      str := Printf.sprintf "%s]" !str;
      !str
    end;;

(**
  Converts a string which represents a int array to a real int array.
  Ex: "[2;0.5;3]" -> [|2.;0.5;3.|]
  @return The corresponding int array.
*)
let int_array_of_string str =
  let token = ref "" and
    list = ref [] in
  let rec arrayFromStringRec str =
    match String.sub str 0 1 with
      | "[" -> arrayFromStringRec (String.sub str 1 (String.length str - 1)) 
      | ";" -> list := !list@[int_of_string !token];
	  token := "";
	  arrayFromStringRec (String.sub str 1 (String.length str - 1)) 
      | "]" -> list := !list@[int_of_string !token]
      | _ as c -> token := Printf.sprintf "%s%s" !token c;
	  arrayFromStringRec (String.sub str 1 (String.length str - 1)) 
  in arrayFromStringRec str; Array.of_list !list;;

(**
  Converts a float array array to a string.
  Ex: [|[|2.;3.|];[|0.5|];[|3.|]|] -> "[2;3]\n[0.5]\n[3]"
  @return The corresponding string.
*)
let string_of_float_array_array array =
  let res = ref "" and
    len = Array.length array - 1 in
    begin
      res := if len >= 0 then string_of_float_array(array.(0)) else !res;
      for i = 1 to len do
	res := Printf.sprintf "%s\n%s" !res (string_of_float_array(array.(i)))
      done;
      !res
    end

(**
  Converts a float array array array to a string.
  @return The corresponding string.
*)
let string_of_float_array_array_array array =
  let res = ref "" and
    len = Array.length array - 1 in
    begin
      res := if len >= 0 then string_of_float_array_array(array.(0)) else !res;
      for i = 1 to len do
	res := Printf.sprintf "%s\n%s" !res (string_of_float_array_array(array.(i)))
      done;
      !res
    end
