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

open MlObject
open Session

open Pattern
open MlpNN
open InitMlpnnVisitor
open InitMlpnnConstVisitor
open InputMlpnnVisitor
open InputMlpnnStdVisitor
open PropagateMlpnnVisitor
open PropagateMlpnnStdVisitor
open PropagateMlpnnOptimizedVisitor
open ErrorMlpnnVisitor
open ErrorMlpnnStdVisitor
open ErrorMlpnnOptimizedVisitor
open LearnMlpnnStochVisitor
open LearnMlpnnStdVisitor

(**
  create* : wrappers for the objects creation with the factory
*)

let createMlpNN ident =
  let id = ref 0 and
    mlObj = MlpNN new mlpNN in
    begin
      id := (getSession())#getObjectCount;
      (getSession())#addMlObject !id mlObj;
      (getSession())#incObjectCount;
      !id
    end;;

let createInitMlpnnVisitor ident =
  let id = ref 0 and
    mlObj = MlpnnVisitor new initMlpnnVisitor in
    begin
      id := (getSession())#getObjectCount;
      (getSession())#addMlObject !id mlObj;
      (getSession())#incObjectCount;
      !id
    end;;

let createInitMlpnnConstVisitor ident =
  let id = ref 0 and
    mlObj = MlpnnVisitor new initMlpnnConstVisitor in
    begin
      id := (getSession())#getObjectCount;
      (getSession())#addMlObject !id mlObj;
      (getSession())#incObjectCount;
      !id
    end;;

let createInputMlpnnVisitor ident =
  let id = ref 0 and
    mlObj = MlpnnVisitor new inputMlpnnVisitor in
    begin
      id := (getSession())#getObjectCount;
      (getSession())#addMlObject !id mlObj;
      (getSession())#incObjectCount;
      !id
    end;;

let createInputMlpnnStdVisitor ident =
  let id = ref 0 and
    mlObj = MlpnnVisitor new inputMlpnnStdVisitor in
    begin
      id := (getSession())#getObjectCount;
      (getSession())#addMlObject !id mlObj;
      (getSession())#incObjectCount;
      !id
    end;;

let createPropagateMlpnnVisitor ident =
  let id = ref 0 and
    mlObj = MlpnnVisitor new propagateMlpnnVisitor in
    begin
      id := (getSession())#getObjectCount;
      (getSession())#addMlObject !id mlObj;
      (getSession())#incObjectCount;
      !id
    end;;

let createPropagateMlpnnStdVisitor ident =
  let id = ref 0 and
    mlObj = MlpnnVisitor new propagateMlpnnStdVisitor in
    begin
      id := (getSession())#getObjectCount;
      (getSession())#addMlObject !id mlObj;
      (getSession())#incObjectCount;
      !id
    end;;

let createPropagateMlpnnOptimizedVisitor ident =
  let id = ref 0 and
    mlObj = MlpnnVisitor new propagateMlpnnOptimizedVisitor in
    begin
      id := (getSession())#getObjectCount;
      (getSession())#addMlObject !id mlObj;
      (getSession())#incObjectCount;
      !id
    end;;

let createErrorMlpnnVisitor ident =
  let id = ref 0 and
    mlObj = MlpnnVisitor new errorMlpnnVisitor in
    begin
      id := (getSession())#getObjectCount;
      (getSession())#addMlObject !id mlObj;
      (getSession())#incObjectCount;
      !id
    end;;

let createErrorMlpnnStdVisitor ident =
  let id = ref 0 and
    mlObj = MlpnnVisitor new errorMlpnnStdVisitor in
    begin
      id := (getSession())#getObjectCount;
      (getSession())#addMlObject !id mlObj;
      (getSession())#incObjectCount;
      !id
    end;;

let createErrorMlpnnOptimizedVisitor ident =
  let id = ref 0 and
    mlObj = MlpnnVisitor new errorMlpnnOptimizedVisitor in
    begin
      id := (getSession())#getObjectCount;
      (getSession())#addMlObject !id mlObj;
      (getSession())#incObjectCount;
      !id
    end;;

let createLearnMlpnnStochVisitor ident =
  let id = ref 0 and
    mlObj = MlpnnVisitor new learnMlpnnStochVisitor in
    begin
      id := (getSession())#getObjectCount;
      (getSession())#addMlObject !id mlObj;
      (getSession())#incObjectCount;
      !id
    end;;

let createLearnMlpnnStdVisitor ident =
  let id = ref 0 and
    mlObj = MlpnnVisitor new learnMlpnnStdVisitor in
    begin
      id := (getSession())#getObjectCount;
      (getSession())#addMlObject !id mlObj;
      (getSession())#incObjectCount;
      !id
    end;;


(**
  Access methods for nn
*)

let onLineEpoch nn iVisitor pVisitor eVisitor lVisitor nb =
  let mlObjNN = ((getSession())#getMlObject nn) and
    mlObjIVisitor = ((getSession())#getMlObject iVisitor) and
    mlObjPVisitor = ((getSession())#getMlObject pVisitor) and
    mlObjEVisitor = ((getSession())#getMlObject eVisitor) and
    mlObjLVisitor = ((getSession())#getMlObject lVisitor) in
  begin
    match mlObjNN, mlObjIVisitor, mlObjPVisitor, mlObjEVisitor, mlObjLVisitor with
      | MlpNN mlObjNN, MlpnnVisitor mlObjIVisitor, MlpnnVisitor mlObjPVisitor, MlpnnVisitor mlObjEVisitor, MlpnnVisitor mlObjLVisitor
	  when mlObjNN#getClassName = "mlpNN"
	    & mlObjIVisitor#getClassName = "mlpnnVisitor"
	    & mlObjPVisitor#getClassName = "mlpnnVisitor"
	    & mlObjEVisitor#getClassName = "mlpnnVisitor"
	    & mlObjLVisitor#getClassName = "mlpnnVisitor"
	    ->
	  begin
	    for i = 0 to nb do
	      mlObjNN#initLearningIterations;
	      for j = 0 to mlObjNN#getPatternNumber - 1 do
		mlObjNN#accept mlObjIVisitor;
		mlObjNN#accept mlObjPVisitor;
		mlObjNN#accept mlObjEVisitor;
		mlObjNN#accept mlObjLVisitor;
		mlObjNN#incLearnPos;
		mlObjNN#incLearningIterations
	      done
	    done;
	    0
	  end	      
      | _ -> -1
  end;;


(**
  Access methods for nn
*)

let offLineEpoch nn iVisitor pVisitor eVisitor lVisitor nb =
  let mlObjNN = ((getSession())#getMlObject nn) and
    mlObjIVisitor = ((getSession())#getMlObject iVisitor) and
    mlObjPVisitor = ((getSession())#getMlObject pVisitor) and
    mlObjEVisitor = ((getSession())#getMlObject eVisitor) and
    mlObjLVisitor = ((getSession())#getMlObject lVisitor) in
  begin
    match mlObjNN, mlObjIVisitor, mlObjPVisitor, mlObjEVisitor, mlObjLVisitor with
      | MlpNN mlObjNN, MlpnnVisitor mlObjIVisitor, MlpnnVisitor mlObjPVisitor, MlpnnVisitor mlObjEVisitor, MlpnnVisitor mlObjLVisitor
	  when mlObjNN#getClassName = "mlpNN"
	    & mlObjIVisitor#getClassName = "mlpnnVisitor"
	    & mlObjPVisitor#getClassName = "mlpnnVisitor"
	    & mlObjEVisitor#getClassName = "mlpnnVisitor"
	    & mlObjLVisitor#getClassName = "mlpnnVisitor"
	    ->
	  begin
	    for i = 0 to nb do
	      mlObjNN#initLearningIterations;
	      for j = 0 to mlObjNN#getPatternNumber - 1 do
		mlObjNN#accept mlObjIVisitor;
		mlObjNN#accept mlObjPVisitor;
		mlObjNN#accept mlObjEVisitor;
		mlObjNN#incLearnPos;
		mlObjNN#incLearningIterations
	      done;
	      mlObjNN#accept mlObjLVisitor
	    done;
	    0
	  end	      
      | _ -> -1
  end;;

let customEpoch nn iVisitor pVisitor eVisitor lVisitor nb startPos nbPos =
  let mlObjNN = ((getSession())#getMlObject nn) and
    mlObjIVisitor = ((getSession())#getMlObject iVisitor) and
    mlObjPVisitor = ((getSession())#getMlObject pVisitor) and
    mlObjEVisitor = ((getSession())#getMlObject eVisitor) and
    mlObjLVisitor = ((getSession())#getMlObject lVisitor) and
    count = ref 0 in
  begin
    match mlObjNN, mlObjIVisitor, mlObjPVisitor, mlObjEVisitor, mlObjLVisitor with
      | MlpNN mlObjNN, MlpnnVisitor mlObjIVisitor, MlpnnVisitor mlObjPVisitor, MlpnnVisitor mlObjEVisitor, MlpnnVisitor mlObjLVisitor
	  when mlObjNN#getClassName = "mlpNN"
	    & mlObjIVisitor#getClassName = "mlpnnVisitor"
	    & mlObjPVisitor#getClassName = "mlpnnVisitor"
	    & mlObjEVisitor#getClassName = "mlpnnVisitor"
	    & mlObjLVisitor#getClassName = "mlpnnVisitor"
	    ->
	  begin
	    for i = 0 to nb do
	      mlObjNN#setLearnPos startPos;
	      mlObjNN#initLearningIterations;
	      count := startPos;
	      while ((!count < startPos + nbPos) && (!count < mlObjNN#getPatternNumber)) do
		mlObjNN#accept mlObjIVisitor;
		mlObjNN#accept mlObjPVisitor;
		mlObjNN#accept mlObjEVisitor;
		mlObjNN#accept mlObjLVisitor;
		mlObjNN#incLearningIterations;
		mlObjNN#incLearnPos;
		count := !count + 1
	      done;
	    done;
	    0
	  end	      
      | _ -> -1
  end;;


let getLastError obj =
  let mlObj = ((getSession())#getMlObject obj) in
    begin
      match mlObj with
	  MlpNN mlObj when mlObj#getClassName = "mlpNN" ->
	    mlObj#getLastError
	| _ -> -1.
    end;;


let getLastLearningError obj =
  let mlObj = ((getSession())#getMlObject obj) in
    begin
      match mlObj with
	  MlpNN mlObj when mlObj#getClassName = "mlpNN" ->
	    mlObj#getLastLearningError
	| _ -> -1.
    end;;

let getOutputActivation obj =
   let mlObj = ((getSession())#getMlObject obj) in
    begin
      match mlObj with
	  MlpNN mlObj when mlObj#getClassName = "mlpNN" ->
	    Common.string_of_float_array
	    !(mlObj#getOutputActivation).(mlObj#getLayerNb - 1)
	| _ -> "[]"
    end;;

let getMarshal obj =
   let mlObj = ((getSession())#getMlObject obj) in
    begin
      match mlObj with
	  MlpNN mlObj when mlObj#getClassName = "mlpNN" ->
	    mlObj#getMarshal
	| _ -> "Error, object not found."
    end;;

let addPattern obj input output =
  let mlObj = ((getSession())#getMlObject obj) in
    begin
      match mlObj with
	  MlpNN mlObj when mlObj#getClassName = "mlpNN" ->
	    mlObj#addPattern
	    (new pattern (Common.float_array_of_string input)
	       (Common.float_array_of_string output));
	    0
	| _ -> -1
    end;;

let setLayerNb obj nb =
  let mlObj = ((getSession())#getMlObject obj) in
    begin
      match mlObj with
	  MlpNN mlObj when mlObj#getClassName = "mlpNN" ->
	    mlObj#setLayerNb nb;
	    0
	| _ -> -1
    end;;

let setNeuronsPerLayer obj nbTab =
  let mlObj = ((getSession())#getMlObject obj) in
    begin
      match mlObj with
	  MlpNN mlObj when mlObj#getClassName = "mlpNN" ->
	    mlObj#setNeuronsPerLayer (Common.int_array_of_string(nbTab));
	    0
	| _ -> -1
    end;;

let getNeuronsPerLayer obj =
  let mlObj = ((getSession())#getMlObject obj) in
    begin
      match mlObj with
	  MlpNN mlObj when mlObj#getClassName = "mlpNN" ->
	    Common.string_of_int_array(mlObj#getNeuronsPerLayer)
	| _ -> "[]"
    end;;

let setCorpus obj corpusType =
  let mlObj = ((getSession())#getMlObject obj) in
    begin
      match mlObj with
	  MlpNN mlObj when mlObj#getClassName = "mlpNN" ->
	    mlObj#setCorpus corpusType;
	    0
	| _ -> -1
    end;;

let setLearnPos obj pos =
  let mlObj = ((getSession())#getMlObject obj) in
    begin
      match mlObj with
	  MlpNN mlObj when mlObj#getClassName = "mlpNN" ->
	    mlObj#setLearnPos pos;
	    0
	| _ -> -1
    end;;

let setStep obj step =
  let mlObj = ((getSession())#getMlObject obj) in
    begin
      match mlObj with
	  MlpNN mlObj when mlObj#getClassName = "mlpNN" ->
	    mlObj#setStep (float_of_string(step));
	    0
	| _ -> -1
    end;;

let getLearnError nn iVisitor pVisitor =
  let mlObjNN = ((getSession())#getMlObject nn) and
    mlObjIVisitor = ((getSession())#getMlObject iVisitor) and
    mlObjPVisitor = ((getSession())#getMlObject pVisitor) in
  begin
    match mlObjNN, mlObjIVisitor, mlObjPVisitor with
      | MlpNN mlObjNN, MlpnnVisitor mlObjIVisitor, MlpnnVisitor mlObjPVisitor
	  when mlObjNN#getClassName = "mlpNN"
	    & mlObjIVisitor#getClassName = "mlpnnVisitor"
	    & mlObjPVisitor#getClassName = "mlpnnVisitor"
	    -> getMlpNNLearnError mlObjNN mlObjIVisitor mlObjPVisitor
      | _ -> -1.0
  end;;

let getTestError nn iVisitor pVisitor =
  let mlObjNN = ((getSession())#getMlObject nn) and
    mlObjIVisitor = ((getSession())#getMlObject iVisitor) and
    mlObjPVisitor = ((getSession())#getMlObject pVisitor) in
  begin
    match mlObjNN, mlObjIVisitor, mlObjPVisitor with
      | MlpNN mlObjNN, MlpnnVisitor mlObjIVisitor, MlpnnVisitor mlObjPVisitor
	  when mlObjNN#getClassName = "mlpNN"
	    & mlObjIVisitor#getClassName = "mlpnnVisitor"
	    & mlObjPVisitor#getClassName = "mlpnnVisitor"
	    -> getMlpNNTestError mlObjNN mlObjIVisitor mlObjPVisitor
      | _ -> -1.0
  end;;

let getValidateError nn iVisitor pVisitor =
  let mlObjNN = ((getSession())#getMlObject nn) and
    mlObjIVisitor = ((getSession())#getMlObject iVisitor) and
    mlObjPVisitor = ((getSession())#getMlObject pVisitor) in
  begin
    match mlObjNN, mlObjIVisitor, mlObjPVisitor with
      | MlpNN mlObjNN, MlpnnVisitor mlObjIVisitor, MlpnnVisitor mlObjPVisitor
	  when mlObjNN#getClassName = "mlpNN"
	    & mlObjIVisitor#getClassName = "mlpnnVisitor"
	    & mlObjPVisitor#getClassName = "mlpnnVisitor"
	    -> getMlpNNValidateError mlObjNN mlObjIVisitor mlObjPVisitor
      | _ -> -1.0
  end;;

let newSession nb = (getSession())#newSession;
  nb;;


(**
  calls to the environment (verbosity, etc.).
*)

(**
  Sets the current verbosity level.
  @param newval new verbosity level
*)
let setVerbosity newval =
  (Env.getEnv())#setVerbosity newval
  
(**
  @return the current verbolity level
*)
let getVerbosity =
  (Env.getEnv())#getVerbosity
  
