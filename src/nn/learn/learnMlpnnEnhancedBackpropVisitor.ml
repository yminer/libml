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
  The learnMlpNNEnhancedBackpropVisitor class

  An enhanced backpropagation learning is almost like a stochastic learning.
  The only difference is that during an enhanced backpropagation, the visitor
  saves the weight modifications it does. A weight correction is now also
  dependent on the previous correction.
  @author Matthieu Lagacherie
  @author Olivier Ricordeau
  @since 07/28/2003
  @see <http://www-ra.informatik.uni-tuebingen.de/SNNS/UserManual/node146.html>
  SNNS user manual.
*)

open Array

open Nn
open LearnVisitor
open DefaultVisitor
open MlpNN

class learnMlpnnEnhancedBackpropVisitor (network) =
object
  inherit [mlpNN] learnVisitor

  initializer
    _moduleName <- "MLPNN enhanced backpropagation"

    (**
      The momentum influence.
      This coefficient ponderates the last weight modifications' influence on
      the weight modifications which are being applied.
      // FIXME When the lib's verbosity will be implemented, make a warning
      if the default value is used.
      // FIXME Find a good default value.
    *)
  val mutable _momentumInfluence = 0.1

  (**
    A get*.
    @return the momentum influence.
  *)				     
  method getMomentumInfluence =
    _momentumInfluence
				  
  (**
    Sets the momentum influence.    
  *)
  method setMomentumInfluence newval =
    _momentumInfluence <- newval
      
  (**
    The last weights changes are stored inside the visitor.
  *)
  val mutable _lastWeightsChange = [|[|[|0.0|]|]|]
	
  (**
    The ctor creates the array which stores the last weights modification.
  *)
  initializer
    _lastWeightsChange <- Array.make (network#getLayerNb - 1) [|[||]|];
    for i = 0 to network#getLaxyerNb - 2 do
      network#weights.(i) <- Array.make (network#getNeuronsPerLayer i) [||];
      for j = 0 to (network#getNeuronsPerLayer i) - 1 do
	network#weights.(i).(j) <- Array.make (network#getNeuronsPerLayer (i + 1))  0.0
      done
    done
    
  (**
    Applies an enhanced backpropagation to a Multi-Layer Perceptron.
  *)
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
	      (** Compute the new weight correction,
		depending on the old one. *)
	      let weightCorrection =
		_lastWeightsChange.(l).(i).(j)
		-. network#getStep *. !gradients.(l).(i).(j) in
		(** Store the correction we are about to apply for next
		  time... *)
		_lastWeightsChange.(l).(i).(j) <- weightCorrection;
		(** ...then apply the weigh correction. *)
		!weights.(l).(i).(j) <- !weights.(l).(i).(j) +. weightCorrection
	    done
	  done
	done
      end
      
end
