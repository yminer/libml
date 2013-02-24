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
  The Speaking module.
  A speaking object can display stuffs on the current standard input / output.
  
  @author Olivier Ricordeau
  @since 11/25/2003
*)

open Env

(**
  The speaking class.
  Implements the methods which enables an object to speak (which means to
  write stuffs on the current standard input / output).
*)
class virtual speaking =
object(this)
  
  (**
    should be set in the initializer of any concrete class which inherits
    from this class.
  *)
  val mutable _className =
    "unnamed class (this is a bug!)"

  (**
    @return the classes's dynamic type.
  *)
  method getClassName =
    _className
    
  (**
    Displays a string on the current output channel.
    @param msg The message to be displayed.
    @param min_verbosity_level If verbosity >= this parameter, the message
    is displayed.
  *)
  method private out msg min_verbosity_level =
    (Env.getEnv())#out _className msg min_verbosity_level
  
  (**
    Displays a string on the current error channel.
    The name of the class who is speaking (displayed in the output).
    @param msg The message to be displayed.
    @param min_verbosity_level If verbosity >= this parameter, the message
    is displayed.
  *)
  method private err msg min_verbosity_level =
    (Env.getEnv())#err _className msg min_verbosity_level
      
end
