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
  alpha memory
*)

(**
  WME (Working Memory Element)
*)

class wme =
object
  
  (**
    The symbols of the rule.
    Ordered this way: identifier, attribute, then value.
  *)
  (* warning: check if the initial value doesn't lead to problems *)
  val mutable _fields : string array = Array.create 3 ""
  
  (**
    @return the value of a given field of this wme.
  *)
  method getField (sym : symbol) =
    _fields.(getIndex(sym))
	  
  (**
    Sets the value of the field corresponding to a given symbol.
    @param sym A symbol saying which field has to be changed.
    @param value The new value that has to be set.
  *)
  method setField (sym: symbol, value : string) =
    (_fields.(getIndex(sym)) <- value)
    
  (**
    @return the index in _fields which fits the sym parameter.
    @param sym The symbol for which we want the index in _fields.
  *)
  method private getIndex (sym : symbol)
    match sym with
	Identifier -> 0
      | Attribute -> 1
      | Value -> 2

end

(**
  
*)

class alphaMemory =
object
  
  val mutable _items : wme list = []
	
  (**
    A get*
    @return the wme list contained in this alphaMemory
  *)
  method getItems =
    _items
      
  (**
    A list of this node's successors
  *)
  val mutable _successors : reteNode list = []
			
  (**
    
  *)
  method activate (wme : wme) =
    let rec doRightActivation (children : reteNode list, wme : wme) =
      (match children with
	   [] -> []
	 | h::t -> (h#rightActivation(); activate t wme)
      )
    in
      _items <- wme @ _items;
      doRightActivation _items
	
end

(* beta memory *)


(**
  
*)
class token =
object
  
  (**
    The parent token
  *)
  val mutable _parent : token = 
    
  method setParent (parent : token) =
    _parent <- parent
      
  (**
    The wme stored in this token
  *)
  val mutable _wme : wme =
    
  (**
    Sets this token's wme
  *)
  method setWme (wme : wme) =
    _wme <- wme

end


(**
  
*)
class betaMemory =
object

  inherit reteNode
  
  (**
    A list of the tokens in the betaMemory
  *)
  val mutable _items : token list = []
				      
  (**
    Performs a left activation on the betaMemory
  *)
  method leftActivation (token : token, wme : wme) =
    let newToken = new token in
      newToken#setParent token;
      newToken#setWme wme;
      _items <- newToken @ _items;
      let rec doLeftActivation (children : reteNode list, newToken : token) =
	(match children with
	     [] -> []
	   | h::t -> (g#leftActivation newToken; doLeftActivation t, newToken))
      in
	doLeftActivation _children newToken

end
 
(**
  
*) 
(* Implementation similar to memory nodes, selon le pdf *)
class joinNode =
object
  
  inherit reteNode
    
  (**
    
  *)
  val mutable _alphaMemory : alphaMemory = 

  (**    
    A list of the tests for this node.
  *)
  val mutable _tests : testAtJoinNode list = []

  (**
    Performs a right activation
  *)
  method rightActivation (wme : wme) =
    (* _parent is the beta memory node *)
    (* type problem for _parent? *)
    let rec activate (current : token) =
      if (this#performJoinTests (this#_tests) current wme) then
	( List.iter
	    ( (fun : arg -> arg#leftActivation(current, wme)) )
	    (_children) )
    in
      List.iter activate (this#getParent()#getItems())

  method leftActivation (tok : token)
  let applied (w : wme) =
    ( if (this#performJoinTests tok w) then
	(
	  List.iter
	   (fun (node : reteNode) -> node#leftActivation)
	   (this#getChildren)
	)
    )
  in
    List.iter applied (this#getAlphaMemory()#getItems())

  method performJoinTests (tok : token, w : wme) =
    let rec checkTests (tests : testAtJoinNode list, tok : token, w : wme) =
      match tests with
	  [] -> true
	| h::t ->
	    (
	      let arg1 : string = w#getField(h#getFieldOfArg1()) and
		wme2 : wme = ????????? and
		arg2 : string = wme2#getField(h#getFieldOfArg1())
	      in
		if (arg1 = arg2) then (checkTests t tok w)
		else false
	    )
    in
      checkTests _tests tok w
      
end
  
(**
  
*)
type symbol =
    Identifier
  | Attribute
  | Value

(**

*)
class testAtJoinNode =
object(this)

  val mutable _fieldOfArg1 : symbol = Identifier

  method setFieldOfArg1 (sym : symbol) =
    _fieldOfArg1 <- sym

  method getFieldOfArg1 =
    _fieldOfArg1

  val mutable _conditionNumberOfArg2 : int = 0
					       
  method setConditionNumberOfArg2 (value: int) =
    (* shouldn't this value be checked? *)
    _conditionNumberOfArg2 <- value

  method getConditionNumberOfArg2 =
    _conditionNumberOfArg2

  val mutable _fieldOfArg2 : symbol = Identifier
					
  method setFieldOfArg2 (sym : symbol) =
    _fieldOfArg2 <- sym

  method getFieldOfArg1 =
    _fieldOfArg1

end

(**

*)
(* TODO *)
class pNode
object

  inherit reteNode

end

(**

*)
(* pour l'instant 3 classes dérivent de reteNode, mais voir le pdf p.36:
   il dit qu'il y en a d'autres *)
class virtual reteNode =
object

  (**
    
  *)
  val mutable _children : reteNode list = []

  (**
    
  *)
  val mutable _parent : reteNode = 

  (**
    @return this node's parent
  *)
  method getParent =
    _parent

  (**
    
  *)
  method setParent (value : reteNode) =
    _parent <- value

end

