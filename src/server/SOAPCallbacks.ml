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
  Instanciation of the factory which instanciates mlObjects during a session.
*)
let factory = new Factory.factory;;


(**
  Wrappers for SOAP only (the ones called from foreign languages).
*)
let acceptVisitor obj visitor = factory#acceptVisitor obj visitor;;
let createObject ident = factory#createObject ident;;
let memObject ident = factory#memObject ident;;


Callback.register "createObject" createObject;;
Callback.register "acceptVisitor" acceptVisitor;;
Callback.register "memObject" memObject;;

(**
  Callbacks for the not SOAP only wrappers located in src/wrappers/create.ml.
*)
Callback.register "addPattern" Create.addPattern;;
Callback.register "setLayerNb" Create.setLayerNb;;
Callback.register "setNeuronsPerLayer" Create.setNeuronsPerLayer;;
Callback.register "getNeuronsPerLayer" Create.getNeuronsPerLayer;;
Callback.register "onLineEpoch" Create.onLineEpoch;;
Callback.register "offLineEpoch" Create.offLineEpoch;;
Callback.register "customEpoch" Create.customEpoch;;
Callback.register "getLastError" Create.getLastError;;
Callback.register "getLastLearningError" Create.getLastLearningError;;
Callback.register "getOutputActivation" Create.getOutputActivation;;
Callback.register "getLearnError" Create.getLearnError;;
Callback.register "getTestError" Create.getTestError;;
Callback.register "getValidateError" Create.getValidateError;;
Callback.register "getMarshal" Create.getMarshal;;
Callback.register "newSession" Create.newSession;;
Callback.register "setCorpus" Create.setCorpus;;
Callback.register "setLearnPos" Create.setLearnPos;;
Callback.register "setStep" Create.setStep;;
(** calls to the environment (verbosity, etc.). *)
Callback.register "getVerbosity" Create.getVerbosity;;
Callback.register "setVerbosity" Create.setVerbosity;;
