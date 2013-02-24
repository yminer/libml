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
  The factory class.
*)

open MlpNN
open Session
open MlObject
open Create

class factory =
object

  method acceptVisitor (obj : int) (visitor : int) = 
    let mlObj = ((getSession())#getMlObject obj) and
      vObj = ((getSession())#getMlObject visitor) in
      match mlObj with
	  MlpNN mlObj when mlObj#getClassName = "mlpNN" ->
	    begin
	      match vObj with
		  MlpnnVisitor vObj when vObj#getClassName = "mlpnnVisitor" ->
		    mlObj#accept vObj; 0
		| _ -> -1
	    end
	| _ -> -1
	    
  method createObject (ident : string) = match ident with
    | "MlpNN" -> createMlpNN ident
    | "InitMlpnnVisitor" -> createInitMlpnnVisitor ident
    | "InitMlpnnConstVisitor" -> createInitMlpnnConstVisitor ident
    | "InputMlpnnVisitor" -> createInputMlpnnVisitor ident
    | "InputMlpnnStdVisitor" -> createInputMlpnnStdVisitor ident
    | "PropagateMlpnnVisitor" -> createPropagateMlpnnVisitor ident
    | "PropagateMlpnnStdVisitor" -> createPropagateMlpnnStdVisitor ident
    | "PropagateMlpnnOptimizedVisitor" ->
	createPropagateMlpnnOptimizedVisitor ident
    | "ErrorMlpnnVisitor" -> createErrorMlpnnVisitor ident
    | "ErrorMlpnnStdVisitor" -> createErrorMlpnnStdVisitor ident
    | "ErrorMlpnnOptimizedVisitor" ->
	createErrorMlpnnOptimizedVisitor ident
    | "LearnMlpnnStochVisitor" -> createLearnMlpnnStochVisitor ident
    | "LearnMlpnnStdVisitor" -> createLearnMlpnnStdVisitor ident
    | _ -> -1

  method memObject (ident : int) =
    match ((getSession())#memMlObject ident) with
	false -> -1
      | true -> 0

end
