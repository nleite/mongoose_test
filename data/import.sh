#!/usr/bin/python
from pymongo import Connection
import csv

databasename = 'geo'
collectionname = 'cities'
host = 'localhost:27017'

conn = None

def insert(document):
    global conn
    global databasename
    global collectionname
    if conn is None:
        conn = Connection(host)
    conn[databasename][collectionname].save(document)

def ensure_index():
    global conn
    global databasename
    global collectionname

    conn[databasename][collectionname].ensure_index( {'loc': '2d'})

def parse(filename, callback):
    with open(filename, 'rb') as csvfile:
        reader = csv.reader( csvfile, delimiter=',', quotechar='"')
        d = {}
        for row in reader:
            try: 
                int(row[0])
                keys = "locId,country,region,city,postalcode,latitude,longitude,metroCode,areaCode".split(',')
                #import ipdb;ipdb.set_trace()
                row = [ x.encode('utf-8') for x in row ]
                d = dict( zip( keys, row))
                d['loc'] = [ float(d['latitude']), float(d['longitude']) ]
                d.pop('latitude')
                d.pop('longitude')
                print d    
                callback(d) 
                #print ', '.join(row)
            except ValueError, e:
                print 'Skip first lines %s, document %s' % (e, d)


    ensure_index()

parse('GeoLiteCity_20090601/GeoLiteCity-Location.csv', insert)
