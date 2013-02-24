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

open LearningObject

(**
  An expression is what can be found on the left and right parts of a rule.
*)
type exp =
    (* a variable name *)
    Var of string
      (* an integer *)
  | Int of int
      (* arithmetic operators *)
  | Plus of exp * exp
  | Minus of exp * exp
  | Mult of exp * exp
  | Div of exp * exp
      (* logical operators *)
  | Or of exp * exp
  | And of exp * exp
  | Not of exp
      (* comparison operators *)
  | Ge of exp * exp
  | Gt of exp * exp
  | Le of exp * exp
  | Lt of exp * exp

(**
  A rule is a => b where a and b are expressions.
*)
type rule = Implies of exp * exp
  
(**
  An abstract class representing an expert system. Contains the knowledge
  base and the facts base.
  
  @author Olivier Ricordeau
  @since 03/29/2004
*)
class virtual expertSystem =
object (this)
  
  inherit learningObject

  initializer
    _className <- "expertSystem";
    _classTag <- "expert-system"
      
  (**
    Contains the rules of the expert system.
  *)
  val mutable _knowledgeBase = Hashtbl.create 50

  (**
    Adds a rule to knowledge base
    @param ident an int identifier
    @param rule a string containing the rule to be added
  *)    
  method addRule (ident : int)  (rule : string) =
    Hashtbl.add _knowledgeBase ident (this#rule_of_string rule)

  (**
    Does the same as addRule, but with several rules.
  *)  
  method addRules (idents : int list) (rules : string list) =
    let addOne (ident : int) (rule : string) =
      this#addRule ident rule
    in
      try (List.iter2 addOne idents rules)
      with
	  Invalid_argument(a) -> this#err "identifier list and rules list don't have the same size. Aborting rules addition." 1
	    
  (**
    Removes a given rule.
    @param ident an int identifier representing the rule.
  *)
  method removeRule (ident : int) =
    Hashtbl.remove _knowledgeBase ident
    
  (**
    Parses a string and returns the corresponding rule.
  *)
  method private rule_of_string (rule : string) : rule =
    Implies (Int(0), Int(0))

  (**
    Contains the facts of the expert system.
  *)  
  val mutable _factsBase = ()
			     
end
