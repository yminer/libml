(*********************************************************************************)
(*                Odoc_myhtml                                                    *)
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

(* $Id: odoc_myhtml.ml,v 1.1 2004/04/06 13:04:26 srv89 Exp $ *)

(** @ocamldoc_generator A HTML pretty-printer creating better titles
   (no more tables, use of hX, and it's up to the style to make it look good).
   @ocamldoc_compilation [ocamlc -I +ocamldoc -c odoc_myhtml.ml]
   @ocamldoc_url odoc_myhtml.ml

   @author Maxence Guesdon
*)

open Odoc_info
module Naming = Odoc_html.Naming
open Odoc_info.Value
open Odoc_info.Module

class gen () =
  object (self)
    inherit Odoc_html.html as html

    method html_of_module_comment text =
      let br1, br2 =
	match text with
	  [(Odoc_info.Title (n, l_opt, t))] -> false, false
	| (Odoc_info.Title (n, l_opt, t)) :: _ -> false, true
	| _ -> true, true
      in
      Printf.sprintf
	"%s%s%s"
	(if br1 then "<br>" else "")
	(self#html_of_text text)
	(if br2 then "<br/><br/>\n" else "")

    method html_of_Title n l_opt t =
      let label1 = self#create_title_label (n, l_opt, t) in
      "<a name=\""^(Naming.label_target label1)^"\"></a>\n"^
      (Printf.sprintf "<h%d>%s</h%d>" n (self#html_of_text t) n)

  end

let generator = ((new gen ()) :> Odoc_args.doc_generator)

let _ = Odoc_args.set_doc_generator (Some generator)
