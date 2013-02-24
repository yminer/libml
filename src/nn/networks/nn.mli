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
  The DefaultVisitor module

  @author Matthieu Lagacherie
  @author Olivier Ricordeau
  @since 09/04/2003
  All the visitors in LibML inherit from that class, and use the `visit'
  method to do their job.
*)

open Corpus
open DefaultVisitor
open Pattern
open LearningObject

class virtual nn :
object ('a)
  
  inherit learningObject

  (**
    The learning step.
  *)
  val mutable _step : float

  (**
    The current corpus.
  *)
  val mutable _corpus : string

  (**
    The learning corpus, containing all the learning examples.
  *)
  val mutable _learningCorpus : corpus

  (**
    The test corpus, containing all the testing examples.
  *)
  val mutable _testingCorpus : corpus

  (**
    The validating corpus, containing all the validating examples.
  *)
  val mutable _validatingCorpus : corpus

  (**
    The cumulated learning error
  *)
  val mutable _lastError : float

  (**
    The number of learning iterations
  *)
  val mutable _learningIterations : int

  (**
    Get the last cumulated learning error
  *)
  method getLastLearningError : float

  (**
    Add an error to the cumulated learning error
  *)
  method addLearningError : float -> unit

  (**
    Set the number of learning iterations
  *)
  method initLearningIterations : unit

  (**
    Increment the number of learning iterations
  *)
  method incLearningIterations : unit

  (**
    Get the number of patterns in the corpus
    Working by default with the learningPattern
  *)
  method getPatternNumber : int

  (**
    Adds a pattern to the neural network's pattern.
  *)
  method addPattern : pattern -> unit

  (**
    Returns the corpus.
    @return The corpus.
  *)			
  method getCorpus : corpus
		
  (**
    A get*.
    @return The current learning position of the corpus.
  *)       
  method getLearnPos : int

  (**
    A get*.
    @return The corpus' input learn vector.
  *)
  method getInputLearnVector : float array

  (**
    A get*.
    @return The corpus' output learn vector.
  *)
  method getOutputLearnVector : float array

  (**
    A get*.
    @return The learning step
  *)
  method getStep : float


  (**
    A set*.
    Set the current step.
  *)       
  method setStep : float -> unit

  (**
    A set*.
    Set the current corpus
  *)
  method setCorpus : string -> unit
    
  (**
    A set*.
    Working by default with the learningPattern
    Set the current learning pos.
  *)       
  method setLearnPos : int -> unit

  (**
    Increment the current learning pos.
  *)       
  method incLearnPos : unit

  (**
    Enables a class which inherits from this class to dump the inherited
    attributes as XML.
  *)
  method private toXml_nn_begin : string

  (**
    Closes tags which remain open after a call to toXml_nn_begin.
  *)    
  method private toXml_nn_end : string

end
  
