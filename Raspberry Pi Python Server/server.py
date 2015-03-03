#!/usr/bin/env python
# -*- coding: utf-8 -*-

# Importation des bibliothèques
from twisted.internet.protocol import Factory, Protocol
from twisted.internet import reactor
from twisted.internet import task
from bluetooth import *
from config import *

import os
import signal
import prowlpy
import time
import urllib2
import pickle
import sys
import subprocess
from utils import printTitle, printSubTitle, printExplain, printTab, printError
from parse_rest.connection import register, ParseBatcher
from parse_rest.datatypes import Object as ParseObject


# Boucle et timeout du scan Bluetooth
bluetoothLoop = task.LoopingCall(scanBluetoothDevice)
timeout = 15.0

# Création du pickle
pickleBT = pickle

# Création de la liste des adresses Bluetooth
btAdressList = list();

# Variable de l'appareil actuel et de son adresse Mac
actualDevice = "device"
actualMac = "mac"
# Identifiants Parse et connexion
APPLICATION_ID = ""
REST_API_KEY = ""
register(APPLICATION_ID, REST_API_KEY)


# Appel du script Bluetooth
def scanBluetoothDevice():
  os.system("python Bluetooth.py &")

# Initialisation et démarrage du serveur
factory = Factory()
factory.protocol = iGateServer
reactor.listenTCP(PORT, factory, 50, IFACE)
reactor.run()

# Classe de la réception d'une requête (message)
class iGateServer(Protocol):
  def connectionMade(self):

    print("Un appareil est connecte")

  def dataReceived(self, data):
    
    # Objet Prowl pour la notification
    apikey = '37ffac54cd7dc51ce06e55ec2c77eb9db386783d'
    p = prowlpy.Prowl(apikey)
    # Affichage du socket reçu
    print(data)
    
    # Requête reçu
    if data == "open":
      print("Ouverture du portail…")
      time.sleep(5)
      try:
         p.add('iGate ',' Portail ouvert !'," ", 1, None, None)
         print 'Success'
         histoy = []
         histoy.append(createBTList(name=actualDevice, address=actualMac))
         batcher = ParseBatcher()
         batcher.batch_save(histoy)
      except Exception,msg:
         print msg
      
    elif data.startswith('[DEVICE]'):
      actualDevice = data.replace("[DEVICE]", "") # On enlève le DEVICE
      actualDevice = actualDevice.replace("\n", "") # On enlève le \n
      device = data.split("//") # On sépare actualDevice en deux (nom et adresse Mac)
      actualDevice = deivce[0]
      actualMac = device[1]
      
    elif data == "Galaxy":
      print("Un Galaxy S4 est connecté")
    elif data == "Wiko":
      print("Un Wiko est connecté")
    elif data == "iPhone":
      print("Un iPhone est connecté")
    elif data == "iPad":
      print("Un iPad est connecté")
    
    # Ajout d'une adresse Bluetooth
    elif data.startswith( '[ADDBT]' ):
      BTADRESS = data.replace("[ADDBT]", "") # On enlève le ADDBT
      BTADRESS = BTADRESS.replace("\n", "") # On enlève le \n
      try:
        btAdressList = pickleBT.load(open("btADD","rb")) # On essaye d'ouvrir la sauvegarde des adresse BT autorisées
        print("on est ouvert")
        print(btAdressList) # On affiche la liste actuelle
      except EOFError:
        print("c'est vide") # Aucune adresse, la liste est vide
      newList = [] # Nouveau tableau
      try:
        if isinstance(btAdressList, basestring):  # On check si notre liste à 1 seule adresse (c'est un string)     
          newList = btAdressList.split() # On transforme notre string en un tableau (list)
          print("on est dans un string")
        else:
          print("on est deja dans un tableau") # Sinon, notre liste à plusieurs adresses, c'est bien un list
          newList = btAdressList # On garde notre tableau actuel
      except NameError:
        print('notre liste est vide')
      newList.append(BTADRESS); # On ajoute la nouvelle adresse
      print ("list",newList)
      finalList = list(set(newList)) # On supprime les memes adresses
      print("final list",finalList)
      pickleBT.dump(finalList, open( "btADD", "wb" ) ) # On sauvegarde notre finalList
      infoBT = BTADRESS.split("//") # On sépare notre BTADRESSE en deux (nom et adresse Mac)
      print('Name :',infoBT[0])
      print('Address : ',infoBT[1])

    # Suppresion d'une adresse Bluetooth
    elif data.startswith( '[REMOVEBT]' ):
      BTADRESS = data.replace("[REMOVEBT]", "") # On enlève le ADDBT
      BTADRESS = BTADRESS.replace("\n", "") # On enlève le \n
      try:
        btAdressList = pickleBT.load(open("btADD","rb")) # On essaye d'ouvrir la sauvegarde des adresses BT autorisées
        print("on est ouvert")
        print(btAdressList)
      except EOFError:
        print("c'est vide") # Aucune adresse, la liste est vide
      filtered = [ v for v in btAdressList if not v.startswith(BTADRESS) ] # On supprime les adresse identiques
      pickleBT.dump(filtered, open( "btADD", "wb" ) ) # On sauvegarde notre finalList
      print (filtered) # On affiche la liste  finale
      infoBT = BTADRESS.split("//") # On sépare notre BTADRESSE en deux (nom et adresse Mac)
      print('Name :',infoBT[0])
      print('Address : ',infoBT[1])
    elif data == "scanBT\n":
      bluetoothLoop.start(timeout) # On lance la boucle du scan BT de Nico
    elif data == "stopBT\n":
      bluetoothLoop.stop() # On arrete la boucle

# Classe BTList
class BTList(ParseObject):
    pass

def createBTList(name, address):
    histo = BTList(**locals())
    
    return histo





