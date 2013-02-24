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

open Unix

(**
  The Env class.
  Stores LibML's environment information.

  @author Matthieu Lagacherie
  @author Olivier Ricordeau
  @since 06/08/2003
  This class uses the Singleton design pattern in order to provide only one
  instance of the environment class.
  The aim is to provide information about the learning environment to the
  various objects involved in LibML.

  Verbosity levels (possible values for the _verbosity attribute):
  0 -> Nothing at all is displayed.
  1 -> Only errors are displayed.
  2 -> Errors and warnings are displayed.
  3 -> Errors + warnings + LibML verbosity 1 (only basic informations
  displayed).
  4 -> Errors + warnings + LibML verbosity 2 (when a method listed in the API
  is called, one message is displayed).
  5 -> Errors + warnings + LibML verbosity 3 (when a method listed in the API
  is called, more than one message will be displayed).
  6 -> Errors + warnings + LibML verbosity 4 (debugging informations are
  displayed).

  What verbosity level shoul I use?
  While writing/debugging a software that uses LibML, 4 is fine.
  For an official release of a software that uses LibML, 3 is fine.

  TODO explain how to use the getEnv method in other classes.
  @see <http://theory.lcs.mit.edu/~dnj/6898/projects/vicente-wagner.pdf> A PDF
  document about Design Patterns and OCaml.
*)

(*
  Note from Olivier: this class mustn't inherit from other classes unless
  compilation is a mess... Really, I've tried.
*)

(**
  The environment class.
*)
class environment =
object(this)
  
  (**
    The verbosity level.
  *)
  val mutable _verbosity : int = 0

  (**
    Sets the current verbosity level.
    This method is not verbose because otherwise it would be impossible to
    <b>totally</b> mute LibML.
  *)
  method setVerbosity newval =
    _verbosity <- newval
      
  (**
    Gets the current verbosity level.
  *)
  method getVerbosity =
    _verbosity

  (**
    File descriptor of the log file opened by the initializer.
  *)
  val mutable _logFile : Unix.file_descr = Unix.stdout

  (**
    Displays a string on the current output channel.
    @param module_name
    The name of the module who is speaking (displayed in the output).
    @param msg The message to be displayed.
    @param min_verbosity_level If verbosity >= this parameter, the message
    is displayed.
  *)
  method out (module_name: string) (msg: string) (min_verbosity_level: int) =
    if ( _verbosity >= min_verbosity_level ) then
      (
	let time : string =
	  (this#getTime()) in
	let str : string =
	  ("[LibML] " ^ time ^ " (" ^ module_name ^ "): " ^ msg ^ "\n") in
	let written : int =
	  Unix.write _logFile str 0 (String.length str) in
	  ()
      )
      
  (**
    Displays a string on the current error channel.
    @param module_name
    The name of the module who is speaking (displayed in the output).
    @param msg The message to be displayed.
    @param min_verbosity_level If verbosity >= this parameter, the message
    is displayed.
  *)
  method err (module_name: string) (msg: string) (min_verbosity_level: int) =
    if ( _verbosity >= min_verbosity_level ) then
      (
	let time : string =
	  (this#getTime()) in
	let str : string =
	  ("[LibML] " ^ time ^ " (" ^ module_name ^ "): ERROR: " ^ msg ^ "\n") in
	let written : int =
	  Unix.write _logFile str 0 (String.length str) in
	  ()
      )
      
  (**
    @return the current time as a string (for logs). Ex: "03/25/2004 18:57:25"
  *)
  method private getTime () : string =
    let localtime : Unix.tm =
      Unix.localtime(Unix.time())
    in
      (string_of_int (localtime.tm_mon + 1)) ^ "/" ^
      (string_of_int (localtime.tm_mday)) ^ "/" ^
      (string_of_int (localtime.tm_year + 1900)) ^ " " ^
      (string_of_int (localtime.tm_hour)) ^ ":" ^
      (string_of_int (localtime.tm_min)) ^ ":" ^
      (string_of_int (localtime.tm_sec))

  (**
    Closes a session (closes the log file).
  *)
  method closeSession =
    (Unix.close _logFile)

  (**
    The initializer tries to open /var/log/libml/libml.log as its log file. If it
    is not possible, it tries to open $HOME/.libml/libml.log as its log file.
    If impossible, everything is displayed on the standard/error output.
  *)
  initializer
    (
      let logFile : Unix.file_descr =
	try (Unix.openfile "/var/log/libml/libml.log"
	       [Unix.O_WRONLY;
		Unix.O_CREAT;
		Unix.O_APPEND;
		Unix.O_NONBLOCK]
	       0o644)
	with
	    (* /var/log/libml/libml.log cannot be opened *)
	    Unix.Unix_error (a,b,c) ->
	      (
		(* try to create /var/log/libml *)
		try (Unix.mkdir "/var/log/libml" 0o755;
		     Unix.openfile "/var/log/libml/libml.log"
		       [Unix.O_WRONLY;
			Unix.O_CREAT;
			Unix.O_APPEND;
			Unix.O_NONBLOCK]
		       0o644)
		with
		    (* cannot log in /var/log/libml
		       -> logging in $HOME/.libml/libml.log *)
		    Unix.Unix_error (a,b,c) ->
		      (
			let home : string = (try (Unix.getenv "HOME")
					     with Unix.Unix_error (a,b,c) -> "")
			in
			  if (home <> "") then
			    try (Unix.openfile (home ^ "/.libml/libml.log")
				   [Unix.O_WRONLY;
				    Unix.O_CREAT;
				    Unix.O_APPEND;
				    Unix.O_NONBLOCK]
				   0o644)
			    with
				(* $HOME/.libml/libml.log cannot be opened *)
				Unix.Unix_error (a,b,c) ->
				  (* try to create $HOME/.libml *)
				  try (Unix.mkdir (home ^ "/.libml") 0o744;
				       Unix.openfile (home ^ "/.libml/libml.log")
					 [Unix.O_WRONLY;
					  Unix.O_CREAT;
					  Unix.O_APPEND;
					  Unix.O_NONBLOCK]
					 0o644)
				  with
				      (* cannot log in $HOME/.libml/libml.log
					 => sending output on stdout *)
				      Unix.Unix_error (a,b,c) -> Unix.stdout
			  else
			    (* $HOME could not be read
			       => sending output to stdout *)
			    Unix.stdout
		      )
	      )
      in
	_logFile <- logFile;
    )
    
    
  (**
    The weights random generator limit.
  *)
  val mutable _randLimit : float = 2.0		

  (**
    Sets the current random limit.
  *)
  method setRandLimit newval =
    _randLimit <- newval
      
  (**
    Gets the current random limit.
  *)
  method getRandLimit =
    _randLimit

  (**
    Dumps this object as XML.
  *)
  method toXml =
    ("")
    
end
  
let env : environment option ref = ref None

(**
  The function which provides a unique instance on the environment to the
  various objects in LibML.
*)
let getEnv() : environment =
  match !env with
      None ->
        let result = new environment
        in
          env := Some result;
          result
    | Some result -> result
	
