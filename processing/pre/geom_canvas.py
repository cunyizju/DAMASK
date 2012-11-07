#!/usr/bin/env python
# -*- coding: UTF-8 no BOM -*-

import os,sys,string,re,math,numpy
from optparse import OptionParser, OptionGroup, Option, SUPPRESS_HELP


# -----------------------------
class extendedOption(Option):
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


# ----------------------- MAIN -------------------------------

identifiers = {
        'resolution': ['a','b','c'],
        'dimension':  ['x','y','z'],
        'origin':     ['x','y','z'],
          }
mappings = {
        'resolution': lambda x: int(x),
        'dimension':  lambda x: float(x),
        'origin':     lambda x: float(x),
        'homogenization': lambda x: int(x),
          }


parser = OptionParser(option_class=extendedOption, usage='%prog options [file[s]]', description = """
Changes the (three-dimensional) canvas of a spectral geometry description.
""" + string.replace('$Id$','\n','\\n')
)

parser.add_option('-b', '--box', dest='resolution', type='int', nargs = 3, \
                  help='resolution of new canvas (a,b,c) %default')
parser.add_option('-o', '--offset', dest='offset', type='int', nargs = 3, \
                  help='offset from old to new origin of grid %default')
parser.add_option('-f', '--fill', dest='fill', type='int', \
                  help='(background) canvas grain index')
parser.add_option('-2', '--twodimensional', dest='twoD', action='store_true', \
                  help='output geom file with two-dimensional data arrangement')

parser.set_defaults(resolution = [0,0,0])
parser.set_defaults(offset = [0,0,0])
parser.set_defaults(twoD = False)
parser.set_defaults(fill = 0)

(options, filenames) = parser.parse_args()

# ------------------------------------------ setup file handles ---------------------------------------  

files = []
if filenames == []:
  files.append({'name':'STDIN',
                'input':sys.stdin,
                'output':sys.stdout,
                'croak':sys.stderr,
               })
else:
  for name in filenames:
    if os.path.exists(name):
      files.append({'name':name,
                    'input':open(name),
                    'output':open(name+'_tmp','w'),
                    'croak':sys.stdout,
                    })

# ------------------------------------------ loop over input files ---------------------------------------  

for file in files:
  if file['name'] != 'STDIN': file['croak'].write(file['name']+'\n')

  #  get labels by either read the first row, or - if keyword header is present - the last line of the header

  firstline = file['input'].readline()
  m = re.search('(\d+)\s*head', firstline.lower())
  if m:
    headerlines = int(m.group(1))
    headers  = [firstline]+[file['input'].readline() for i in range(headerlines)]
  else:
    headerlines = 1
    headers = firstline

  content = file['input'].readlines()
  file['input'].close()

  info = {'resolution': numpy.array(options.resolution),
          'dimension':  numpy.array([0.0,0.0,0.0]),
          'origin':     numpy.array([0.0,0.0,0.0]),
          'homogenization': 1,
         }

  new_header = []
  for header in headers:
    headitems = map(str.lower,header.split())
    if headitems[0] in mappings.keys():
      if headitems[0] in identifiers.keys():
        for i in xrange(len(identifiers[headitems[0]])):
          info[headitems[0]][i] = \
            mappings[headitems[0]](headitems[headitems.index(identifiers[headitems[0]][i])+1])
      else:
        info[headitems[0]] = mappings[headitems[0]](headitems[1])

  if numpy.all(options.resolution == 0):
    options.resolution = info['resolution']
  if numpy.all(info['resolution'] == 0):
    file['croak'].write('no resolution info found.\n')
    continue
  if numpy.all(info['dimension'] == 0.0):
    file['croak'].write('no dimension info found.\n')
    continue

  file['croak'].write('resolution:     %s\n'%(' x '.join(map(str,info['resolution']))) + \
                      'dimension:      %s\n'%(' x '.join(map(str,info['dimension']))) + \
                      'origin:         %s\n'%(' : '.join(map(str,info['origin']))) + \
                      'homogenization: %i\n'%info['homogenization'])

  new_header.append("resolution\ta %i\tb %i\tc %i\n"%( 
    options.resolution[0],
    options.resolution[1],
    options.resolution[2],))
  new_header.append("dimension\tx %f\ty %f\tz %f\n"%(
    info['dimension'][0]/info['resolution'][0]*options.resolution[0],
    info['dimension'][1]/info['resolution'][1]*options.resolution[1],
    info['dimension'][2]/info['resolution'][2]*options.resolution[2],))
  new_header.append("origin\tx %f\ty %f\tz %f\n"%(
    info['origin'][0]+info['dimension'][0]/info['resolution'][0]*options.offset[0],
    info['origin'][1]+info['dimension'][1]/info['resolution'][1]*options.offset[1],
    info['origin'][2]+info['dimension'][2]/info['resolution'][2]*options.offset[2],))
  new_header.append("homogenization\t%i\n"%info['homogenization'])

  microstructure = numpy.zeros(info['resolution'],'i')
  i = 0
  for line in content:  
    for item in map(int,line.split()):
      microstructure[i%info['resolution'][0],
                    (i/info['resolution'][0])%info['resolution'][1],
                     i/info['resolution'][0] /info['resolution'][1]] = item
      i += 1
  
  microstructure_cropped = numpy.zeros(options.resolution,'i')
  microstructure_cropped.fill({True:options.fill,False:microstructure.max()+1}[options.fill>0])
  xindex = list(set(xrange(options.offset[0],options.offset[0]+options.resolution[0])) & set(xrange(info['resolution'][0])))
  yindex = list(set(xrange(options.offset[1],options.offset[1]+options.resolution[1])) & set(xrange(info['resolution'][1])))
  zindex = list(set(xrange(options.offset[2],options.offset[2]+options.resolution[2])) & set(xrange(info['resolution'][2])))
  translate_x = [i - options.offset[0] for i in xindex]
  translate_y = [i - options.offset[1] for i in yindex]
  translate_z = [i - options.offset[2] for i in zindex]
  microstructure_cropped[min(translate_x):(max(translate_x)+1),min(translate_y):(max(translate_y)+1),min(translate_z):(max(translate_z)+1)] = microstructure[min(xindex):(max(xindex)+1),min(yindex):(max(yindex)+1),min(zindex):(max(zindex)+1)]
  formatwidth = int(math.floor(math.log10(microstructure.max())+1))

            
# ------------------------------------------ assemble header ---------------------------------------  

  output  = '%i\theader\n'%(len(new_header))
  output += ''.join(new_header)

# ------------------------------------- regenerate texture information ----------------------------------  

  for z in xrange(options.resolution[2]):
    for y in xrange(options.resolution[1]):
      output += {True:' ',False:'\n'}[options.twoD].join(map(lambda x: ('%%%ii'%formatwidth)%x, microstructure_cropped[:,y,z])) + '\n'
    
    #output += '\n'
    
# ------------------------------------------ output result ---------------------------------------  

  file['output'].write(output)

  if file['name'] != 'STDIN':
    file['output'].close()
    os.rename(file['name']+'_tmp',file['name'])
    