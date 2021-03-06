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
  The defaultVisitor module.

  @author Matthieu Lagacherie
  @author Olivier Ricordeau
  @since 06/08/2003
  All the visitors in LibML inherit from that class, and use the `visit'
  method to do a job on an instance of a class which inherit from the
  visitable class.
*)

open Env
open Speaking

(**
  The defaultVisitor class.
  
  @author Matthieu Lagacherie
  @author Olivier Ricordeau
  @since 09/04/2003
  All the visitors in LibML inherit from that class, and use the `visit'
  method to do a job on an instance of a class which inherit from the
  visitable class.
*)
class virtual ['a] defaultVisitor =
object
  
  inherit speaking
    
  (**
    The name of visitor's module. This name is mainly needed in order to
    handle verbosity. It must be set by the concrete visitor's constructors.
  *)
  val mutable _moduleName = "unnamed module"   

  (**
    The generic visit method.
  *)
  method virtual visit : 'a -> unit
    
end
