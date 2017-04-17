## Test environments
As of 9:33 Paril 07, 2017


* local Windows 10, R 3.3.3
* ubuntu, os x, R 3.3.3 (travis-ci)
* Windows, R 3.3.3 (on appveyor)

## R CMD check results

There were no ERRORs or WARNINGs.

There was 2 NOTEs:
Possibly mis-spelled words in DESCRIPTION:
  html (11:30)
  
All words are correctly spelled. 

AND

Found the following (possibly) invalid URLs:
  URL: "ftp://client_climate@ftp.tor.ec.gc.ca/Pub/Get_More_Data_Plus_de_donnees/Station Inventory EN.csv"
    From: man/stations_all.Rd
    Message: Invalid URI scheme

Using ftp in this instance which throws an error here.	

## Downstream dependencies

