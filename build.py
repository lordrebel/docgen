#!/usr/bin/env python3
import os
import argparse
import glob
tool_path=os.path.dirname(os.path.abspath(__file__))
pandoc_path=os.path.join(tool_path, 'tools','pandoc','bin','pandoc')
pandoc_filter_path=os.path.join(tool_path,"filters","common.lua")
plantuml_path=os.path.join(tool_path,"tools","plantuml.jar")
def get_args():
    parser = argparse.ArgumentParser(description='Create a new directory and copy files from a source directory to the new directory.')
    parser.add_argument('-s',"--source",default="./",help='The source directory containing md files')
    parser.add_argument('-u', "--umls",default="umls",help='The umls folder')
    parser.add_argument('-t', "--type",default="docx", help='The output filetype support docx,html')
    return parser.parse_args()
def genUmls(args):
    cmd_template="java -jar {platuml_path} -tpng {tgt_folder}/*.puml"
    cur_path=os.getcwd()
    uml_folder_path=os.path.join(cur_path,args.umls)
    if(os.path.isdir(uml_folder_path)):
        cmd=cmd_template.format(platuml_path=plantuml_path,tgt_folder=uml_folder_path)
        print("running:",cmd)
        os.system(cmd)
def genDocs(args,md_file:str):
    cmd_template="chmod +x {pandoc_path} && {pandoc_path} {source_file} -o {output_file} --lua-filter={filter} --toc --toc-depth=3"
    output_file=md_file.rsplit(".md",1)[0]+"."+args.type
    cmd=cmd_template.format(pandoc_path=pandoc_path,source_file=md_file,output_file=output_file,filter=pandoc_filter_path)
    print("running:",cmd)
    os.system(cmd)

def main():
    args=get_args()
    genUmls(args)
    markdonwn_files=glob.glob(os.path.join(args.source,"*.md"))
    for file in markdonwn_files:
        print("generating:",file)
        genDocs(args,file)

if __name__ == "__main__":
    main()


