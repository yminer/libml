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
  The Pattern module.

  @author Matthieu Lagacherie
  @author Olivier Ricordeau
  @since 07/08/2003
  @param 'a A class parameter. It's actually a pattern object.
  @see 'corpus.ml' A corpus is a set of patterns.
*)

open Xmlizable
open CommonXml
open Speaking

(**
  The pattern class.
  @param 'a A class parameter. It's actually a pattern object.
*)
class pattern (inputVector : 'a) (outputVector : 'a) =
object(this)

  constraint 'a = float array

  inherit xmlizable
    
  inherit speaking

  initializer
    _className <- "pattern"
		    
  (**
    A vector which contains the pattern's inputs.
  *)
  val mutable _input = inputVector

  (**
    A vector which contains the pattern's outputs.
  *)
  val mutable _output = outputVector

  (**
    A get*.
    @return the input vector.
  *)
  method getInput = _input

  (**
    A get*.
    @return the output vector.
  *)
  method getOutput = _output
			
  (*  initializer match (inputVector, outputVector) with
    a, b when Array.length a != 0 && Array.length b != 0 -> ()
    | _, _ -> (Env.getEnv())#toChannel "Class Pattern : The input and output are empty.\n" *)

  (**
    A get*.
    @return the input vector's size.
  *)
  method getInputSize = Array.length _input

  (**
    A get*.
    @return the output vector's size.   
  *)
  method getOutputSize = Array.length _output


  (**
    Return the marshal of the object
  *)
  method getMarshal =
    Printf.sprintf "INPUT:\nLEN:%d\nDATA:%s\nOUTPUT:\nLEN:%d\nDATA:%s"
      (Array.length _input)
      (Common.string_of_float_array(_input))
      (Array.length _output)
      (Common.string_of_float_array(_output))

  (**
    Dumps this object as XML.
  *)
  method toXml = ""
(*    this#out "Dumping pattern as XML ..." 5;
    CommonXml.openTag "pattern" ^
    CommonXml.openTag "input" ^
    CommonXml.dump3dArray this#getInput string_of_float ^
    CommonXml.closeTag "input" ^
    CommonXml.openTag "output" ^
    CommonXml.dump3dArray this#getOutput string_of_float ^
    CommonXml.closeTag "output" ^ CommonXml.closeTag "pattern" *)

end
