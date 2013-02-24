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
  Test program for the learn module.

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
open LearnTdnnStochVisitor

let tdnn = new tdNN;;
let initTdnn = new initTdnnVisitor;;
let inputTdnn = new inputTdnnVisitor;;
let pTdnn = new propagateTdnnVisitor;;
let eTdnn = new errorTdnnVisitor;;
let lTdnn = new learnTdnnStochVisitor;;
let pat = new pattern [|[|0.3;0.7;0.7;0.7;0.7;0.2;0.2;0.2;0.9;0.9;0.4;0.9|]|]
 [|[|0.;1.;0.;1.;1.;0.;1.;0.;1.;1.;0.;0.|]|];;

tdnn#addPattern pat;;
tdnn#setLayerNb 3;;
tdnn#setDelay [|1;1|];;
tdnn#setTimeNb [|12;10;6|];;
tdnn#setFeaturesNb [|1;3;2|];;
tdnn#setFieldSize [|3;5|];;
tdnn#accept initTdnn;;
Printf.printf "Starting Learning\n\n";;

let f_erreur_reseau = function (e) ->
  let temp = ref 0.0 in
    for i = 0 to (Array.length e.((Array.length e) -1))-1 do
      for j = 0 to (Array.length e.((Array.length e) -1).(0))-1 do
	temp := !temp +. e.((Array.length e) -1).(i).(j) *.  e.((Array.length e) -1).(i).(j)
      done;
    done;!temp;;


let epok =
  begin
    for i = 0 to 20000 do
      tdnn#accept inputTdnn;
      tdnn#accept pTdnn;
      tdnn#accept eTdnn;
      tdnn#accept lTdnn;
      Printf.printf "Error = %f\n" (f_erreur_reseau !(tdnn#getError))
    done
  end

let printall = let vector = tdnn#getOutputActivation in
  begin
    Printf.printf "Output Activation \n\n";
      for j = 0 to 1 do
	for k = 0 to 5 do
	  Printf.printf "Neuron layer(2) feat(%d) time(%d) value(%f)\n" j k !vector.(2).(j).(k)
	done
      done
  end


(*
let printall1 = let vector = tdnn#getError in
  begin
    Printf.printf "Error \n\n";
    for i = 0 to Array.length !vector - 1 do
      for j = 0 to Array.length !vector.(i) - 1 do
	for k = 0 to Array.length !vector.(i).(j) - 1 do
	  Printf.printf "Neuron layer(i) feat(%d) time(%d) value(%f)\n" j k !vector.(i).(j).(k)
	done
      done
    done
  end


let printall2 = let vector = tdnn#getWeights in
  begin
    Printf.printf "Weights \n\n";
    for i = 0 to Array.length !vector - 1 do
      for j = 0 to Array.length !vector.(i) - 1 do
	for k = 0 to Array.length !vector.(i).(j) - 1 do
	  for m = 0 to Array.length !vector.(i).(j).(k) - 1 do
	    Printf.printf "Neuron layer(i) feat(%d) time(%d) feat+1(%d) value(%f)\n" j k m !vector.(i).(j).(k).(m)
	  done
	done
      done
    done
  end


let printall3 = let vector = tdnn#getGradients in
  begin
    Printf.printf "Gradients \n\n";
    for i = 0 to Array.length !vector - 1 do
      for j = 0 to Array.length !vector.(i) - 1 do
	for k = 0 to Array.length !vector.(i).(j) - 1 do
	  for m = 0 to Array.length !vector.(i).(j).(k) - 1 do
	    Printf.printf "Neuron layer(i) feat(%d) time(%d) feat+1(%d) value(%f)\n" j k m !vector.(i).(j).(k).(m)
	  done
	done
      done
    done
  end

*)
