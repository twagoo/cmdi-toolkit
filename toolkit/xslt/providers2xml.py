#!/usr/bin/env python

# takes providers.tab and generates an XML mapping from OAI identifier to the title of the provider, to be used in olac2cmdi.xsl
# argument: the path to providers.tab
# eg: /home/dietuyt/svn/lat/oai/oai-harvester/trunk/src/main/assembly/resources/providers.csv

import sys

print "<providers>"

print
print "<!-- DO NOT EDIT THIS FILE. It is generated from providers.tab using a Python script. -->"
print

provList = open(sys.argv[1]).readlines()
for line in provList:
	if not "#" in line:
		elements = line.strip().split("\t")
		if len(elements) == 4:
			print "<prov> <identifier>%s</identifier> <name>%s</name> </prov>" % (elements[3], elements[1])

print "</providers>"