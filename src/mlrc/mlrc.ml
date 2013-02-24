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
  MLRC (Machine Learning Remote Control) is a program which can communicate
  with several mld daemons and feed them with some computations.
*)



(**
  A daemon is a host name or IP adress (the string) and a port
  number (the int).
*)
class daemon =
object
  
  (**
    A host name or an IP adress.
  *)
  val mutable _host : string = ""

  method getHost =
    _host

  method setHost (host : string) =
    _host <- host
      
  (**
    Port number.
  *)
  val mutable _port : int = 0

  method getPort =
    _port

  method setPort (port : int) =
    _port <- port

  method toString =
    _host ^ ":" ^ (string_of_int _port)

end


(**
  Raised if one tries to add an already known exception.
*)
exception DaemonExists



(**
  Main loop.
*)
let _ =


  (**
    The list of controled daemons.
  *)
  let daemons : daemon list ref = ref []
  in
    
  (**
    Gives the number of daemons controlled by this program.
  *)
  let sendDaemonsCount =
(fun x ->  (Printf.printf "%d daemons controlled\n" (List.length !daemons)))
    
  (**
    Gives the number of hosts on which daemons controlled by this program are
    running.
  *)
  and sendHostsCount =
    ()

  (**
    Gives the number of idle daemons.
  *)
  and sendIdleCount =
    ()

  (**
    Gives the number of computing daemons controlled by this program.
  *)
  and sendComputingCount =
    ()

  (**
    Gives all the known daemons.
  *)
  and sendDaemonsList =
    (fun x -> (Printf.printf "Known daemons:\n";
	      List.iter (fun dm -> Printf.printf "%s\n" dm#toString) !daemons))
    
  (**
    Adds a daemon to the list of known daemons.
    @raise DaemonExists if one tries to add an already knomn daemon.
  *)
  and addDaemon (dm : daemon) =
    (
      let isSame (currentDaemon : daemon) =
	((currentDaemon#getHost) = (dm#getHost) && (currentDaemon#getPort) = (dm#getPort))
      in
	match (List.exists isSame !daemons) with
	    false -> daemons := (List.rev_append !daemons [dm])
	  | true -> raise DaemonExists
    )

  (**
    Removes a daemon from the list of known daemons.
  *)
  and removeDaemon (dm : daemon) =
    ()

  (**
    Returns the log of a given daemon.
  *)
  and getLog (dm : daemon) =
    ()

  in


  let daemon1 = new daemon;
  in
    daemon1#setHost "127.0.0.1";
    daemon1#setPort 222;

    let daemon2 = new daemon;
    in
      daemon2#setHost "127.0.0.2";
      daemon2#setPort 222;
      
      addDaemon daemon1;
      sendDaemonsList;
      addDaemon daemon2;
      sendDaemonsList
