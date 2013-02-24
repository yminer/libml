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
  Raised if someone tries to overwrite an existing file.
*)
exception FileExists

(**
  This module contains functions meant to handle XML dumping.
*)
module CommonXml =
struct

  let out msg min_verbosity_level =
    (Env.getEnv())#out "commonXml" msg min_verbosity_level

  let err msg min_verbosity_level =
    (Env.getEnv())#err "commonXml" msg min_verbosity_level
  
  (**
    Opens a XML tag.
    @param tag Would be "plop" if you want "<plop>" to be returned.
  *)
  let openTag (tag : string) =
    "<" ^ tag ^ ">
"
      
  (**
    CLoses a XML tag.
    @param tag Would be "plop" if you want "</plop>" to be returned.
  *)
  let closeTag (tag) =
    "</" ^ tag ^ ">
"

  (**
    Dumps a 2d array.
    @param array The array which is to be dumped.
  *)
  let dump2dArray (a_array : 'a array) (string_of_a : ('a -> string)) =
    openTag "_2d_array" ^
    (
      let str = ""
      in
      let refer = ref str
      in
	for x = 0 to (Array.length a_array - 1) do
	  refer := !refer ^
	  "<x>" ^ (string_of_int x) ^
	  "</x><value>" ^
	  (string_of_a a_array.(x)) ^
	  "</value>"
	done;
	!refer
    ) ^
    closeTag "_2d_array"
      
  (**
    Dumps a 3d array.
    @param array The array which is to be dumped.
  *)
  let dump3dArray (a_array : 'a array array) (string_of_a : ('a -> string)) =
    openTag "_3d_array" ^
    (
      let str = ""
      in
      let refer = ref str
      in
	for x = 0 to (Array.length a_array - 1) do
	  for y = 0 to (Array.length a_array.(x) - 1) do
	    refer := !refer ^
	    ("<x>" ^ (string_of_int x) ^
	     "</x><y>" ^ (string_of_int y) ^
	     "</y><value>" ^
	     (string_of_a a_array.(x).(y)) ^
	     "</value>")
	  done
	done;
	!refer
    ) ^
    closeTag "_3d_array"
      
  (**
    Dumps a 4d array.
    @param array The array which is to be dumped.
  *)
  let dump4dArray (a_array : 'a array array array)
    (string_of_a : ('a -> string)) =
    openTag "_4d_array" ^
    (
      let str = ""
      in
      let refer = ref str
      in
	for x = 0 to (Array.length a_array - 1) do
	  for y = 0 to (Array.length a_array.(x) - 1) do
	    for z = 0 to (Array.length a_array.(x).(y) - 1) do
	      refer := !refer ^
	      ("<x>" ^ (string_of_int x) ^
	       "</x><y>" ^ (string_of_int y) ^
	       "</y><z>" ^ (string_of_int z) ^
	       "</z><value>" ^
	       string_of_a a_array.(x).(y).(z) ^
	       "</value>")
	    done
	  done
	done;
	!refer
    ) ^
    closeTag "_4d_array"
      
  (**
    Dumps a 5d array.
    @param array The array which is to be dumped.
  *)
  let dump5dArray (a_array : 'a array array array array)
    (string_of_a : 'a -> string) =
    openTag "_5d_array" ^
    (
      let str = ""
      in
      let refer = ref str
      in
	for x = 0 to (Array.length a_array - 1) do
	  for y = 0 to (Array.length a_array.(x) - 1) do
	    for z = 0 to (Array.length a_array.(x).(y) - 1) do
	      for t = 0 to (Array.length a_array.(x).(y).(z) - 1) do
		refer := !refer ^
		("<x>" ^ (string_of_int x) ^
		 "</x><y>" ^ (string_of_int y) ^
		 "</y><z>" ^ (string_of_int z) ^
		 "</z><t>" ^ (string_of_int t) ^
		 "</t><value>" ^
		 (string_of_a a_array.(x).(y).(z).(t)) ^
		 "</value>")
	      done
	    done
	  done
	done;
	!refer
    ) ^
    closeTag "_5d_array"

  (**
    The XML file's header. Contains the DTD. The version is replaced using
    the preprocessor.
    @see <http://www.w3schools.com/dtd/dtd_intro.asp> How to get a DTD
    whithin a XML file.
  *)
  let header =
    "<?xml version=\"_LIBML_VERSION\"?>

<!-- (* Learning session dump *) -->
<!--  This file was generated by LibML  -->
<!--          http://libml.org          -->

<!-- The DTD -->
<!DOCTYPE learning [

<!-- learning (the XML file's root). -->
<!ELEMENT learning (env,learning_object)>


<!-- learningObject ->
<!ELEMENT learning_object (dummy_learning_object|nn)>

<!-- dummyLearningObject -->
<!ELEMENT dummy_learning_object>

<!-- Neural Network -->
<!ELEMENT nn (step,corpus,(mlpnn|tdnn))>

<!-- Neural Networks kinds (concrete classes which inherit from the -->
<!-- `nn' class)                                                    -->
<!-- Multi Layer Perceptron (`mlpNN' class) -->
<!ELEMENT mlpnn (mlpnn_output_activation,mlpnn_input_sum,mlpnn_error,
mlpnn_weights,mlpnn_gradients,layer_nb,mlpnn_neurons_per_layer)>
<!ELEMENT mlpnn_output_activation (_3d_array)>
<!ELEMENT mlpnn_input_sum (_3d_array)>
<!ELEMENT mlpnn_error (_3d_array)>
<!ELEMENT mlpnn_weights (_4d_array)>
<!ELEMENT mlpnn_gradients (_4d_array)>
<!ELEMENT mlpnn_neurons_per_layer (_2d_array)>
<!-- Time Delay Neural Network (`tdNNN' class) -->
<!ELEMENT tdnn (tdnn_output_activation,tdnn_input_sum,tdnn_error,
tdnn_weights,tdnn_gradients,layer_nb,tdnn_delay,tdnn_features_nb,
tdnn_time_nb,tdnn_field_size)>
<!ELEMENT tdnn_output_activation (_4d_array)>
<!ELEMENT tdnn_input_sum (_4d_array)>
<!ELEMENT tdnn_error (_4d_array)>
<!ELEMENT tdnn_weights (_5d_array)>
<!ELEMENT tdnn_gradients (_5d_array)>
<!ELEMENT tdnn_delay (_2d_array)>
<!ELEMENT tdnn_features_nb (_2d_array)>
<!ELEMENT tdnn_time_nb (_2d_array)>
<!ELEMENT tdnn_field_size (_2d_array)>

<!-- Common stuffs -->
<!-- Corpus (`corpus' class) -->
<!ELEMENT corpus (pattern*)>
<!-- Pattern (`pattern' class) -->
<!ELEMENT pattern (input,output)>
<!ELEMENT input (_2d_array)>
<!ELEMENT output (_2d_array)>
<!-- Environment (`env' class) -->
<!ELEMENT env (verbosity,randlimit,out_channel,err_channel)>
<!ELEMENT verbosity (#PCDATA)>
<!ELEMENT randlimit (#PCDATA)>
<!ELEMENT out_channel (#PCDATA)>
<!ELEMENT err_channel (#PCDATA)>
<!-- Arrays -->
<!ELEMENT _2d_array ((x,value)*)>
<!ELEMENT _3d_array ((x,y,value)*)>
<!ELEMENT _4d_array ((x,y,z,value)*)>
<!ELEMENT _5d_array ((x,y,z,t,value)*)>
<!ELEMENT x (#PCDATA)>
<!ELEMENT y (#PCDATA)>
<!ELEMENT z (#PCDATA)>
<!ELEMENT t (#PCDATA)>
<!ELEMENT value (#PCDATA)>
<!-- Others -->
<!ELEMENT step (#PCDATA)>
<!ELEMENT layer_nb (#PCDATA)>

]>


<!-- Begining of the dump -->
" 
    
  (**
    The XML file's footer. Closes all pending tags.
  *)
  let footer =
    "

<!-- End of the dump -->"
    
  (**
    Saves the given XML content as an XML file, adding the LibML DTD.
    @param fileName The name of the output file's name.
    @param overwriteIfExists True if you don't want an exception to be raised
    if the specified file already exists.
    @raise FileExists if one tries to write an already existing file.
  *)
  let saveAsXml (fileName : string) (overwriteIfExists : bool)
    (xmlContent : string) =
    out ("Dumping neural network to XML as `" ^ fileName ^ "\' ...") 3;
    out ("Checking whether writing `" ^ fileName
		^ "\' is possible/enabled ...") 5;
    let outChannel =
      (
	if (Sys.file_exists fileName & not overwriteIfExists) then
	  raise FileExists;
	if (fileName <> "") then
	  (out ("Opening `" ^ fileName ^"' ...") 5;
	   open_out fileName)
	else
	  (err "No file name was provided." 2;
	   err "Setting the standard output as output of the dump ..." 2;
	   stdout)
      )
    in
      (**
	Writes a string in the opened file.
	@param str The string that is to be written.
      *)
    let write (str : string) =
      let writen = str ^ "
"
      in
	output outChannel (writen) 0 (String.length writen)
    in
      
      out "Writing XML header ..." 5;
      write header;
      out "Writing XML content ..." 5;
      write xmlContent;
      out "Writing XML footer ..." 5;
      write footer;
      out ("Closing `" ^ fileName ^ "\' ...") 5;
      close_out outChannel;
      out ("Neural network successfully dumped as `" ^ fileName ^ "\'.") 3
	
end
  
