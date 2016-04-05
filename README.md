# MercuriChat

The goal of this project is to create a simple web client that uses TCP/WebSockets to connect to a chat server using HTML5, HTML5 WebSockets, CSS, JavaScript, and Ruby on Rails.

# Contributors
Emily Seto, Therese Kuczynski

# Progress (Week 03/29)
We started implementing Ruby on Rails and Bootstrap together (especially for the login and registration pages). We are still working on formatting the webpage. In order to run this application locally:

1. Download the source code.
2. Unzip the directory.
3. Access the unzipped directory using terminal. You must be inside of "MercuriChat".
4. Run `rails s`.
5. Go to your preferred browser, and type in "localhost:3000".

**NOTE:** Make sure that you have Ruby and Ruby on Rails installed locally. We are still figuring out how to host it on an accessible server.

# Progress (Week 04/05)
* The registration and sign in forms are almost all set!
* We started looking at HTML5 WebSockets and have created a local copy of our work.
	* I've been having difficulties integrating it into Rails, but hopefully this will be solved soon.
	* Source code is at:
		* app/assets/javascripts/dashboard.js 
		* app/views/layouts/_header.html.erb
	* Communication is only one-way at the moment. Will be fixed in the next day or two.
* Started looking into Devise for cleaner registration and login pages; also, for authentication.

In order to make your browser compatible with HTML5 WebSockets, we downloaded pywebsocket from (https://github.com/google/pywebsocket):

1. After we unzipped the download, go into `pywebsocket-master`.
2. Run `python setup.py build`.
3. Run `sudo python setup.py install`.
4. Run `cd mod_pywebsocket/`
5. In order to start this server, use the following command: `sudo python standalone.py -p <port_number_here> -w ../example/`
6. After, open your webpage that utilizes HTML5 WebSockets.

**NOTE:** All of these steps were based off of (http://www.tutorialspoint.com/html5/html5_websocket.htm "TutorialPoint's WebSocket page") with minor modifications to how I went through downloading and installing it.

