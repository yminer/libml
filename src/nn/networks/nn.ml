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
  The NN virtual class
  It's LibML's main neural network class.

  @author Matthieu Lagacherie
  @author Olivier Ricordeau
  @since 06/08/2003
*)

open Pattern
open Corpus
open LearningObject
open CommonXml

class virtual nn =
object (this)

  inherit learningObject

  initializer
    _className <- "nn";
    _classTag <- "nn"

  (**
    The learning step.
  *)
  val mutable _step = 0.1

  (**
    The current corpus.
  *)
  val mutable _corpus = "learningCorpus"

  (**
    The learning corpus, containing all the learning examples.
  *)
  val mutable _learningCorpus = new corpus

  (**
    The test corpus, containing all the testing examples.
  *)
  val mutable _testingCorpus = new corpus

  (**
    The validating corpus, containing all the validating examples.
  *)
  val mutable _validatingCorpus = new corpus

  (**
    The cumulated learning error
  *)
  val mutable _lastError = 0.0

  (**
    The number of learning iterations
  *)
  val mutable _learningIterations = 0

  (**
    Get the last cumulated learning error
  *)
  method getLastLearningError = 
    Printf.printf "lasterror=%f it=%d\n" _lastError _learningIterations;
    _lastError /. float_of_int(_learningIterations)

  (**
    Add an error to the cumulated learning error
  *)
  method addLearningError error = _lastError <- _lastError +. error

  (**
    Init the number of learning iterations
  *)
  method initLearningIterations = _lastError <- 0.0;
    _learningIterations <- 0

  (**
    Increment the number of learning iterations
  *)
  method incLearningIterations = _learningIterations 
				 <- _learningIterations + 1

  (**
    Get the number of patterns in the corpus
    Working by default with the learningPattern
  *)
  method getPatternNumber =
    match _corpus with
      | "learningCorpus" -> _learningCorpus#getPatternNumber
      | "testingCorpus" -> _testingCorpus#getPatternNumber
      | "validatingCorpus" -> _validatingCorpus#getPatternNumber
      | _ -> _learningCorpus#getPatternNumber

  (**
    Adds a pattern to the neural network's pattern.
    @param pattern The pattern to add.
    Working by default with the learningPattern
  *)
  method addPattern pattern =
    match _corpus with
      | "learningCorpus" -> _learningCorpus#addPattern pattern
      | "testingCorpus" -> _testingCorpus#addPattern pattern
      | "validatingCorpus" -> _validatingCorpus#addPattern pattern
      | _ -> _learningCorpus#addPattern pattern
	
  (**
    Returns the corpus.
    Working by default with the learningPattern
    @return The corpus.
  *)			
  method getCorpus  =
    match _corpus with
      | "learningCorpus" -> _learningCorpus
      | "testingCorpus" -> _testingCorpus
      | "validatingCorpus" -> _validatingCorpus
      | _  -> _learningCorpus
		
  (**
    A get*.
    Working by default with the learningPattern
    @return The current learning position of the corpus.
  *)       
  method getLearnPos =
    match _corpus with
      | "learningCorpus" -> _learningCorpus#getLearnPos
      | "testingCorpus" -> _testingCorpus#getLearnPos
      | "validatingCorpus" -> _validatingCorpus#getLearnPos
      | _ -> _learningCorpus#getLearnPos

  (**
    A get*.
    Working by default with the learningPattern
    @return The corpus' input learn vector.
  *)
  method getInputLearnVector =
    match _corpus with
      | "learningCorpus" -> 
	  _learningCorpus#getInputLearnVector _learningCorpus#getLearnPos
      | "testingCorpus" -> 
	  _testingCorpus#getInputLearnVector _testingCorpus#getLearnPos
      | "validatingCorpus" -> 
	  _validatingCorpus#getInputLearnVector _validatingCorpus#getLearnPos
      | _ -> 
	  _learningCorpus#getInputLearnVector _learningCorpus#getLearnPos

  (**
    A get*.
    Working by default with the learningPattern
    @return The corpus' output learn vector.
  *)
  method getOutputLearnVector =
    match _corpus with
      | "learningCorpus" -> 
	  _learningCorpus#getOutputLearnVector _learningCorpus#getLearnPos
      | "testingCorpus" -> 
	  _testingCorpus#getOutputLearnVector _testingCorpus#getLearnPos
      | "validatingCorpus" -> 
	  _validatingCorpus#getOutputLearnVector _validatingCorpus#getLearnPos
      | _ -> 
	  _learningCorpus#getOutputLearnVector _learningCorpus#getLearnPos

  (**
    A get*.
    @return The learning step
  *)
  method getStep =
    _step

  (**
    A set*.
    Set the current corpus
  *)
  method setCorpus corpusType =
    _corpus <- corpusType

  (**
    A set*.
    Working by default with the learningPattern
    Set the current learning pos.
  *)       
  method setLearnPos pos =
    match _corpus with
      | "learningCorpus" -> _learningCorpus#setLearnPos pos
      | "testingCorpus" -> _testingCorpus#setLearnPos pos
      | "validatingCorpus" -> _validatingCorpus#setLearnPos pos
      | _ -> _learningCorpus#setLearnPos pos

  (**
    A set*.
    Set the current step.
  *)       
  method setStep step = _step <- step

  (**
    Increment the current learning pos.
  *)       
  method incLearnPos =
    match _corpus with
      | "learningCorpus" -> _learningCorpus#incLearnPos
      | "testingCorpus" -> _testingCorpus#incLearnPos
      | "validatingCorpus" -> _validatingCorpus#incLearnPos
      | _ -> _learningCorpus#incLearnPos
      
  (**
    Enables a class which inherits from this class to dump the inherited
    attributes as XML.
  *)
  method private toXml_nn_begin =
    CommonXml.openTag _classTag ^
    CommonXml.openTag "step" ^
    (string_of_float this#getStep) ^
    CommonXml.closeTag "step" ^
    _learningCorpus#toXml

  (**
    Closes tags which remain open after a call to toXml_nn_begin.
  *)
  method private toXml_nn_end =
    CommonXml.closeTag _classTag

end
