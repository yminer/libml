(*********************************************************************************)
(*                Odoc_check                                                     *)
(*                                                                               *)
(*    Copyright (C) 2004 Institut National de Recherche en Informatique et       *)
(*    en Automatique. All rights reserved.                                       *)
(*                                                                               *)
(*    This program is free software; you can redistribute it and/or modify       *)
(*    it under the terms of the GNU Lesser General Public License as published   *)
(*    by the Free Software Foundation; either version 2.1 of the License, or     *)
(*    any later version.                                                         *)
(*                                                                               *)
(*    This program is distributed in the hope that it will be useful,            *)
(*    but WITHOUT ANY WARRANTY; without even the implied warranty of             *)
(*    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the              *)
(*    GNU Lesser General Public License for more details.                        *)
(*                                                                               *)
(*    You should have received a copy of the GNU Lesser General Public License   *)
(*    along with this program; if not, write to the Free Software                *)
(*    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA                   *)
(*    02111-1307  USA                                                            *)
(*                                                                               *)
(*    Contact: Maxence.Guesdon@inria.fr                                          *)
(*                                                                               *)
(*********************************************************************************)

(* $Id: odoc_check.ml,v 1.1 2004/04/06 13:04:26 srv89 Exp $ *)

(**  @ocamldoc_generator A generator which performs some controls on the collected information.
  For example: all values are commented, all types are commented, all exceptions have
  a version tag, ... All the possible controls are turned on/off with command line options.
  @ocamldoc_compilation [ocamlc -I +ocamldoc -c odoc_check.ml]
  @ocamldoc_url odoc_check.ml
  @author Maxence Guesdon
*)

open Odoc_info.Value
open Odoc_info.Type
open Odoc_info.Exception
open Odoc_info.Class
open Odoc_info.Module

open Odoc_info


let options_can_be = "        <options> can be one or more of the following characters:"
let string_of_options_list l = 
  List.fold_left (fun acc -> fun (c, m) -> acc^"\n        "^(String.make 1 c)^"  "^m)
    ""
    l

let check_only = "(check only)"

let check_description = 'd', "description is mandatory"
let check_author = 'a', "author information is mandatory"
let check_since = 's', "@since tag is mandatory"
let check_version = 'v', "@version tag is mandatory"
let check_return = 'r', "@return tag is mandatory"
let check_params = 'p', "all named parameters must be described"
let check_fields_described = 'f', "All fields of a record type must be described"
let check_constructors_described = 'c', "All constructors of a type must be described"
let check_all = 'A', "all check checks"
let check_base_option_list = [ check_description ; check_author ; check_version ; check_since ; check_all ]
let m_check_type_options = 
  "<options>  specify check checks to perform on each type "^check_only^"\n"^
  options_can_be^
  (string_of_options_list ([check_fields_described ; check_constructors_described] @ check_base_option_list))
let m_check_val_met_att_options = 
  "<options>  specify check checks to perform on each value, method or attribute "^check_only^"\n"^
  options_can_be^
  (string_of_options_list (check_params :: check_return :: check_base_option_list ))
let m_check_exception_options = 
  "<options>  specify check checks to perform on each exception "^check_only^"\n"^
  options_can_be^
  (string_of_options_list check_base_option_list)
let m_check_class_options = 
  "<options>  specify check checks to perform on each class and class type "^check_only^"\n"^
  options_can_be^
  (string_of_options_list (check_params :: check_base_option_list))
let m_check_module_options = 
  "<options>  specify check checks to perform on each module and module type "^check_only^"\n"^
  options_can_be^
  (string_of_options_list check_base_option_list)

(** The kind of checks which can be performed on elements. *)
type check =
  | Has_description (** the element has an associated description *)
  | Has_author (** the element's description has one or more \@author tag(s) *)
  | Has_since  (** the element's description has a \@since tag *)
  | Has_version (** the element's description has a \@version tag *)
  | Has_return (** the function's description has a \@return tag *)
  | Has_params (** all the named parameters of the element has a description *)
  | Has_fields_decribed (** all the fields of the type are described *)
  | Has_constructors_decribed (** all the constructors of the type are described *)

(** The list of all checks. *)
let all_checks = [
  Has_description ;
  Has_author ;
  Has_since ;
  Has_version ;
  Has_return ;
  Has_params ;
  Has_fields_decribed ;
  Has_constructors_decribed ;
] 

let check_type_options = ref ([] : check list)
let check_val_options = ref ([] : check list)
let check_exception_options = ref ([] : check list)
let check_class_options = ref ([] : check list)
let check_module_options = ref ([] : check list)

(** Analysis of a string defining options. Return the list of
  options according to the list giving associations between
  [(character, _)] and a list of options. *)
let analyse_option_string l s =
  List.fold_left
    (fun acc -> fun ((c,_), v) ->
       if String.contains s c then
	 acc @ v
       else
	 acc)
    []
    l

(** Analysis of a string defining the check checks to perform. 
  Return the list of checks specified.*)
let analyse_checks s =
  let l = [
    (check_description, [Has_description]) ;
    (check_author, [Has_author]) ;
    (check_since, [Has_since]) ;
    (check_version, [Has_version]) ;
    (check_return, [Has_return]) ;
    (check_params, [Has_params]) ;
    (check_fields_described, [Has_fields_decribed]) ;
    (check_constructors_described, [Has_constructors_decribed]) ;
    (check_all, all_checks)
  ] 
  in
    analyse_option_string l s

(** check messages *)

let has_no_description n = n^" has no description."
let has_no_author n = n^" has no author."
let has_no_since n = n^" has no @since tag."
let has_no_version n = n^" has no @version tag."
let has_no_return n = n^" has no @return tag."
let has_not_all_params_described n = n^" has not all its parameters described."
let has_not_all_fields_described n = n^" has not all its fields described."
let has_not_all_cons_described n = n^" has not all its constructors described."

let value_n n = "Value "^n
let type_n n = "Type "^n
let exception_n n = "Exception "^n
let attribute_n n = "Attribute "^n
let method_n n = "Method "^n
let class_n n = "Class "^n
let class_type_n n = "Class type "^n
let module_n n = "Module "^n
let module_type_n n = "Module type "^n


let (<@) e l = List.mem e l

(** The generator class. *)
class checkgen =
object (self)
  inherit Odoc_info.Scan.scanner

  method print_fail s = 
    incr Odoc_info.errors ;
    print_string s ; print_newline ()

  method check_info_error_messages =
    [
      Has_author, self#check_authors, has_no_author ;
      Has_since, self#check_since, has_no_since ;
      Has_version, self#check_version, has_no_version ;
      Has_return, self#check_return, has_no_return ;
    ] 

  method check_authors i = i.i_authors <> []
  method check_since i = i.i_since <> None
  method check_version i = i.i_version <> None
  method check_return i = i.i_return_value <> None

  method check_info prefix lchecks info_opt =
    match info_opt with
	None ->
	  if Has_description <@ lchecks then
	    self#print_fail (has_no_description prefix);

	  List.iter
	    (fun (check, f, m) ->
	       if check <@ lchecks then
		 self#print_fail (m prefix)
	       else
		 ()
	    )
	    self#check_info_error_messages

      |	Some i ->
	  List.iter
	  (fun (check, f, m) ->
	     if check <@ lchecks then
	       if not (f i) then
		 self#print_fail (m prefix)
	       else
		 ()
	  )
	  self#check_info_error_messages

  method check_params l =
    let rec iter = function
      | Parameter.Simple_name sn ->
	  (sn.Parameter.sn_text <> None) or
	  (sn.Parameter.sn_name = "")
      | Parameter.Tuple (l, _) ->
	  List.for_all iter l
    in
      List.for_all iter l

  method check_type_fields l =
    List.for_all (fun f -> f.rf_text <> None) l

  method check_type_constructors l =
    List.for_all (fun c -> c.vc_text <> None) l

  method scan_value v = 
    let prefix = value_n v.val_name in
      self#check_info
	prefix
	!check_val_options 
	v.val_info;
      if Has_params <@ !check_val_options then
	if not (self#check_params v.val_parameters) then
	  self#print_fail (has_not_all_params_described prefix)

  method scan_type t = 
    let prefix = type_n t.ty_name in
      self#check_info
	prefix
	!check_type_options 
	t.ty_info;
      match t.ty_kind with
	  Type.Type_record (l, priv) when Has_fields_decribed <@ !check_type_options ->
	    if not (self#check_type_fields l) then
	      self#print_fail (has_not_all_fields_described prefix)

	|	 Type.Type_variant (l, priv) when Has_constructors_decribed <@ !check_type_options ->
		   if not (self#check_type_constructors l) then
		     self#print_fail (has_not_all_cons_described prefix)

	| _ ->
	    ()

  method scan_exception e = 
    self#check_info
      (exception_n e.ex_name) 
      !check_exception_options 
      e.ex_info;

  method scan_attribute a = 
    self#check_info
      (attribute_n a.att_value.val_name) 
      !check_val_options 
      a.att_value.val_info;

  method scan_method m = 
    let prefix=  method_n m.met_value.val_name in
      self#check_info
	prefix
	!check_val_options 
	m.met_value.val_info;
      if Has_params <@ !check_val_options then
	if not (self#check_params m.met_value.val_parameters) then
	  self#print_fail (has_not_all_params_described prefix)

  method scan_class_pre c = 
    let prefix = class_n c.cl_name in
      self#check_info
	prefix
	!check_class_options 
	c.cl_info;
      if Has_params <@ !check_class_options then
	if not (self#check_params c.cl_parameters) then
	  self#print_fail (has_not_all_params_described prefix);
      true

  method scan_class_type_pre ct = 
    self#check_info
      (class_type_n ct.clt_name) 
      !check_class_options 
      ct.clt_info;
    true

  method scan_module_pre m = 
    let prefix = module_n m.m_name in
      self#check_info
	prefix
	!check_module_options 
	m.m_info; 
      true

  method scan_module_type_pre mt = 
    let prefix = module_type_n mt.mt_name in
      self#check_info
	prefix
	!check_module_options 
	mt.mt_info; 
      true

  method generate = self#scan_module_list

end;;

Args.add_option
  ("-check-val", Arg.String (fun s -> check_val_options := analyse_checks s), m_check_val_met_att_options) ;;
Args.add_option
  ("-check-cl", Arg.String (fun s -> check_class_options := analyse_checks s), m_check_class_options) ;;
Args.add_option
  ("-check-mod", Arg.String (fun s -> check_module_options := analyse_checks s), m_check_module_options) ;;
Args.add_option
  ("-check-ex", Arg.String (fun s -> check_exception_options := analyse_checks s), m_check_exception_options) ;;
Args.add_option
  ("-check-ty", Arg.String (fun s -> check_type_options := analyse_checks s), m_check_type_options^"\n") ;;

Args.set_doc_generator (Some ((new checkgen) :> Args.doc_generator))
