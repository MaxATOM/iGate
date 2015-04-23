# iGate
iGate is a full gate system at home. It lets you to enter and leave your home without caring a remote control, regardless going to see who is ringing at the entrance, and even knowing when and who to open the gate.

When you arrive home, by approaching by car to the entrance of your home, the gate detects your smartphone and opens automatically, only for you.
Once installed on your couch, watch what is happening around your home with outdoor surveillance, or check who open the gate during the day.

![iGate demo](https://cloud.githubusercontent.com/assets/3249418/6460474/c744fd02-c197-11e4-989e-ee9387f30418.png)

Preview
-----------------

The system is distributed across multiple platforms: a tablet application, smartphone application, a website and an opening manager, located near the gate.

![iGate simple diagram](https://cloud.githubusercontent.com/assets/3249418/6460566/7aec3e24-c198-11e4-8905-91cb7e34780d.png)

<h3>Overall system preview</h3>

![System diagram](https://cloud.githubusercontent.com/assets/3249418/6460790/9fb6510c-c19a-11e4-82d9-305a7914cb3d.png)

<h3>Mind map</h3>

<em>Three people have worked on the project.</em>

![iGate mind map](https://cloud.githubusercontent.com/assets/3249418/6460767/6feaa40a-c19a-11e4-86b9-c8056e8a2d3d.jpg)

Set-up the system
----------------

In order to the system to be fully functional, you need to proceed in this way:
* Prepare a Raspberry Pi with NOOBs or Raspbian (I have not tested other images, but it should work), install Python and several libraries: [PyBluez](https://code.google.com/p/pybluez/ "PyBluez"), [ParsePy](https://github.com/dgrtwo/ParsePy "ParsePy") and [Motion](https://medium.com/@Cvrsor/how-to-make-a-diy-home-alarm-system-with-a-raspberry-pi-and-a-webcam-2d5a2d61da3d "Motion")
* Prepare the Parse database: create two bases (BTList and iGateDB) with the following attributes: "address", "name" for BTList and  "user", "mode\_ouverture", "identifiant", "adresse", "date" (type: date) for iGateDB
* If you want here is the link of the two bases pre-filled with records examples : [iGateDB](https://s3.amazonaws.com/export.parse.com/3653415a-3370-450b-a1d8-f4783f4f569b_1425400504_export.zip?AWSAccessKeyId=AKIAIOZ4MOVEOQZ2326Q&Expires=1428078904&Signature=ShEq7kWFOtpk2a7ProWWOXsZTJ4%3D "iGateDB"), and [BTList](https://s3.amazonaws.com/export.parse.com/3653415a-3370-450b-a1d8-f4783f4f569b_1425400488_export.zip?AWSAccessKeyId=AKIAIOZ4MOVEOQZ2326Q&Expires=1428078889&Signature=Gko1SC5oPTvU7tdm38toitsGX%2Bk%3D "BTList")
* Enter Parse ID on server.py (Application and REST Key)
* Start the server: ./igateserver.sh start
* Start Motion
* Install at least one mobile application on a device, and the one (enter also Parse Key) on an iPad.
* Enter Parse ID on html files
* You're done !

Development
---------------
Simulation and hardware available forced us to use a motor that simulates the operation of a sliding gate, but the overall operation is exactly the same. Programming is the most important part of the project, it makes live the heart of the system.
We find in several places of the system : in the smartphone and tablet applications in the Raspberry Pi server program and the E-Block.
To recap, I realized applications for the iPhone and iPad and the server Raspberry Pi For the remainder of this file program, we look at the iPhone application and the server program.
Below is a diagram showing the relationship between programming and gate.

![Dev diagram](https://cloud.githubusercontent.com/assets/3249418/6460867/38ca6df6-c19b-11e4-989c-c03c4e7aebc4.png)

Amount of the project
---------------

iGate at a reasonable cost, although there have no gate itself. The cost of smartphone or tablet is not accounted for, it’s assumed that you are already in possession of both.
The total price is $240 allocated as follows :
* 1 complete Raspberry Pi : $80
* 1 E-Block set : $130
* 1 servomotor : $30

Thanks
---------------

I extend my thanks to Mr. S. Siot Taillefer and Mr. JL. Tayan for all help provided during this 28 sessions.