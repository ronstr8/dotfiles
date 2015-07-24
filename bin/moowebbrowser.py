#!/usr/bin/python
#
# Web Interface for Moo Database Browser
# Copyright (C) 2005 Neil Fraser, Scotland
# http://neil.fraser.name/software/moobrowser/
#
# This program is free software; you can redistribute it and/or modify it under the terms of version 2 of the GNU General Public License as published by the Free Software Foundation.
# This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
# See the GNU General Public License for more details.  http://www.gnu.org/

# What directory contains the Moo databases?
dbdirectory = "../html/software/moobrowser"

# Where is the moobrowser executible?
moobrowser = "../html/software/moobrowser/moobrowser"

# Optional JavaScript include that adds column sorting functionality.
tablesort = "<SCRIPT LANGUAGE='JavaScript1.2' SRC='http://neil.fraser.name/software/tablesort/tablesort.js'></SCRIPT>"
# Optional JavaScript syntax highlighting of Moo code.
highlight = "<SCRIPT LANGUAGE='JavaScript1.2' SRC='http://neil.fraser.name/software/moobrowser/inspector/colourcode.js'></SCRIPT>"

# This would be a good place to edit the style of the page.
def printpage(title, body):
  print "Content-Type: text/html\n"
  print """
<HTML>
<HEAD>
  <TITLE>Moo Browser - %s</TITLE>
  <link href="http://neil.fraser.name/software/moobrowser/moowebbrowser.css" rel="stylesheet" type="text/css">
  <meta name="robots" content="noindex,nofollow">
</HEAD>
<BODY>
<H1>%s</H1>
%s
<HR>
<DIV ID=credit><A HREF="http://neil.fraser.name/software/moobrowser/">Moo Web Browser v%s</A></DIV>
</BODY>
</HTML>
""" % (striptags(title), title, body, version)
  sys.exit()

# Nothing to edit below this line.
########################################
version = '1.1'

import cgi
import sys
import os
import re
import time
from stat import *

# Determine whether to show -r objects, verbs and properties.
showunreadable = 0
if os.environ.has_key('REMOTE_USER') and os.environ["REMOTE_USER"] != '':
  # The user has been authenticated by Apache.
  # Assume that any authenticated user is allowed.
  showunreadable = 1

# Remove all HTML tags from some text.
# Not robust enough for a generic function, but good enough for the cases encountered here.
def striptags(text):
  return re.sub('<[^>]+>', '', text)

# Execute the compiled C program with a command and read the results.
def callmoobrowser(db, command):
  progpipe = os.popen(moobrowser+" "+dbdirectory+"/"+db+" "+command)
  result = progpipe.readlines()
  progpipe.close()
  return result

# Parse top-level arguments from the URL.
form = cgi.FieldStorage()
db = ''
if form.has_key('db'):
  db = form['db'].value
obj = -1
if form.has_key('obj'):
  try:
    obj = int(form['obj'].value)
  except ValueError:
    pass # Can't parse number.
verbnum = -1
if form.has_key('verbnum'):
  verbnum = int(form['verbnum'].value)
propname = ''
if form.has_key('propname'):
  propname = form['propname'].value
mode = ''
if form.has_key('mode'):
  mode = form['mode'].value

# What is the name of this script?
# e.g. 'moowebbrowser.py' or '/scripts/moowebbrowser.py'
scriptname = os.environ["SCRIPT_NAME"]

# Sanity-check the inputs
if not os.path.exists(dbdirectory):
  printpage("Error", "Can't find directory of databases.<BR>Check the dbdirectory property.")
if not os.path.isfile(moobrowser):
  printpage("Error", "Can't find moobrowser application.<BR>Check the moobrowser property.")
if db and (db.find("/") != -1 or db.find("\\") != -1):
  printpage("Error", "Illegal character in database filename.")
if db and not os.path.isfile(dbdirectory+"/"+db):
  printpage("Error", "Can't find requested database.")

# No database specified.
if db == '':
  # Build an alphabetically sorted list of database links.
  text = ''
  dbs = os.listdir(dbdirectory)
  dbs.sort(lambda a, b: cmp(a.lower(), b.lower()))
  for db in dbs:
    if db.endswith(".db"):
      stat = os.stat(dbdirectory+"/"+db)
      size = int(stat[ST_SIZE] / 1024) + 1
      changetime = time.strftime("%x %X", time.localtime(stat[ST_MTIME]))
      text = text+'<TR class=file><TD class=filename><A HREF="%s?db=%s">%s</A></TD><TD class=filesize>%dKB</TD><TD class=filetime>%s</TD></TR>\n' % (scriptname, cgi.escape(db, 1), cgi.escape(db), size, changetime)
  if text:
    text = "<TABLE BORDER=1 class=file><THEAD><TR class=file><TH class=filename label=nocase>Name</TH><TH class=filesize label=num>Size</TH><TH class=filetime label=date>Modified</TH></TR></THEAD><TBODY>"+text+"</TBODY></TABLE>\n"
    text += tablesort
    text += """
<SCRIPT LANGUAGE='JavaScript1.2'><!--
if (typeof TableSort == "object") {
  // Date sorting.
  // Convert values from "dd/mm/yy hh:mm:ss" dates into "yymmddhh:mm:ss"
  // Compare two dictionary structures and indicate which is larger.
  TableSort.compare_date = function(a, b) {
    var aDate, bDate, m;
    m = a[0].match(/(\d+)\/(\d+)\/(\d+)\s+(.+)/);
    if (m) {
      aDate = m[3] + m[2] + m[1] + m[4];
    } else {
      aDate = " " + a[0].toLowerCase();
    }
    m = b[0].match(/(\d+)\/(\d+)\/(\d+)\s+(.+)/);
    if (m) {
      bDate = m[3] + m[2] + m[1] + m[4];
    } else {
      bDate = " " + b[0].toLowerCase();
    }
    if (aDate == bDate) {
      return 0;
    }
    return (aDate > bDate) ? 1 : -1;
  };
}
--></SCRIPT>
"""
  else:
    text = "<DIV class=empty>No databases found.</DIV>"
  text = "Databases available in <TT>"+os.path.abspath(dbdirectory)+"</TT><BR>"+text
  printpage("Browse:", text)

title = "<A HREF='%s'>Browse</A>: " % (scriptname)
text = ""

if mode == 'players':
  # List of all players or objects
  data = callmoobrowser(db, 'players')
  for line in data:
    if line.startswith("#"):
      text += "<LI><A HREF='%s?db=%s&obj=%s'>" % (scriptname, cgi.escape(db, 1), line[1:]) + line + "</A>"
    elif line.startswith(">") or line.startswith("Players:"):
      pass
    else:
      text += "<LI>" + line
  text = "<OL>" + text + "</OL>"
  title += "<A HREF='%s?db=%s'>%s</A>: %s:" % (scriptname, cgi.escape(db, 1), db, 'Players')

elif mode == 'objects':
  maxobject = -1
  objects = {}
  data = callmoobrowser(db, 'objects') # Make a dictionary of all objects
  for line in data:
    if line.endswith("\n"): # Chomp any trailing linefeed
      line = line[:-1]
    if line.startswith("#"):
      if line.endswith("recycled"):
        maxobject = int(line[1:line.index(' ')])
        objects[maxobject] = 3
      else:
        maxobject = int(line[1:])
        objects[maxobject] = 1
  data = callmoobrowser(db, 'players') # Add player info to the dictionary
  for line in data:
    if line.endswith("\n"): # Chomp any trailing linefeed
      line = line[:-1]
    if line.startswith("#"):
      objects[int(line[1:])] = 2

  pagesize = 1000
  startnum = 0
  if form.has_key('startnum'):
    startnum = int(form['startnum'].value)

  blocks = ''
  if maxobject+1 > pagesize:
    count = 0
    while count < maxobject+1:
      line = "#%d&nbsp;-&nbsp;#%d" % (count, min(count+pagesize-1, maxobject+1))
      if count == startnum:
        line = "<B>"+line+"</B>"
      else:
        line = "<A HREF='%s?db=%s&mode=objects&startnum=%d'>%s</A>" % (scriptname, cgi.escape(db, 1), count, line)
      blocks += line+"<BR>\n"
      count += pagesize
    blocks = blocks+"\n"

  grid = ''
  count = 0
  for x in (range(startnum, min(startnum+pagesize, maxobject+1))):
    line = ''
    if objects.has_key(x):
      line = "<A HREF='%s?db=%s&obj=%d'>#%d</A>" % (scriptname, cgi.escape(db, 1), x, x)
      if objects[x] == 2:
        line = "<B>"+line+"</B>"
      elif objects[x] == 3:
        line = "<S>"+line+"</S>"
      line = " "+line
    else:
      line = "#%d " % (x)
    # Add some uniform spacing for small numbers.
    if x <= 999: #0-#999
      line = " " + line
      if x <= 99: #0-#99
        line = " " + line
        if x <= 9: #0-#9
          line = " " + line
    count += 1
    if count >= 10:
      line += "\n"
      count = 0
    grid += line

  text = "<TABLE><TR><TD VALIGN=top>\n"+blocks+"\n</TD><TD VALIGN=top>\n<PRE>" + grid + "</PRE>\n</TD></TABLE>\n"
  title += "<A HREF='%s?db=%s'>%s</A>: %s:" % (scriptname, cgi.escape(db, 1), db, 'Objects')

elif obj > -1 and verbnum > -1:
  # Verb page
  data = callmoobrowser(db, "%d:%s" % (obj, verbnum))
  table = ''
  verbcode = ''
  verbname = "[Verb %s]" % (verbnum)
  indent = ""
  indent_start = ["if", "for", "while", "try", "fork"]
  indent_mid = ["elseif", "else", "except", "finally"]
  indent_end = ["endif", "endfor", "endwhile", "endtry", "endfork"]
  indent_start = indent_start + indent_mid
  indent_end = indent_end + indent_mid
  state = 0 # 0=table, 1=verbcode, 2=done
  readable = 0
  for line in data:
    if state == 0:
      if line.endswith("\n"): # Chomp any trailing linefeed
        line = line[:-1]
      if line.startswith(">"):
        pass
      elif line.startswith("Owner:\t#"): # Hyperlink the owner
        table += "<TR><TD>Owner:</TD><TD><A HREF='%s?db=%s&obj=%s'>#%s</A></TD></TR>\n" % (scriptname, cgi.escape(db, 1), line[line.index("#")+1:], line[line.index("#")+1:])
      elif line.find(":\t") != -1: # Name, Perms and other misc data
        table += "<TR><TD>" + cgi.escape(line[:line.index("\t")]) + "</TD><TD>" + cgi.escape(line[line.index("\t")+1:]) + "</TD></TR>\n"
        if line.startswith("Name:\t"):
          verbname = line[line.index("\t")+1:]
        if line.startswith("Perms:\t"):
          if line[line.index("\t")+1:].find("r") != -1:
            readable = 1
      elif table != "" and line == "":
        state = 1
    elif state == 1:
      if line == ".\n":
        state = 2
      else:
        # unindent on endif, endfor, etc
        for word in indent_end:
          if line.startswith(word + " ") or line == word + "\n":
            indent = indent[2:]
        verbcode += indent + line
        # indent on if, for, etc
        for word in indent_start:
          if line.startswith(word + " ") or line == word + "\n":
            indent = indent + "  "
  text = "<TABLE>" + table + "</TABLE>"
  if not readable and not showunreadable:
    text += "<DIV class=unreadable>unreadable</DIV>"
  else:
    text += "<PRE ID='code'>" + cgi.escape(verbcode) + "</PRE>"
    if highlight:
      text += highlight + """
<SCRIPT LANGUAGE='JavaScript1.2'><!--
colourcode('code');
//--></SCRIPT>"""
  title += "<A HREF='%s?db=%s'>%s</A>: <A HREF='%s?db=%s&obj=%s'>#%s</A>: %s" % (scriptname, cgi.escape(db, 1), db, scriptname, cgi.escape(db, 1), obj, obj, cgi.escape(verbname))

elif obj > -1 and propname != '':
  # Property page
  data = callmoobrowser(db, "%d.%s" % (obj, propname))
  text = "<TR><TD>Name:</TD><TD>" + cgi.escape(propname) + "</TD></TR>\n"
  readable = 0
  for line in data:
    if line.endswith("\n"): # Chomp any trailing linefeed
      line = line[:-1]
    if line.startswith(">"):
      pass
    sep = line.find(":\t")
    if sep != -1: # Name/Value pair
      name = cgi.escape(line[:sep])
      value = cgi.escape(line[sep + 2:])
      # Rely on the fact that 'Perms' will arrive before 'Value'.
      if name == "Perms" and value.find("r") != -1:
        readable = 1
      if name == "Value" and not readable and not showunreadable:
        value = "<DIV CLASS='unreadable'>unreadable</DIV>"
      # Hyperlink naked object numbers.
      if value.startswith("#") and value[1:].isdigit():
        value = "<A HREF='%s?db=%s&obj=%s'>%s</A>" % (scriptname, cgi.escape(db, 1), value[1:], value)
      text += "<TR><TD>%s:</TD><TD>%s</TD></TR>\n" % (name, value)
  text = "<TABLE>" + text + "</TABLE>"
  title += "<A HREF='%s?db=%s'>%s</A>: <A HREF='%s?db=%s&obj=%s'>#%s</A>: .%s" % (scriptname, cgi.escape(db, 1), db, scriptname, cgi.escape(db, 1), obj, obj, cgi.escape(propname))

elif obj > -1:
  # Object page
  data = callmoobrowser(db, "%d" % (obj))
  owned = ""
  contents = ""
  children = ""
  verbs = ""
  props = ""
  readable = 0
  recycled = 0
  exists = 0
  for line in data:
    if line.endswith("\n"): # Chomp any trailing linefeed
      line = line[:-1]
    m = re.search("^(Owner|Location|Parent):\t#(\d+)$", line)
    if line.startswith(">"):
      pass
    elif line == 'Recycled': # Object has been hard-recycled.
      recycled = 1
    elif line.startswith("Owns:"): # Collect all the children
      if owned != "":
        owned += ", "
      owned += "<A HREF='%s?db=%s&obj=%s'>#%s</A>" % (scriptname, cgi.escape(db, 1), line[len("Owns: #"):], line[len("Owns: #"):])
    elif line.startswith("Contains:"): # Collect all the contents
      if contents != "":
        contents += ", "
      contents += "<A HREF='%s?db=%s&obj=%s'>#%s</A>" % (scriptname, cgi.escape(db, 1), line[len("Contains: #"):], line[len("Contains: #"):])
    elif line.startswith("Child:"): # Collect all the children
      if children != "":
        children += ", "
      children += "<A HREF='%s?db=%s&obj=%s'>#%s</A>" % (scriptname, cgi.escape(db, 1), line[len("Child: #"):], line[len("Child: #"):])
    elif line.startswith("Property "): # Group the properties
      props += "<LI>%s.<A HREF='%s?db=%s&obj=%i&propname=%s'>%s</A>" % (line[line.index("#"):line.index(".")], scriptname, cgi.escape(db, 1), obj, line[line.index(".")+1:], cgi.escape(line[line.index(".")+1:], 1))
    elif line.startswith("Verb "): # Group the verbs
      verbs += "<LI>#%i:<A HREF='%s?db=%s&obj=%i&verbnum=%s'>%s</A>" % (obj, scriptname, cgi.escape(db, 1), obj, line[line.index(" ")+1:line.index(":")], cgi.escape(line[line.index(":\t:")+3:]))
    elif m: # Owner, Location, Parent (with hyperlinkable object)
      text += "<TR><TD>%s:</TD><TD><A HREF='%s?db=%s&obj=%s'>#%s</A></TD></TR>\n" % (m.group(1), scriptname, cgi.escape(db, 1), m.group(2), m.group(2))
    elif line.find(":\t") != -1: # Name, Flags and other misc data
      exists = 1
      text += "<TR><TD>" + cgi.escape(line[:line.index("\t")]) + "</TD><TD>" + cgi.escape(line[line.index("\t")+1:]) + "</TD></TR>\n"
      if line.startswith("Flags:\t"):
        if (" " + line[line.index("\t") + 1:] + " ").find(" r ") != -1:
          readable = 1
  if contents == "":
    contents = "<DIV class=empty>None.</DIV>"
  if children == "":
    children = "<DIV class=empty>None.</DIV>"
  if owned == "":
    owned = "<DIV class=empty>None.</DIV>"
  text = "<TABLE>" + text + "<TR><TD VALIGN=top>Owns:</TD><TD>" + owned + "</TD></TR><TR><TD VALIGN=top>Contents:</TD><TD>" + contents + "</TD></TR><TR><TD VALIGN=top>Children:</TD><TD>" + children + "</TD></TR></TABLE>"
  text += "<P>Properties:"
  if props == "":
    text += "<DIV class=empty>No properties defined.</DIV>"
  elif not readable and not showunreadable:
    text += "<DIV class=unreadable>unreadable</DIV>"
  else:
    text += "<UL>" + props + "</UL>"
  text += "<P>Verbs:"
  if verbs == "":
    text += "<DIV class=empty>No verbs defined.</DIV>"
  elif not readable and not showunreadable:
    text += "<DIV class=unreadable>unreadable</DIV>"
  else:
    text += "<UL>" + verbs + "</UL>"
  if exists == 0:
    if recycled == 1:
      text = "<DIV class=empty>Object is recycled.</DIV>"
    else:
      text = "<DIV class=empty>Object does not exist.</DIV>"
  title += "<A HREF='%s?db=%s'>%s</A>: #%s:" % (scriptname, cgi.escape(db, 1), db, obj)

else:
  # Summary page
  stat = os.stat(dbdirectory+"/"+db)
  size = stat[ST_SIZE] / 1024 + 1
  changetime = time.strftime("%x %X", time.localtime(stat[ST_MTIME]))
  data = callmoobrowser(db, "")
  format = ''
  for line in data:
    if line.endswith("\n"): # Chomp any trailing linefeed
      line = line[:-1]
    if line.startswith(">"): # Drop the echo of the command
      pass
    elif line.startswith("**"): # Identify the database format string
      format = line
    elif line.startswith("Players:"): # Link the number of players
      text += "<TR><TD><A HREF='%s?db=%s&mode=players'>Players:</A></TD><TD>%s</TD></TR>" % (scriptname, cgi.escape(db, 1), line[len("Players:"):])
    elif line.startswith("Objects:"): # Link the number of objects
      text += "<TR><TD><A HREF='%s?db=%s&mode=objects'>Objects:</A></TD><TD>%s</TD></TR>" % (scriptname, cgi.escape(db, 1), line[len("Objects:"):])
    else:
      div = line.find(" ")
      text += "<TR><TD>%s</TD><TD>%s</TD></TR>" % (line[:div], line[div+1:])
  text += "<TR><TD>Size:</TD><TD>%dKB</TD></TR>" % (size)
  text += "<TR><TD>Modified:</TD><TD>%s</TD></TR>" % (changetime)

  text = """
<TABLE>%s</TABLE>
<P>
<FORM ACTION="%s">
  <INPUT TYPE=hidden NAME=db VALUE="%s">
  #<INPUT TYPE=text NAME=obj SIZE=6>
  <INPUT TYPE=submit VALUE='View'>
</FORM>
<P>
<EM>%s</EM>
""" % (text, scriptname, db, format)
  title += db + ':'

printpage(title, text)
