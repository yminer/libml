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
  The learnMlpNNStochVisitor class

  @author Matthieu Lagacherie
  @author Olivier Ricordeau
  @since 07/10/2003
*)

open Nn
open LearnVisitor
open DefaultVisitor
open MlpNN
   
class learnMlpnnStochVisitor =
object
  inherit [mlpNN] learnVisitor
    
  initializer
    _moduleName <- "MLPNN stochastic learning";
    _className <- "mlpnnVisitor"

  method visit (network : mlpNN) =
    let error = network#getError and
      weights = network#getWeights and
      inputSum = network#getInputSum and
      gradients = network#getGradients and
      outputActivation = network#getOutputActivation in
      begin
	for l = network#getLayerNb - 2 downto 0 do
	  for i = 0 to (Array.length !weights.(l)) - 1 do
	    for j = 0 to (Array.length !weights.(l).(i)) - 1 do
	      !weights.(l).(i).(j)
	      <- !weights.(l).(i).(j) -. network#getStep
	      *. !gradients.(l).(i).(j);
	      (*
		Reinitialized for the on line learning.
	      *)
	      !gradients.(l).(i).(j) <- 0.
	    done
	  done
	done
      end

end
