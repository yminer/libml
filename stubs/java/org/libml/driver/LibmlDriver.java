/*
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
*/

package org.libml.driver;

import org.libml.axis.LibmlStub;
import org.libml.axis.LibmlLocator;

import java.net.MalformedURLException;
import java.net.URL;
import java.rmi.RemoteException;

import org.apache.axis.AxisFault;

/**
 * This abstract class enables you to connect to a mld daemon and send
 * computations to it.
 * @author Olivier Ricordeau <olivier@libml.org>
 */
public abstract class LibmlDriver
{

	/**
	 * The default port is set to 4242.
	 */
	protected int _port = 4242;

	/**
	 * This object is set up by the connect method, and enables you to call
	 * methods on mld.
	 */
	protected LibmlStub _stub;
	
	/**
	* Default constructor, sets the port to 4242.
	 */
	public LibmlDriver()
	{
	}

	/**
	 * A constructor which enables to connect on a given port.
	 * @param port Use a specific port instead of 4242.
	 */
	public LibmlDriver(int port)
	{
		this();
		_port = port;
	}


	/**
	 * An accessor to the LibmlStub object.
	 * @return The LibmlStub object, used to call methods on mld after the
	 * connection is established.
	 */
	public LibmlStub stub()
	{
		return _stub;
	}

	/**
	 * Use this method after you instanciated so that it connects to the mld
	 * daemon.
	 */
	public void connect() throws MalformedURLException, AxisFault
	{
		URL url = null;
		System.out.println("Connecting to 127.0.0.1 on port " + _port);

		try { url = new URL("http://localhost:" + _port); }
		catch (MalformedURLException e)
		{ System.out.println("Exception while connecting:");
			System.out.println(e.getMessage());
			throw e; }

		try { _stub = new LibmlStub(url, new LibmlLocator()); }
		catch (AxisFault e)
		{ System.out.println("Exception while connecting:");
			 System.out.println(e.getMessage());
			 throw e; }
	}

	/**
	 * Objects which inherit from this class should implement this method
	 * which runs calls to mld after connection is done by the connect method.
	 * You can see this method as a main.
	 * @throws RemoteException If an error happens while talking to mld.
	 */
	abstract public void run() throws RemoteException;

	/**
	 * Behavior if a AxisFaultException is caught.
	 */
	public static void onAxisFault(AxisFault e)
	{
		System.err.println("Internal error in the SOAP engine!");
		leaveOnException(e);
	}

	/**
	 * Behavior if a MalformedURLException is caught.
	 */
	public static void onMalformedURL(MalformedURLException e)
	{
   		System.err.println("Probably a bad hostname was provided!");
		leaveOnException(e);
	}

	/**
	 * Behavior if a RemoteException is caught.
	 */
	public static void onRemote(RemoteException e)
	{
		System.err.println("Remote error while communicating with mld!");
		leaveOnException(e);
	}

	/**
	 * Prints an exception and leaves.
	 */
	protected static void leaveOnException(Exception e)
	{
		System.err.println(e.getMessage());
		System.err.println("Aborting...");
		System.exit(1);
	}

}
