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
  This module contains functions meant to handle XML dumping.
*)
module CommonXml :
sig
  
  (**
    Opens a XML tag.
    @param tag Would be "plop" if you want "<plop>" to be returned.
  *)
  val openTag : string -> string
      
  (**
    CLoses a XML tag.
    @param tag Would be "plop" if you want "</plop>" to be returned.
  *)
  val closeTag : string -> string
    
  (**
    Dumps a 2d array.
    @param array The array which is to be dumped.
  *)
  val dump2dArray : 'a array -> ('a -> string) -> string
	
  (**
    Dumps a 3d array.
    @param array The array which is to be dumped.
  *)
  val dump3dArray : 'a array array -> ('a -> string) -> string
	
  (**
    Dumps a 4d array.
    @param array The array which is to be dumped.
  *)
  val dump4dArray : 'a array array array -> ('a -> string) -> string
      
  (**
    Dumps a 5d array.
    @param array The array which is to be dumped.
  *)
  val dump5dArray : 'a array array array array -> ('a -> string) -> string

  (**
    Saves the given XML content as an XML file, adding the LibML DTD.
    @param fileName The name of the output file's name.
    @param overwriteIfExists True if you don't want an exception to be raised
    if the specified file already exists.
  *)
  val saveAsXml : string -> bool -> string -> unit

end
