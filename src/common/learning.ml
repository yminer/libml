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
  The Learning module.
  LibML's main class.

  @author Matthieu Lagacherie
  @author Olivier Ricordeau
  @since 25/11/2003
*)

open LearningObject
open DummyLearningObject
open Xmlizable
open CommonXml
open Speaking

(**
  The learning class (LibML's main class).
  A learning contains an environment and a learningObject.
*)      
class learning =
object(this)
  
  inherit xmlizable

  inherit speaking
    
  initializer
    _className <- "learning"
    
  (**
    The environment.
  *)
  val _env =
    Env.getEnv()
  
  (**
    The current learningObject.
  *)
  val mutable _learningObject : learningObject =
    new dummyLearningObject
    
  (**
    A get*.
    @return the current learning object.
  *)
  method getLearningObject : learningObject =
    _learningObject
      
  (**
    Sets the current learningObject.
    This method should be at least called once if you want the learning to
    make sense.
    @param obj The new learningObject which is to be set.
  *)
  method setLearningObject (obj : learningObject) =
    _learningObject <- obj
      
  (**
    Saves the current learning as an XML file.
    @param filename The name of the output file's name.
    @param overwriteIfExists True if you don't want an exception to be raised
    if the specified file already exists.
  *)
  method saveAsXml (filename : string) (overwriteIfExists : bool) =
    (CommonXml.saveAsXml filename overwriteIfExists (this#toXml))
    
  (**
    Dumps this object as XML.
  *)
  method toXml =
    CommonXml.openTag _className ^
    _env#toXml ^
    _learningObject#toXml ^
    CommonXml.closeTag _className
      
end
