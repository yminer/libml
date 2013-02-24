(*********************************************************************************)
(*                Odoc_fhtml                                                     *)
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

(* $Id: odoc_fhtml.ml,v 1.1 2004/04/06 13:04:26 srv89 Exp $ *)

(** @ocamldoc_generator Generation of html documentation with frames. 
  @ocamldoc_url odoc_fhtml.ml
  @ocamldoc_compilation [ocamlc -I +ocamldoc -c odoc_fhtml.ml]
  @author Maxence Guesdon

*)

open Odoc_info 
open Parameter
open Value
open Type
open Exception
open Class 
open Module

module Naming = Odoc_html.Naming


(** The optional directory name which contains the classic html doc, to
  add links to this doc. *)
let link_classic = ref None

(** class for generating a framed html documentation.*)
class framed_html =
object (self)
  inherit Odoc_html.html as html

  (** the color for type expressions. *)
  val mutable type_color = "#664411"
			     
  (** We redefine the init_style method to add some default options to the style,
    before calling html#init_style. *)
  method init_style =
    (* we add a default style option *)
    default_style_options <- 
    default_style_options @
    [
      ".type { font-weight : bold ; color : "^type_color^" }" ;
      ".function { font-weight : bold ; font-size : larger ; background-color : #CCDDFF }" ;
      ".module { font-weight : bold ; font-size : larger ; background-color : #CCDDFF }" ;
      ".class { font-weight : bold ; font-size : larger ; background-color : #CCDDFF }" ;
      ".elementname { font-size : larger }" ;
      ".mutable { font-size : smaller }" ;
      ".filename { font-size : smaller }" ;
      ".header { font-size : 22pt ; background-color : #CCCCFF  ; font-weight : bold}" ;
      ".info { margin-left : 0 ; margin-right : 0 }" ;
    ] ;
    html#init_style


  (** A method to build the header of pages, different from the one of the simple html, 
    because we can't display indexes in the detailsFrame. *)
  method prepare_header module_list =
    let s = "<head>"^style^"<title>" in
      header <- (fun ?(nav=None) -> fun ?(comments=[]) -> 
	           fun t -> s^t^"</title>\n</head>\n")

  (** Generate the code for a table of the given list of values,
    in the given out_channel.*)
  method generate_values_table chanout value_list =
    match value_list with
	[] ->
	  ()
      | _ ->
	  output_string chanout (
	    "<table border=\"1\" cellpadding=\"3\" cellspacing=\"0\" width=\"100%\">\n"^
	    "<TR>\n"^
	    "<TD class=\"header\" colspan=2>\n"^Odoc_messages.values^"</TD>\n"^
	    "</TR>\n"^
	    (String.concat ""
	       (List.map
		  (fun v ->
		     Odoc_info.reset_type_names () ;
		     "<TR>\n"^
		     "<TD class=\"elementname\" ALIGN=\"right\" VALIGN=\"top\" width=\"1%\">\n"^
                     (* html target *)
		     "<a name=\""^(Naming.value_target v)^"\"></a>\n"^
		     "<code>"^
		     (match v.val_code with 
			  None -> Name.simple v.val_name
			| Some c -> 
			    let file = Naming.file_code_value_complete_target v in
			      self#output_code v.val_name (Filename.concat !Args.target_dir file) c;
			      "<a href=\""^file^"\">"^(Name.simple v.val_name)^"</a>"
		     )^
		     "</code></TD>\n"^
		     "<TD>"^(self#html_of_type_expr (Name.father v.val_name) v.val_type)^"<br>\n"^
		     (self#html_of_info v.val_info)^
		     "</TR>\n"
		  )
		  value_list
	       )
	    )^
	    "</table><br>\n"
	  )

  (** Generate the code for a table of the given list of exceptions,
    in the given out_channel.*)
  method generate_exceptions_table chanout excep_list =
    match excep_list with
	[] ->
	  ()
      | _ ->
	  output_string chanout (
	    "<table border=\"1\" cellpadding=\"3\" cellspacing=\"0\" width=\"100%\">\n"^
	    "<TR>\n"^
	    "<TD class=\"header\" colspan=2>\n"^Odoc_messages.exceptions^"</TD>\n"^
	    "</TR>\n"^
	    (String.concat ""
	       (List.map
		  (fun e ->
		     Odoc_info.reset_type_names () ;
		     "<TR>\n"^
		     "<TD class=\"elementname\" ALIGN=\"right\" VALIGN=\"top\" width=\"1%\">\n"^
                     (* html target *)
		     "<a name=\""^(Naming.exception_target e)^"\"></a>\n"^
		     
		     "<code>"^(Name.simple e.ex_name)^"</code></TD>\n"^
		     "<TD>"^
		     (
		       match e.ex_args with
			   [] -> ""
			 | _ -> 
			     (self#keyword "of&nbsp;&nbsp;")^
			     (self#html_of_type_expr_list (Name.father e.ex_name) " * " e.ex_args)^
			     "<br>\n"
		     )^
		     (self#html_of_info e.ex_info)^
		     " </TD>\n"^
		     "</TR>\n"
		  )
		  excep_list
	       )
	    )^
	    "</table><br>\n"
	  )

  (** Generate the code for a table of the given list of types,
    in the given out_channel.*)
  method generate_types_table chanout type_list =
    match type_list with
	[] ->
	  ()
      | _ ->
	  output_string chanout (
	    "<table border=\"1\" cellpadding=\"3\" cellspacing=\"0\" width=\"100%\">\n"^
	    "<TR>\n"^
	    "<TD class=\"header\" colspan=2>\n"^Odoc_messages.types^"</TD>\n"^
	    "</TR>\n"^
	    (String.concat ""
	       (List.map
		  (fun t ->
		     Odoc_info.reset_type_names () ;
		     let father = Name.father t.ty_name in
		       "<TR>\n"^
		       "<TD class=\"elementname\" ALIGN=\"right\" VALIGN=\"top\" width=\"10%\">\n"^
	               (* html mark *)
		       "<a name=\""^(Naming.type_target t)^"\"></a>\n"^
		       "<code>"^
		       (self#html_of_type_expr_param_list father t)^
		       (match t.ty_parameters with [] -> "" | _ -> " ")^
		       (Name.simple t.ty_name)^"</code></TD>\n"^
		       "<TD>\n"^
		       (self#html_of_info t.ty_info)^
		       (
			 match t.ty_manifest with
			   | None -> ""
			   | Some type_exp -> "= "^(self#html_of_type_expr father type_exp)^"<br>\n")^
		       (
			 match t.ty_kind with
			     Type_abstract ->
			       if t.ty_manifest = None then Odoc_messages.abstract else ""
			   | Type_variant (l, priv) ->
			       "<table cellpadding=\"3\" cellspacing=\"0\" width=\"100%\">\n"^
			       "<TR><TD ALIGN=\"left\" VALIGN=\"top\" width=\"1%\"><code>= "^
			       (if priv then "private" else "")^"</code></TD>\n"^
			       (String.concat "</TR>\n<TR><TD ALIGN=\"left\" VALIGN=\"top\" width=\"1%\"><code> | </code></TD>\n"
				  (List.map
				     (fun constr ->
					"\n"^
					"<TD ALIGN=\"left\" VALIGN=\"top\" width=\"1%\">\n"^
					"<code>"^(self#constructor constr.vc_name)^"</code></TD>\n"^
					"<TD ALIGN=\"left\" VALIGN=\"top\" width=\"100%\">\n"^
					(match constr.vc_args with
					     [] -> 
					       ""
					   | l -> 
					       (self#keyword "of&nbsp;&nbsp;")^(self#html_of_type_expr_list father " * " constr.vc_args)^
					       "<br>\n"
					)^
					(match constr.vc_text with None -> "" | Some d -> (self#html_of_text d)^"<br>\n")
				     )
				     l
				  )
			       )^"</TR>\n</table>\n"
			       
			   | Type_record (l, priv) ->
			       "= "^(if priv then "private" else "")^"{<br>\n"^
			       "<table cellpadding=\"3\" cellspacing=\"0\" width=\"100%\">\n"^
			       (String.concat ""
				  (List.map
				     (fun r ->
					"<TR>\n"^
					"<TD ALIGN=\"right\" VALIGN=\"top\" width=\"1%\">\n"^
					"<code>"^r.rf_name^
					(if r.rf_mutable then "<br><span class=\"mutable\">("^Odoc_messages.mutab^")</span>" else "")^
					"</code></TD>\n"^
					"<TD>\n"^
					":&nbsp;&nbsp;"^(self#html_of_type_expr father r.rf_type)^" ;"^
					"<br>\n"^
					(match r.rf_text with None -> "" | Some d -> (self#html_of_text d)^"<br>\n")
				     )
				     l
				  )
			       )^
			       "</table>\n"^
			       "}"
		       )^
		       "</TD>\n"^
		       "</TR>\n"
		  )
		  type_list
	       )
	    )^
	    "</table><br>\n"
	  )
	  
  (** Generate the code for the given function,
    in the given out_channel.*)
  method generate_function_code chanout f =
    Odoc_info.reset_type_names () ;
    output_string chanout (
      "<table border=\"1\" cellpadding=\"3\" cellspacing=\"0\" width=\"100%\">\n"^
      "<TR class=\"function\">"^
      "<TD><code>\n"^
      (* html target *)
      "<a name=\""^(Naming.value_target f)^"\"></a>\n"^
      (match f.val_code with 
	   None -> Name.simple f.val_name
	 | Some c -> 
	     let file = Naming.file_code_value_complete_target f in
	       self#output_code f.val_name (Filename.concat !Args.target_dir file) c;
	       "<a href=\""^file^"\">"^(Name.simple f.val_name)^"</a>"
      )^
      "</code>\n"^
      ": "^(self#html_of_type_expr (Name.father f.val_name) f.val_type)^"<br>\n"^
      "</TD>\n"^
      "</TR></table>\n"^
      (* description *)
      (self#html_of_info f.val_info)^
      (* parameters *)
      (
	if !Args.with_parameter_list then
	  self#html_of_parameter_list (Name.father f.val_name) f.val_parameters
	else
	  self#html_of_described_parameter_list (Name.father f.val_name) f.val_parameters
      )^
      "<br>\n"
    )

  (** Generate the code for the given list of functions,
    in the given out_channel.*)
  method generate_function_list_code chanout fun_list =
    match fun_list with
	[] ->
	  ()
      | _ ->
	  output_string chanout (
	    "<table border=\"1\" cellpadding=\"3\" cellspacing=\"0\" width=\"100%\">\n"^
	    "<TR>\n"^
	    "<TD class=\"header\" colspan=2>\n"^Odoc_messages.functions^"</TD>\n"^
	    "</TR></table>\n"^
	    "<br>\n");
	  List.iter (self#generate_function_code chanout) fun_list ;
	  output_string chanout "<br>\n"

  (** Generate the code for the given module,
    in the given out_channel.*)
  method generate_module_code chanout m =
    let (html_file, _) = Naming.html_files m.m_name in
      output_string chanout
	("<table border=\"1\" cellpadding=\"3\" cellspacing=\"0\" width=\"100%\">\n"^
	 "<tr class=\"module\">"^
	 "<td><code>\n"^
	 "<a href=\""^html_file^"\">"^(Name.simple m.m_name)^"</a> : "^
	 (self#html_of_module_type (Name.father m.m_name) m.m_type)^
	 "</code></td></tr></table>\n");
      output_string chanout
	(self#html_of_info_first_sentence m.m_info);
      output_string chanout "<br>\n"

  (** Generate the code for the given list of modules,
    in the given out_channel.*)
  method generate_module_list_code chanout mod_list =
    match mod_list with
	[] ->
	  ()
      | _ ->
	  output_string chanout (
	    "<table border=\"1\" cellpadding=\"3\" cellspacing=\"0\" width=\"100%\">\n"^
	    "<tr>\n"^
	    "<td class=\"header\" colspan=2>\n"^
	    Odoc_messages.modules^"/"^Odoc_messages.functors^
	    "</td></tr>\n</table>\n"^
	    "<br>\n");
	  List.iter (self#generate_module_code chanout) mod_list ;
	  output_string chanout "<br>\n"

  (** Generate the code for the given module type,
    in the given out_channel.*)
  method generate_module_type_code chanout mt =
    let (html_file, _) = Naming.html_files mt.mt_name in
      output_string chanout
	("<table border=\"1\" cellpadding=\"3\" cellspacing=\"0\" width=\"100%\">\n"^
	 "<tr class=\"module\">"^
	 "<td><code>\n"^
	 "<a href=\""^html_file^"\">"^(Name.simple mt.mt_name)^"</a>"^
	 (match mt.mt_type with
	    | Some t -> " = "^(self#html_of_module_type (Name.father mt.mt_name) t)
	    | None  ->  ""
	 )^
	 "</code></td></tr></table>\n");
      output_string chanout
	(self#html_of_info_first_sentence mt.mt_info);
      output_string chanout "<br>\n"
	
  (** Generate the code for the given list of module types,
    in the given out_channel.*)
  method generate_module_type_list_code chanout modtype_list =
    match modtype_list with
	[] ->
	  ()
      | _ ->
	  output_string chanout (
	    "<table border=\"1\" cellpadding=\"3\" cellspacing=\"0\" width=\"100%\">\n"^
	    "<TR>\n"^
	    "<TD class=\"header\" colspan=2>\n"^
	    Odoc_messages.module_types^
	    "</TD></TR>\n</table>\n"^
	    "<br>\n");
	  List.iter (self#generate_module_type_code chanout) modtype_list ;
	  output_string chanout "<br>\n"

  (** Generate the code for the given class,
    in the given out_channel.*)
  method generate_class_code chanout m_name c =
    let (html_file, _) = Naming.html_files c.cl_name in
      output_string chanout
	("<table border=\"1\" cellpadding=\"3\" cellspacing=\"0\" width=\"100%\">\n"^
	 "<tr class=\"class\">"^
	 "<td>\n"^
	 (self#html_of_class ~complete: false { c with cl_info = None} )^
	 "</td></tr></table>");
      output_string chanout 
	(self#html_of_info_first_sentence c.cl_info) ;
      output_string chanout "<br>\n"

  (** Generate the code for the given list of classes,
    in the given out_channel.*)
  method generate_class_list_code chanout m_name cl_list =
    match cl_list with
	[] ->
	  ()
      | _ ->
	  output_string chanout (
	    "<table border=\"1\" cellpadding=\"3\" cellspacing=\"0\" width=\"100%\">\n"^
	    "<tr>\n"^
	    "<td class=\"header\" colspan=2>\n"^
	    Odoc_messages.classes^
	    "</td></tr>\n</table>\n"^
	    "<br>\n");
	  List.iter (self#generate_class_code chanout m_name) cl_list ;
	  output_string chanout "<br>\n"

	    
  (** Generate the code for the given class type,
    in the given out_channel.*)
  method generate_class_type_code chanout m_name ct =
    let (html_file, _) = Naming.html_files ct.clt_name in
      output_string chanout
	("<table border=\"1\" cellpadding=\"3\" cellspacing=\"0\" width=\"100%\">\n"^
	 "<tr class=\"class\">"^
	 "<td>\n"^
	 (self#html_of_class_type ~complete: false { ct with clt_info = None} )^
	 "</td></tr></table>");
      output_string chanout 
	(self#html_of_info_first_sentence ct.clt_info) ;
      output_string chanout "<br>\n"

  (** Generate the code for the given list of class types,
    in the given out_channel.*)
  method generate_class_type_list_code chanout m_name clt_list =
    match clt_list with
	[] ->
	  ()
      | _ ->
	  output_string chanout (
	    "<table border=\"1\" cellpadding=\"3\" cellspacing=\"0\" width=\"100%\">\n"^
	    "<tr>\n"^
	    "<td class=\"header\" colspan=2>\n"^
	    Odoc_messages.class_types^
	    "</td></tr>\n</table>\n"^
	    "<br>\n");
	  List.iter (self#generate_class_type_code chanout m_name) clt_list ;
	  output_string chanout "<br>\n"

  (** Generate the code for class inheritance of the given class,
    in the given out_channel.*)
  method generate_class_inheritance_info chanout cl = 
    let rec iter_kind k = 
      match k with
	  Class_structure ([], _) ->
	    ()
	| Class_structure (_, _) ->
	    output_string chanout (
	      "<table border=\"1\" cellpadding=\"3\" cellspacing=\"0\" width=\"100%\">\n"^
	      "<TR>\n"^
	      "<TD class=\"header\" colspan=2>\n"^Odoc_messages.inheritance^"</TD>\n"^
	      "</TR></table>\n"^
	      "<br>\n"^
	      (
		let dag = Odoc_dag2html.create_class_dag [cl] [] in
		  self#html_of_dag dag
              )^
	      "<br>\n"
	    )
	| Class_constraint (k,_) ->
	    iter_kind k
	| Class_apply _ 
	| Class_constr _ ->
	    ()
    in
      iter_kind cl.cl_kind

  (** Generate the code for class inheritance of the given class type,
    in the given out_channel.*)
  method generate_class_type_inheritance_info chanout clt = 
    match clt.clt_kind with
	Class_signature ([], _) ->
	  ()
      | Class_signature (_, _) ->
	  output_string chanout (
	    "<table border=\"1\" cellpadding=\"3\" cellspacing=\"0\" width=\"100%\">\n"^
	    "<TR>\n"^
	    "<TD class=\"header\" colspan=2>\n"^Odoc_messages.inheritance^"</TD>\n"^
	    "</TR></table>\n"^
	    "<br>\n"^
	    (
	      let dag = Odoc_dag2html.create_class_dag [] [clt] in
		self#html_of_dag dag
            )^
	    "<br>\n"
	  )
      |	Class_type _ ->
	  ()

  (** Generate the code for a table of the given list of attributes,
    in the given out_channel.*)
  method generate_attributes_table chanout att_list =
    match att_list with
	[] ->
	  ()
      | _ ->
	  output_string chanout (
	    "<table border=\"1\" cellpadding=\"3\" cellspacing=\"0\" width=\"100%\">\n"^
	    "<TR>\n"^
	    "<TD class=\"header\" colspan=2>\n"^Odoc_messages.attributes^"</TD>\n"^
	    "</TR>\n"^
	    (String.concat ""
	       (List.map
		  (fun att ->
		     let module_name = Name.father (Name.father att.att_value.val_name) in
		       "<TR>\n"^
		       "<TD class=\"elementname\" ALIGN=\"right\" VALIGN=\"top\" width=\"1%\">\n"^
		       "<code>"^
		       (match att.att_value.val_code with 
			    None -> Name.simple att.att_value.val_name
			  | Some c -> 
			      let file = Naming.file_code_attribute_complete_target att in
				self#output_code att.att_value.val_name (Filename.concat !Args.target_dir file) c;
				"<a href=\""^file^"\">"^(Name.simple att.att_value.val_name)^"</a>"
		       )^
		       "</code></TD>\n"^
		       "<TD>"^(self#html_of_type_expr module_name att.att_value.val_type)^"<br>\n"^
		       (self#html_of_info att.att_value.val_info)^
		       "</TR>\n"
		  )
		  att_list
	       )
	    )^
	    "</table><br>\n"
	  )
	  
  (** Generate the code for the given method,
    in the given out_channel.*)
  method generate_method_code chanout m =
    let module_name = Name.father (Name.father m.met_value.val_name) in
      output_string chanout (
	"<table border=\"1\" cellpadding=\"3\" cellspacing=\"0\" width=\"100%\">\n"^
	"<TR class=\"function\">\n"^
	"<TD><code>\n"^
	(* html target *)
	"<a name=\""^(Naming.method_target m)^"\"></a>\n"^
	(if m.met_private then (self#keyword "private")^" " else "")^
	(if m.met_virtual then (self#keyword "virtual")^" " else "")^
	(match m.met_value.val_code with 
	     None -> Name.simple m.met_value.val_name
	   | Some c -> 
	       let file = Naming.file_code_method_complete_target m in
		 self#output_code m.met_value.val_name (Filename.concat !Args.target_dir file) c;
		 "<a href=\""^file^"\">"^(Name.simple m.met_value.val_name)^"</a>"
	)^
	"</code>\n"^
	": "^(self#html_of_type_expr module_name m.met_value.val_type)^"<br>\n"^
	"</TD>\n"^
	"</TR></table>\n"^
	(* description *)
	(self#html_of_info m.met_value.val_info)^
	(* parameters *)
	(
	  if !Args.with_parameter_list then
	    self#html_of_parameter_list module_name m.met_value.val_parameters
	  else
	    self#html_of_described_parameter_list module_name m.met_value.val_parameters
	)^
	"<br>\n"
      )

  (** Generate the code for the given list of methods,
    in the given out_channel.*)
  method generate_method_list_code chanout met_list =
    match met_list with
	[] ->
	  ()
      | _ ->
	  output_string chanout (
	    "<table border=\"1\" cellpadding=\"3\" cellspacing=\"0\" width=\"100%\">\n"^
	    "<TR>\n"^
	    "<TD class=\"header\" colspan=2>\n"^Odoc_messages.methods^"</TD>\n"^
	    "</TR></table>\n"^
	    "<br>\n");
	  List.iter (self#generate_method_code chanout) met_list

  (** Generate the code of the html page for the given class.*)
  method generate_for_class _ _ cl =
    Odoc_info.reset_type_names () ;
    let (html_file, _) = Naming.html_files cl.cl_name in
    let type_file = Naming.file_type_class_complete_target cl.cl_name in
      try
	let chanout = open_out (Filename.concat !Args.target_dir html_file) in
	  output_string chanout
	    ("<html>\n"^
	     (self#header (self#inner_title cl.cl_name))^
	     "<body>\n"^
	     "<center><h1>"^
	     (
	       let s = Odoc_messages.clas in
		 match !link_classic with
		     None -> s
		   | Some d ->
		       let classic_file = Filename.concat d (fst (Naming.html_files cl.cl_name)) in
			 "<a href=\""^classic_file^"\">"^s^"</a>"
	     )^
	     " <a href=\""^type_file^"\">"^cl.cl_name^"</a>"^
	     "</h1></center>\n"^
	     "<br>\n"^
	     (self#html_of_class ~with_link: false cl)^
	     "<br>\n"
	    );
	  (* parameters *)
	  output_string chanout (self#html_of_parameter_list "" cl.cl_parameters) ;
          (* class inheritance *)
	  self#generate_class_inheritance_info chanout cl;    
          (* class attributes *)
	  self#generate_attributes_table chanout (Class.class_attributes ~trans: false cl);
          (* class methods *)
	  self#generate_method_list_code chanout (Class.class_methods ~trans: false cl);

	  output_string chanout "</html>";
	  close_out chanout;

          (* output the file containing the whole class type *)
	  self#output_class_type 
	    cl.cl_name
	    (Filename.concat !Args.target_dir type_file)
	    cl.cl_type
      with
	  Sys_error s ->
	    raise (Failure s)

  (** Generate the code of the html page for the given class type.*)
  method generate_for_class_type _ _ clt =
    Odoc_info.reset_type_names () ;
    let (html_file, _) = Naming.html_files clt.clt_name in
    let type_file = Naming.file_type_class_complete_target clt.clt_name in
      try
	let chanout = open_out (Filename.concat !Args.target_dir html_file) in
	  output_string chanout
	    ("<html>\n"^
	     (self#header (self#inner_title clt.clt_name)) ^
	     "<body>\n"^
	     "<center><h1>"^
	     (
	       let s = Odoc_messages.class_type in
		 match !link_classic with
		     None -> s
		   | Some d ->
		       let classic_file = Filename.concat d (fst (Naming.html_files clt.clt_name)) in
			 "<a href=\""^classic_file^"\">"^s^"</a>"
	     )^
	     " <a href=\""^type_file^"\">"^clt.clt_name^"</a>"^
	     "</h1></center>\n"^
	     "<br>\n"^
	     (self#html_of_class_type ~with_link: false clt)^
	     "<br>\n"
	    );
          (* class inheritance *)
	  self#generate_class_type_inheritance_info chanout clt;    
          (* class attributes *)
	  self#generate_attributes_table chanout (Class.class_type_attributes ~trans: false clt);
          (* class methods *)
	  self#generate_method_list_code chanout (Class.class_type_methods ~trans: false clt);

	  output_string chanout "</html>";
	  close_out chanout;

	  (* output the file containing the whole class type *)
	  self#output_class_type 
	    clt.clt_name
	    (Filename.concat !Args.target_dir type_file)
	    clt.clt_type
      with
	  Sys_error s ->
	    raise (Failure s)

  (** Generate the code for the main html file of the given module type,
    in the given out_channel, and for its submodules and classes. *)
  method generate_module_type_main chanout mt =
    let type_file = Naming.file_type_module_complete_target mt.mt_name in
      output_string chanout
	("<html>\n"^
	 (self#header (self#inner_title mt.mt_name)) ^
	 "<body>\n"^
	 "<center><h1>"^
	 (match !link_classic with
	      None -> Odoc_messages.module_type
	    | Some d ->
		let classic_file = Filename.concat d (fst (Naming.html_files mt.mt_name)) in
		  "<a href=\""^classic_file^"\">"^Odoc_messages.module_type^"</a>"
	 )^
	 " "^
	 (match mt.mt_type with
	      Some _ -> "<a href=\""^type_file^"\">"^mt.mt_name^"</a>"
	    | None-> mt.mt_name
	 )^
	 "</h1></center>\n"^
	 "<br>\n"^
	 (self#html_of_modtype ~with_link: false mt)
	);
      (* parameters *)
      (match Module.module_type_parameters mt with
	   [] -> output_string chanout "<br>\n"
	 |	l -> output_string chanout (self#html_of_module_parameter_list "" l)
      );
      (* modules/functors *)
      self#generate_module_list_code chanout (Module.module_type_modules mt);
      (* module types *)
      self#generate_module_type_list_code chanout (Module.module_type_module_types mt);
      (* classes *)
      self#generate_class_list_code chanout mt.mt_name (Module.module_type_classes mt);
      (* class types *)
      self#generate_class_type_list_code chanout mt.mt_name (Module.module_type_class_types mt);
      (* types *)
      self#generate_types_table chanout (Module.module_type_types mt);
      (* exceptions *)
      self#generate_exceptions_table chanout (Module.module_type_exceptions mt);
      (* values *)
      self#generate_values_table chanout (Module.module_type_simple_values mt);
      (* functions *)
      self#generate_function_list_code chanout (Module.module_type_functions mt);


      output_string chanout "</html>";
      
      (* generate html files for submodules *)
      self#generate_elements self#generate_for_module (Module.module_type_modules mt);
      (* generate html files for module types *)
      self#generate_elements self#generate_for_module_type (Module.module_type_module_types mt);
      (* generate html files for class types *)
      self#generate_elements self#generate_for_class_type (Module.module_type_class_types mt);
      (* generate html files for classes *)
      self#generate_elements self#generate_for_class (Module.module_type_classes mt);

      (* generate the file with the complete module type *)
      (
	match mt.mt_type with
	    None -> ()
	  | Some mty -> self#output_module_type 
	      mt.mt_name
	      (Filename.concat !Args.target_dir type_file)
	      mty
      )

  (** Generate the code for the main html file of the given module,
    in the given out_channel, and for its submodules and classes. *)
  method generate_module_main chanout modu =
    let type_file = Naming.file_type_module_complete_target modu.m_name in
      output_string chanout
	("<html>\n"^
	 (self#header (self#inner_title modu.m_name)) ^
	 "<body>\n"^
	 "<center><h1>"^
	 (
	   let s = if Module.module_is_functor modu then Odoc_messages.functo else Odoc_messages.modul in
	     match !link_classic with
		 None -> s
	       | Some d ->
		   let classic_file = Filename.concat d (fst (Naming.html_files modu.m_name)) in
		     "<a href=\""^classic_file^"\">"^s^"</a>"
	 )^
	 " <a href=\""^type_file^"\">"^modu.m_name^"</a>"^
	 "</h1></center>\n"^
	 "<br>\n"^
	 (self#html_of_module ~with_link: false modu)
	);
      (* parameters *)
      (match Module.module_parameters modu with
	   [] -> output_string chanout "<br>\n"
	 |	l -> output_string chanout (self#html_of_module_parameter_list "" l)
      );
      (* modules/functors *)
      self#generate_module_list_code chanout (Module.module_modules modu);
      (* module types *)
      self#generate_module_type_list_code chanout (Module.module_module_types modu);
      (* classes *)
      self#generate_class_list_code chanout modu.m_name (Module.module_classes modu);
      (* class types *)
      self#generate_class_type_list_code chanout modu.m_name (Module.module_class_types modu);
      (* types *)
      self#generate_types_table chanout (Module.module_types modu);
      (* exceptions *)
      self#generate_exceptions_table chanout (Module.module_exceptions modu);
      (* values *)
      self#generate_values_table chanout (Module.module_simple_values modu);
      (* functions *)
      self#generate_function_list_code chanout (Module.module_functions modu);

      output_string chanout "</html>";
      
      (* generate html files for submodules *)
      self#generate_elements self#generate_for_module (Module.module_modules modu);
      (* generate html files for modules types *)
      self#generate_elements self#generate_for_module_type (Module.module_module_types modu);
      (* generate html files for class types *)
      self#generate_elements self#generate_for_class_type (Module.module_class_types modu);
      (* generate html files for classes *)
      self#generate_elements self#generate_for_class (Module.module_classes modu);

      (* generate the file with the complete module type *)
      self#output_module_type 
	modu.m_name
	(Filename.concat !Args.target_dir type_file)
	modu.m_type

  (** Generate the code for the html frame file of the given module type,
    in the given out_channel. *)
  method generate_module_type_frame chanout mt =
    let parent_module_name_opt =
      try Some (Filename.chop_extension mt.mt_name)
      with Invalid_argument _ -> None
    in
    let (html_file, _) = Naming.html_files mt.mt_name in
      output_string chanout
	("<html>\n"^
	 (self#header (self#inner_title mt.mt_name)) ^
	 "<body>\n"^
	 "<code class=\"filename\">"^mt.mt_file^"</code><br>\n"^
	 "<h2>"^
	 (match parent_module_name_opt with
	      None -> ""
	    | Some m_name -> 
		let (_, html_parent) = Naming.html_files m_name in
		  "<a href=\""^html_parent^"\" target=\"summaryFrame\">"^m_name^".</a>\n"
	 )^
	 "<a href=\""^html_file^"\" target=\"detailsFrame\">"^(Name.simple mt.mt_name)^"</a></h2>\n"^
         (* submodules *)
	 (
	   match Module.module_type_modules mt with
	       [] -> ""
	     | l ->
		 "<h4>"^Odoc_messages.modules^"/"^Odoc_messages.functors^"</h4>\n"^
		 (String.concat ""
		    (List.map
		       (fun m ->
			  let (html, html_frame) = Naming.html_files m.m_name in
			    "<a href=\""^html_frame^"\" target=\"summaryFrame\">"^(Name.simple m.m_name)^"</a><br>\n"
		       )
		       (List.sort (fun m1 -> fun m2 -> compare (Name.simple m1.m_name) (Name.simple m2.m_name)) l)
		    )
		 )
	 )^
         (* module types *)
	 (
	   match Module.module_type_module_types mt with
	       [] ->
		 ""
	     | l ->
		 "<h4>"^Odoc_messages.module_types^"</h4>\n"^
		 (String.concat ""
		    (List.map
		       (fun mt ->
			  let (html, html_frame) = Naming.html_files mt.mt_name in
			    "<a href=\""^html_frame^"\" target=\"summaryFrame\">"^(Name.simple mt.mt_name)^"</a><br>\n"
		       )
		       (List.sort (fun mt1 -> fun mt2 -> compare (Name.simple mt1.mt_name) (Name.simple mt2.mt_name)) l)
		    )
		 )
	 )^
	 (
	   let f_toc title cpl_list =
	     match cpl_list with
		 [] ->
		   ""
	       | _ ->
		   "<h4>"^title^"</h4>\n"^
		   (String.concat ""
		      (List.map
			 (fun (target, simple_name) ->
			    "<a href=\""^target^"\" target=\"detailsFrame\">"^simple_name^"</a><br>\n"
			 )
			 (List.sort (fun (_,n1) -> fun (_,n2) -> compare n1 n2) cpl_list)
		      )
		   )
	   in
             (* classes *)
	     (f_toc Odoc_messages.classes 
		(List.map (fun c -> (fst (Naming.html_files c.cl_name), Name.simple c.cl_name)) (Module.module_type_classes mt)))^
             (* class types *)
	     (f_toc Odoc_messages.class_types
		(List.map (fun ct -> (fst (Naming.html_files ct.clt_name), Name.simple ct.clt_name)) (Module.module_type_class_types mt)))^
             (* types *)
	     (f_toc Odoc_messages.types 
		(List.map (fun t -> (Naming.complete_type_target t, Name.simple t.ty_name)) (Module.module_type_types mt)))^
             (* exceptions *)
	     (f_toc Odoc_messages.exceptions 
		(List.map (fun e -> (Naming.complete_exception_target e, Name.simple e.ex_name)) (Module.module_type_exceptions mt)))^
             (* values *)
	     (f_toc Odoc_messages.values 
		(List.map (fun v -> (Naming.complete_value_target v, Name.simple v.val_name)) (Module.module_type_simple_values mt)))^
             (* functions *)
	     (f_toc Odoc_messages.functions 
		(List.map (fun f -> (Naming.complete_value_target f, Name.simple f.val_name)) (Module.module_type_functions mt)))
	 )^
	 "</html>"
	)

  (** Generate the code for the html frame file of the given module,
    in the given out_channel. *)
  method generate_module_frame chanout modu =
    let parent_module_name_opt =
      try Some (Filename.chop_extension modu.m_name)
      with Invalid_argument _ -> None
    in
    let (html_file, _) = Naming.html_files modu.m_name in
      output_string chanout
	("<html>\n"^
	 (self#header (self#inner_title modu.m_name)) ^
	 "<body>\n"^
	 "<code class=\"filename\">"^modu.m_file^"</code><br>\n"^
	 "<h2>"^
	 (match parent_module_name_opt with
	      None -> ""
	    | Some m_name -> 
		let (_, html_parent) = Naming.html_files m_name in
		  "<a href=\""^html_parent^"\" target=\"summaryFrame\">"^m_name^".</a>\n"
	 )^
	 "<a href=\""^html_file^"\" target=\"detailsFrame\">"^(Name.simple modu.m_name)^"</a></h2>\n"^
         (* submodules *)
	 (
	   match Module.module_modules modu with
	       [] ->
		 ""
	     | l ->
		 "<h4>"^Odoc_messages.modules^"/"^Odoc_messages.functors^"</h4>\n"^
		 (String.concat ""
		    (List.map
		       (fun m ->
			  let (html, html_frame) = Naming.html_files m.m_name in
			    "<a href=\""^html_frame^"\" target=\"summaryFrame\">"^(Name.simple m.m_name)^"</a><br>\n"
		       )
		       (List.sort (fun m1 -> fun m2 -> compare (Name.simple m1.m_name) (Name.simple m2.m_name)) l)
		    )
		 )
	 )^
         (* module types *)
	 (
	   match Module.module_module_types modu with
	       [] -> ""
	     | l ->
		 "<h4>"^Odoc_messages.module_types^"</h4>\n"^
		 (String.concat ""
		    (List.map
		       (fun mt ->
			  let (html, html_frame) = Naming.html_files mt.mt_name in
			    "<a href=\""^html_frame^"\" target=\"summaryFrame\">"^(Name.simple mt.mt_name)^"</a><br>\n"
		       )
		       (List.sort (fun mt1 -> fun mt2 -> compare (Name.simple mt1.mt_name) (Name.simple mt2.mt_name)) l)
		    )
		 )
	 )^
	 (
	   let f_toc title cpl_list =
	     match cpl_list with
		 [] -> ""
	       | _ ->
		   "<h4>"^title^"</h4>\n"^
		   (String.concat ""
		      (List.map
			 (fun (target, simple_name) ->
			    "<a href=\""^target^"\" target=\"detailsFrame\">"^simple_name^"</a><br>\n"
			 )
			 (List.sort (fun (_,n1) -> fun (_,n2) -> compare n1 n2) cpl_list)
		      )
		   )
	   in
             (* classes *)
	     (f_toc Odoc_messages.classes 
		(List.map (fun c -> (fst (Naming.html_files c.cl_name), Name.simple c.cl_name)) (Module.module_classes modu)))^
             (* class types *)
	     (f_toc Odoc_messages.class_types
		(List.map (fun ct -> (fst (Naming.html_files ct.clt_name), Name.simple ct.clt_name)) (Module.module_class_types modu)))^
             (* types *)
	     (f_toc Odoc_messages.types 
		(List.map (fun t -> (Naming.complete_type_target t, Name.simple t.ty_name)) (Module.module_types modu)))^
             (* exceptions *)
	     (f_toc Odoc_messages.exceptions 
		(List.map (fun e -> (Naming.complete_exception_target e, Name.simple e.ex_name)) (Module.module_exceptions modu)))^
             (* values *)
	     (f_toc Odoc_messages.values 
		(List.map (fun v -> (Naming.complete_value_target v, Name.simple v.val_name)) (Module.module_simple_values modu)))^
             (* functions *)
	     (f_toc Odoc_messages.functions 
		(List.map (fun f -> (Naming.complete_value_target f, Name.simple f.val_name)) (Module.module_functions modu)))
	 )^
	 "</html>"
	)

  (** Generate the html file for the given module type. 
    @raise Failure if an error occurs.*)
  method generate_for_module_type _ _  mt =
    try
      let (html_file, html_frame_file) = Naming.html_files mt.mt_name in
      let chanout = open_out (Filename.concat !Args.target_dir html_file) in
      let chanout_frame = open_out (Filename.concat !Args.target_dir html_frame_file) in
	self#generate_module_type_main chanout mt;
	self#generate_module_type_frame chanout_frame mt;
	close_out chanout;
	close_out chanout_frame
    with
	Sys_error s ->
	  raise (Failure s)

  (** Generate the html file for the given module. 
    @raise Failure if an error occurs.*)
  method generate_for_module _ _ modu =
    try
      let (html_file, html_frame_file) = Naming.html_files modu.m_name in
      let chanout = open_out (Filename.concat !Args.target_dir html_file) in
      let chanout_frame = open_out (Filename.concat !Args.target_dir html_frame_file) in
	self#generate_module_main chanout modu;
	self#generate_module_frame chanout_frame modu;
	close_out chanout;
	close_out chanout_frame
    with
	Sys_error s ->
	  raise (Failure s)

  (** Generate the index.html, modules-frame.html files corresponding
    to the given module list.
    @raise Failure if an error occurs.*)
  method generate_index module_list =
    try
      let chanout = open_out (Filename.concat !Args.target_dir index) in
      let chanout_modules = open_out (Filename.concat !Args.target_dir "modules-frame.html") in
      let title = 
	match !Args.title with
	    None -> "" 
	  | Some s -> s
      in
	output_string chanout 
	  (
	    "<html>\n"^
	    (self#header self#title) ^
	    "<frameset cols=\"20%,80%\">\n"^
	    "<frameset rows=\"30%,70%\">\n"^
	    "<frame src=\"modules-frame.html\" name=\"modulesFrame\">\n"^
	    "<frame src=\"modules-frame.html\" name=\"summaryFrame\">\n"^
	    "</frameset>\n"^
	    "<frame src=\"modules-frame.html\" name=\"detailsFrame\">\n"^
	    "</frameset>\n"^
	    "<noframes>\n"^
	    "<h2>\n"^
	    "Frame Alert</h2>\n"^
	    "<p>\n"^
	    "This document is designed to be viewed using the frames feature. If you see this message, you are using a non-frame-capable web client.\n"^
	    "<br>\n"^
	    "Link to <a href=\"modules-frame.html\">Non-frame version.</a></noframes>\n"^
	    "</html>\n"
	  );
	let index_if_not_empty l url m =
	  match l with
	      [] -> ""
	    | _ -> "<a href=\""^url^"\" target=\"detailsFrame\">"^m^"</a><br>\n"
	in
	  output_string chanout_modules
	    (
	      "<html>\n"^
	      (self#header self#title) ^
	      "<body>\n"^
	      "<h1>"^title^"</h1>\n"^
	      (index_if_not_empty list_types index_types Odoc_messages.index_of_types)^
	      (index_if_not_empty list_exceptions index_exceptions Odoc_messages.index_of_exceptions)^
	      (index_if_not_empty list_values index_values Odoc_messages.index_of_values)^
	      (index_if_not_empty list_attributes index_attributes Odoc_messages.index_of_attributes)^
	      (index_if_not_empty list_methods index_methods Odoc_messages.index_of_methods)^
	      (index_if_not_empty list_classes index_classes Odoc_messages.index_of_classes)^
	      (index_if_not_empty list_class_types index_class_types Odoc_messages.index_of_class_types)^
	      (index_if_not_empty list_modules index_modules Odoc_messages.index_of_modules)^
	      (index_if_not_empty list_module_types index_module_types Odoc_messages.index_of_module_types)^
	      "<br>\n"^
	      (String.concat ""
		 (List.map
		    (fun m ->
		       let (html, html_frame) = Naming.html_files m.m_name in
			 "<a href=\""^html_frame^"\" target=\"summaryFrame\">"^m.m_name^"</a><br>\n")
		    module_list
		 )
	      )^
	      "</table>\n"^
	      "</body>\n"^
	      "</html>"
	    );
	  close_out chanout;
	  close_out chanout_modules
    with
	Sys_error s ->
	  raise (Failure s)

end


let option_link_classic =
  ("-link-classic", Arg.String (fun d -> link_classic := Some d), 
   "<dir>  add links to the classic html doc in <dir>")

let _ = Args.add_option option_link_classic

let doc_generator = ((new framed_html) :> Args.doc_generator)
let _ = Args.set_doc_generator (Some doc_generator)

