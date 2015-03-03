#!/usr/bin/env python

# Importation des bibliothèques
from bluetooth import *
import pickle

# Création du pickle
pickleBT = pickle

# Création puis récupération de la liste des adresse Bluetooth depuis le pickle
btAdressList = list();
btAdressList = pickleBT.load(open("btADD","rb"))

# Affichage de la liste des adresses autorisés
print (btAdressList)

# Démarrage du scan Bluetooth
nearby_devices = discover_devices(lookup_names = True)

# Affichage du nombre d'appareils détectés à proximité
print "Detection de %d appareils" % len(nearby_devices)

# Boucle pour chaque appareil
for name, addr in nearby_devices:
    if addr is not None:
        
        # Concaténation de l'adresse Mac et du nom
        combined = addr + '//' + name
        print(combined)
        
        # Si l'adresse existe dans la liste, on ouvre le portail
        if (combined in btAdressList):
            print('on ouvre le portail car', combined, 'existe')

  
