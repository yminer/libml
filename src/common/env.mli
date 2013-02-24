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
  The Env module
  Stores LibML's environment information.

  @author Matthieu Lagacherie
  @author Olivier Ricordeau
  @since 10/10/2003
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
  compilation is a mess...
*)

(**
  The environment class
*)
class environment :
object

  (**
    The verbosity level.
  *)
  val mutable _verbosity : int

  (**
    Sets the current verbosity level.
    This method is not verbose because otherwise it would be impossible to
    <b>totally</b> mute LibML.
  *)
  method setVerbosity : int -> unit

  (**
    Gets the current verbosity level.
  *)
  method getVerbosity : int

  (**
    Displays a string on the current output channel.
    @param module_name
    The name of the module who is speaking (displayed in the output).
    @param msg The message to be displayed.
    @param min_verbosity_level If verbosity >= this parameter, the message
    is displayed.
  *)
  method out : string -> string ->  int -> unit    

  (**
    Displays a string on the current error channel.
    @param module_name
    The name of the module who is speaking (displayed in the output).
    @param msg The message to be displayed.
    @param min_verbosity_level If verbosity >= this parameter, the message
    is displayed.
  *)
  method err : string -> string ->  int -> unit

  (**
    Closes a session (closes a log file).
  *)

  method closeSession : unit

  (**
    File descriptor of the log file opened by the initializer.
  *)
  val mutable _logFile : Unix.file_descr
    
  (**
    The weights random generator limit.
  *)
  val mutable _randLimit : float		

  (**
    Sets the current random limit.
  *)
  method setRandLimit : float -> unit
      
  (**
    Gets the current random limit.
  *)
  method getRandLimit : float

  (**
    Dumps this object as XML.
  *)
  method toXml : string
    
end

val env : environment option ref

val getEnv : unit -> environment
