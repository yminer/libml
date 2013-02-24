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
  @since 07/08/2003
  @param 'a A class parameter. Actually, the 'a type is the pattern type.
  @see 'pattern.ml' Corpus is mainly designed to store instances of the pattern
  class.
*)

open Pattern
open Xmlizable
open Speaking
open CommonXml

class corpus =
object(this)
  
  inherit xmlizable

  inherit speaking

  initializer
    _className <- "corpus"
      
  (**
    The patterns list.
  *)
  val mutable _patterns = []
			    
  (** The learning position (the cuurent posistion in the corpus during
    learning phase).
  *)
  val mutable _learnPos = 0

  (**
    A get*.
    @return the patterns list.
  *)
  method getPatterns =
    _patterns

  (**
    A get*.
    @return the nth pattern stored in the object.
  *)
  method getPattern index =
    List.nth _patterns index

  (**
    A get*.
    @return how many patterns are stored in the object.
  *)
  method getPatternNumber =
    List.length _patterns

  (**
    Adds a pattern to the object's patterns set.
  *)
  method addPattern (thePattern : pattern) =
    _patterns <- thePattern::_patterns
      
  (**
    Get the current learning position
  *)
  method getLearnPos =
    _learnPos

  (**
    Set the current learning position
  *)
  method setLearnPos nb =
    _learnPos <- nb
      
  (**
    Increment the current learning position.
  *)
  method incLearnPos =
    let increment learnPos = match learnPos with
	l when (l = List.length _patterns - 1)
	  -> 0
      | l -> l + 1
    in _learnPos <- increment _learnPos

  (**
    Get the current input learning vector.
  *)
  method getInputLearnVector pos =
    (List.nth _patterns pos)#getInput 

  (**
    Get the current output learning vector.
  *)
  method getOutputLearnVector pos =
    (List.nth _patterns pos)#getOutput

  (**
    Return the marshal of the object
  *)
  method getMarshal =
    let res = ref "" and
      len = List.length _patterns in
      begin
	for i = 0 to len - 1 do
	  res := Printf.sprintf "%s\nPATTERN:%d\n%s\n" !res i
	    (List.nth _patterns i)#getMarshal
	done;
	!res
      end

  (**
    Dumps this object as XML.
  *)
  method toXml =
    this#out "Dumping corpus as XML ..." 5;
    let rec dumpPatterns (patterns) = 
      match patterns with
	  [] -> ("")
	| h::t -> ((h#toXml) ^ (dumpPatterns t))
    in
      CommonXml.openTag "corpus" ^
      (dumpPatterns this#getPatterns)^
      CommonXml.closeTag "corpus"
	
end
  
