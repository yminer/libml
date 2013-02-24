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
   The inputTdnnVisitor class

   @author Matthieu Lagacherie
   @author Olivier Ricordeau
   @since 10/08/2003
 *)

open Nn
open InputVisitor
open DefaultVisitor
open TdNN

class inputTdnnVisitor =
object(this)
    inherit [tdNN] inputVisitor
      
    initializer
      _className <- "inputTdnnVisitor"

	  (**
	     The method which activate the input layer.
	     The activation of the Tdnn can be done with several methods :
           * ^    *   ^    *  ^    *  ^
	   * /   *    /   *   /   *   /
	   * /  *     /  *    /  *    /
	     Here a tdnn with an input layer of 4 neurons on the temporal
	     direction and 3 neurons on the feature drection.
	     The signal (the kind of arrow --->) is initialized in a first 
	     time on the feature direction and in a second time on the temporal
	     direction.
	   *)
    method visit (network : tdNN) = 
      let inputSum = network#getInputSum and
	  inputLearnVector = network#getInputLearnVector in
      match (!inputSum, inputLearnVector) with
	(a, b) when
	  (Array.length a.(0) * Array.length a.(0).(0)) !=
	  Array.length inputLearnVector
	  -> this#err "inputSum and inputLearnVector don't have the same size. skipping task." 1
      | _ -> 
	  begin
	    for j = 0 to (network#getFeaturesNb.(0)) - 1 do
	      for k = 0 to (network#getTimeNb.(0)) - 1 do
(*
   Debug
   Printf.printf "!inputSum.(0).(%d).(%d) <- inputLearnVector.(%d + %d)\n" j k j k;
 *)
		!inputSum.(0).(j).(k) <- inputLearnVector.(j + k)
	      done
	    done 
	  end

  end
