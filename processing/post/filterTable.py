#!/usr/bin/env python

import os,re,sys,fnmatch,math,string,damask
from optparse import OptionParser, Option

scriptID = '$Id$'
scriptName = scriptID.split()[1]

# -----------------------------
class extendableOption(Option):
# -----------------------------
# used for definition of new option parser action 'extend', which enables to take multiple option arguments
# taken from online tutorial http://docs.python.org/library/optparse.html
  
  ACTIONS = Option.ACTIONS + ("extend",)
  STORE_ACTIONS = Option.STORE_ACTIONS + ("extend",)
  TYPED_ACTIONS = Option.TYPED_ACTIONS + ("extend",)
  ALWAYS_TYPED_ACTIONS = Option.ALWAYS_TYPED_ACTIONS + ("extend",)

  def take_action(self, action, dest, opt, value, values, parser):
    if action == "extend":
      lvalue = value.split(",")
      values.ensure_value(dest, []).extend(lvalue)
    else:
      Option.take_action(self, action, dest, opt, value, values, parser)



# --------------------------------------------------------------------
#                                MAIN
# --------------------------------------------------------------------

parser = OptionParser(option_class=extendableOption, usage='%prog options [file[s]]', description = """
Filter rows according to condition and columns by either white or black listing.

Examples:
Every odd row if x coordinate is positive -- " #ip.x# >= 0.0 and #_row_#%2 == 1 ).
All rows where label 'foo' equals 'bar' -- " #s#foo# == \"bar\" "
""" + string.replace(scriptID,'\n','\\n')
)


parser.add_option('-w','--white',   dest='whitelist', action='extend', type='string', \
                                    help='white list of column labels (a,b,c,...)', metavar='<LIST>')
parser.add_option('-b','--black',   dest='blacklist', action='extend', type='string', \
                                    help='black list of column labels (a,b,c,...)', metavar='<LIST>')
parser.add_option('-c','--condition', dest='condition', type='string', \
                                    help='condition to filter rows', metavar='<EXPR>')

parser.set_defaults(whitelist = [])
parser.set_defaults(blacklist = [])
parser.set_defaults(condition = '')

(options,filenames) = parser.parse_args()


# ------------------------------------------ setup file handles ---------------------------------------  

files = []
if filenames == []:
  files.append({'name':'STDIN', 'input':sys.stdin, 'output':sys.stdout, 'croak':sys.stderr})
else:
  for name in filenames:
    if os.path.exists(name):
      files.append({'name':name, 'input':open(name), 'output':open(name+'_tmp','w'), 'croak':sys.stderr})

# ------------------------------------------ loop over input files ---------------------------------------  

for file in files:
  if file['name'] != 'STDIN': file['croak'].write('\033[1m'+scriptName+'\033[0m: '+file['name']+'\n')
  else: file['croak'].write('\033[1m'+scriptName+'\033[0m\n')

  specials = { \
               '_row_': 0,
             }

  table = damask.ASCIItable(file['input'],file['output'],False)             # make unbuffered ASCII_table
  table.head_read()                                                         # read ASCII header info
  table.info_append(string.replace(scriptID,'\n','\\n') + \
                    '\t' + ' '.join(sys.argv[1:]))

  labels = []
  positions = []
  for position,label in enumerate(table.labels):
    if    (options.whitelist == [] or     any([fnmatch.fnmatch(label,needle) for needle in options.whitelist])) \
      and (options.blacklist == [] or not any([fnmatch.fnmatch(label,needle) for needle in options.blacklist])):      # a label to keep?
      labels.append(label)                                                  # remember name...
      positions.append(position)                                            # ...and position

  interpolator = []
  for position,operand in enumerate(set(re.findall(r'#(([s]#)?(.+?))#',options.condition))):  # find three groups
    options.condition = options.condition.replace('#'+operand[0]+'#',
                                                  {  '': '{%i}'%position,
                                                   's#':'"{%i}"'%position}[operand[1]])
    if operand[2] in specials:                                              # special label ?
      interpolator += ['specials["%s"]'%operand[2]]
    else:
      try:
        interpolator += ['%s(table.data[%i])'%({  '':'float',
                                                's#':'str'}[operand[1]],
                                               table.labels.index(operand[2]))]
      except:
        parser.error('column %s not found...\n'%operand[2])

  evaluator = "'" + options.condition + "'.format(" + ','.join(interpolator) + ")"
  
# ------------------------------------------ assemble header ---------------------------------------  

  table.labels = labels                                                     # update with new label set
  table.head_write()

# ------------------------------------------ process data ---------------------------------------  

  outputAlive = True
  while outputAlive and table.data_read():                                  # read next data line of ASCII table

    specials['_row_'] += 1                                                  # count row
    
    if options.condition == '' or eval(eval(evaluator)):                    # valid row ?
      table.data = [table.data[position] for position in positions]         # retain filtered columns
      outputAlive = table.data_write()                                      # output processed line

# ------------------------------------------ output result ---------------------------------------  

  outputAlive and table.output_flush()                                      # just in case of buffered ASCII table

  file['input'].close()                                                     # close input ASCII table
  if file['name'] != 'STDIN':
    file['output'].close()                                                  # close output ASCII table
    os.rename(file['name']+'_tmp',file['name'])                             # overwrite old one with tmp new
