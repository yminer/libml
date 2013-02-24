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
  Test program for the init module.

  @author Matthieu Lagacherie
  @since 09/11/2003
*)


open Env
open MlpNN
open TdNN
open InitMlpnnVisitor
open InitTdnnVisitor

let mlpnn = new mlpNN;;
let initMlpnn = new initMlpnnVisitor;;

mlpnn#setLayerNb 3;;
mlpnn#setNeuronsPerLayer [|3;10;3|];;
mlpnn#accept initMlpnn;;

let tdnn = new tdNN;;
let initTdnn = new initTdnnVisitor;;


tdnn#setLayerNb 3;;
tdnn#setDelay [|1;1|];;
tdnn#setTimeNb [|12;10;6|];;
tdnn#setFeaturesNb [|1;8;4|];;
tdnn#setFieldSize [|3;5|];;
tdnn#accept initTdnn;;
