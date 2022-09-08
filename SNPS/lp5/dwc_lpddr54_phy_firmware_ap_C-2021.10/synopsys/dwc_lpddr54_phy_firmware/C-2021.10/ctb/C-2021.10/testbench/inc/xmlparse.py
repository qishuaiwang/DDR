#!/global/freeware/Linux/RHEL6/python-3.7.0/bin/python
import xml.etree.ElementTree as et
import re
import copy

def createAssocArr(csrDict,outFileName):
    with open(outFileName, "w") as fh:
        for k in csrDict:
            fh.write(f'arr["{k}"] = new("{k}",{svHex(csrDict[k])});\n')

def createApbMapFile(csrDict,outFileName):
    with open(outFileName, "w") as fh:
        for k in csrDict:
            fh.write(f'if (addr == {svHex(csrDict[k])} ) $display("\taccess to {k}");\n')

def createDefinesFile(cd,cdc,outFileName):
    localDict = copy.deepcopy(cd)
    localDict.update(cdc)
    with open(outFileName, "w") as fh:
        for k in localDict:
            fh.write(f'`define {k} {svHex(localDict[k])}\n')

def svHex(i):
    return f"'h{hex(i)[2:]}"

def toInt(s):
    if s[:2] == '0x':
        return int(s[2:],16)
    elif s[:2] == "'h":
        return int(s[2:],16)
    if s[:2] == '0o':
        return int(s[2:],8)
    else:
        return int(s)

def parsefile(fp):
    tree = et.parse(fp)
    root = tree.getroot()
    ns =  re.match(r'{.*}', root.tag).group(0)
    # print(ns)
    d = dict()
    dc = dict()
    
    for addBlk in root.iter(f'{ns}addressBlock'):
        #Get key address block attributes
        blkName=str()
        baseadr=int()
        rng=int()
        for child in addBlk:
            if child.tag == f'{ns}name':
                blkName=child.text
            elif child.tag == f'{ns}baseAddress':
                baseadr=toInt(child.text)
            elif child.tag == f'{ns}Range':
                rng=toInt(child.text)
            else:
                pass
        # print(blkName,baseadr,rng)

        for reg in addBlk.findall(f'{ns}register'):
            name=str()
            ofst=int()
            for child in reg:
                if child.tag == f'{ns}name':
                    name = child.text
                elif child.tag == f'{ns}addressOffset':
                    ofst=toInt(child.text)
            # print(f'{blkName}_{name} = {hex(baseadr+ofst)}')

            #Exract PSTATE to ensure it remains consistent
            block_ps = re.search('.*_p[0-9]+$',blkName)
            reg_ps = re.search('.*_p[0-9]+$',name)
            ps="p0"
            if(block_ps):
                ps=blkName[-2:]
                blkName=blkName[:-3]
            if(reg_ps):
                ps=name[-2:]
                name=name[:-3]
            if(reg_ps==None and block_ps==None):
                dc[f'{blkName}__{name}'] = baseadr+ofst

            #Compatibility code
            d[f'{blkName}__{name}_{ps}'] = baseadr+ofst

    return d,dc


#Main Function Here
if __name__ == '__main__':
    import argparse
    parser = argparse.ArgumentParser(description='IPXact Parser')
    parser.add_argument('--ctrl', help='ctrl[0] == Parse, ctrl[1] == DefinesFile, ctrl[2] == apbmap',default=15,dest='ctrl',action='store',type=int)
    parser.add_argument('--apbmapout', help='apb map output file',default='csr_apb_map_quickboot.sv',dest='mapFile',action='store')
    parser.add_argument('--aarrout', help='apb map output file',default='aarr.sv',dest='aarrFile',action='store')
    parser.add_argument('--definesout', help='defines output file',default='csr_defines_quickboot.sv',dest='defineFile',action='store')
    parser.add_argument('--ipxact', help='ipxact input file',dest='ipxact',action='store',required=True)
    args=parser.parse_args()


    if (args.ctrl & 0x1):
        csrDict,csrDictCompat = parsefile(args.ipxact)
    if (args.ctrl & 0x2):
        createDefinesFile(csrDict,csrDictCompat,args.defineFile)
    if (args.ctrl & 0x4):
        createApbMapFile(csrDict,args.mapFile)
    if (args.ctrl & 0x8):
        createAssocArr(csrDict,args.aarrFile)
