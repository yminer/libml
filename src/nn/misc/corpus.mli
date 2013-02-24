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
  The Corpus class
  A corpus is a set of several patterns. This set is stored in the _patterns
  attribute, which is a list of instances of the pattern class.

  @author Matthieu Lagacherie
  @author Olivier Ricordeau
  @since 09/04/2003
  @see 'pattern.ml' Corpus is mainly designed to store instances of the pattern
  class.
*)

open Pattern
open Xmlizable
open Speaking

class corpus :
object
  
  inherit xmlizable
    
  inherit speaking
    
  (**
    The patterns list.
  *)
  val mutable _patterns : pattern list
			    
  (** The learning position (the cuurent posistion in the corpus during
    learning phase).
  *)
  val mutable _learnPos : int

  (**
    A get*.
    @return the patterns list.
  *)
  method getPatterns : pattern list

  (**
    A get*.
    @return the nth pattern stored in the object.
  *)
  method getPattern : int -> pattern

  (**
    A get*.
    @return how many patterns are stored in the object.
  *)
  method getPatternNumber : int

  (**
    Adds a pattern to the object's patterns set.
  *)
  method addPattern : pattern -> unit

  (**
    Get the current learning position
  *)
  method getLearnPos : int

  (**
    Set the current learning position
  *)
  method setLearnPos : int -> unit

  (**
    Increment the current learning position.
  *)
  method incLearnPos : unit

  (**
    Get the current input learning vector.
  *)
  method getInputLearnVector : int -> float array

  (**
    Get the current output learning vector.
  *)
  method getOutputLearnVector : int -> float array

  (**
    Return the marshal of the object
  *)
  method getMarshal : string
    
  (**
    Dumps this object as XML.
  *)
  method toXml : string
    
end
