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
  Test program for the error module.

  @author Matthieu Lagacherie
  @since 09/13/2003
*)


open Env
open Pattern
open MlpNN
open TdNN
open InitTdnnVisitor
open InputTdnnVisitor
open PropagateTdnnVisitor
open ErrorTdnnVisitor

let tdnn = new tdNN;;
let initTdnn = new initTdnnVisitor;;
let inputTdnn = new inputTdnnVisitor;;
let pTdnn = new propagateTdnnVisitor;;
let eTdnn = new errorTdnnVisitor;;
let pat = new pattern [|[|0.34531;0.42739;0.34765;0.20748;0.10829;0.14307;0.2115;0.12654;0.1065;0.18414;0.20014;0.36173|]|]
 [|1.;0.;1.;1.;0.;1.;0.;0.;1.;0.;1.;0.|;;


tdnn#addPattern pat;;
tdnn#setLayerNb 3;;
tdnn#setDelay [|1;1|];;
tdnn#setTimeNb [|12;10;6|];;
tdnn#setFeaturesNb [|1;2;2|];;
tdnn#setFieldSize [|3;5|];;
tdnn#accept initTdnn;;
tdnn#accept inputTdnn;;
tdnn#accept pTdnn;;
Printf.printf "Starting Backpropagation\n\n";
tdnn#accept eTdnn;;

