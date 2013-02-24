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
open DefaultVisitor
open MlObject

(**
  The class session handle the objects in the Machine Learning Library.
  It's a level of abstraction on the basic functions of the LibML
*)
class session =
object(this)

  (**
    This hash table will handle the objects (networks, visitors, etc).
  *)
  val mutable _mlObjects = Hashtbl.create 50

  (**
    When an object is created, the current value of this counter is its 
    id.
  *)
  val mutable _objectCount = 0

  (**
    This method increment the counter _objectCount (when an object have
    been created.
  *)
  method incObjectCount = _objectCount <- _objectCount + 1

  (**
    A Get*
    @return the current value of _objectCount
  *)
  method getObjectCount = _objectCount

  (**
    Record an object in the hash table
  *)
  method addMlObject (ident : int) (obj : mlObject) =
    Hashtbl.add _mlObjects ident obj

  (**
    Start a new session (remove all objects)
  *)
  method newSession =
    _mlObjects <- Hashtbl.create 50;
    _objectCount <- 0

  (**
    This method remove an object in the hash table.
  *)
  method removeMlObject (ident : int) = Hashtbl.remove _mlObjects ident

  (**
    This method test if an object is in the hash table.
  *)
  method memMlObject (ident : int) = Hashtbl.mem _mlObjects ident
				       
  (**
    A get*
    @return the object corresponding to the ident value.
  *)
  method getMlObject (ident : int) = Hashtbl.find _mlObjects ident

end

let session : session option ref = ref None

  (**
    It's the same method as the env class, it's a equivalent to
    the singleton design pattern to ensure just one instantation
    of the session class.
    @return the session.
  *)
let getSession() : session =
  match !session with
         None ->
           let result = new session
           in
             session := Some result;
             result
       | Some result -> result
