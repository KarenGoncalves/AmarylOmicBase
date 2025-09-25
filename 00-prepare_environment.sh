#!/bin/sh

### Install softwares below
# python/3.11 perl/5.30.2 java 
# tmhmm/2.0c bowtie2/2.4.1 trinity/2.14.0 transdecoder/5.5.0 
# blast+/2.13.0 infernal/1.1.4 trinotate/4.0.0
# augustus/3.5.0 hmmer/3.3.2
# metaeuk/6 prodigal/2.6.3 r/4.3.1 


echo "anyio==3.7.1
arff==0.9
argon2_cffi==23.1.0
argon2_cffi_bindings==21.2.0
asttokens==2.2.1
async_generator==1.10
attrs==23.1.0
backcall==0.2.0
backports-abc==0.5
backports.shutil_get_terminal_size==1.0.0
bcrypt==4.0.1
beautifulsoup4==4.12.2
biopython==1.84
bitarray==2.8.1
bitstring==4.1.1
bleach==6.0.0
busco==5.7.0
certifi==2023.7.22
cffi==1.15.1
chardet==5.2.0
charset_normalizer==3.2.0
comm==0.1.4
contourpy==1.1.0
cryptography==39.0.1
cycler==0.11.0
Cython==0.29.36
deap==1.4.1
debugpy==1.6.7.post1
decorator==5.1.1
defusedxml==0.7.1
dnspython==2.4.2
ecdsa==0.18.0
entrypoints==0.4
exceptiongroup==1.1.3
executing==1.2.0
fastjsonschema==2.18.0
fonttools==4.42.1
funcsigs==1.0.2
idna==3.4
importlib_metadata==6.8.0
importlib_resources==6.0.1
ipykernel==6.25.1
ipython==8.15.0
ipython_genutils==0.2.0
jedi==0.19.0
Jinja2==3.1.2
jsonschema==4.19.0
jsonschema_specifications==2023.7.1
jupyter_client==8.3.1
jupyter_core==5.3.1
kiwisolver==1.4.5
lockfile==0.12.2
MarkupSafe==2.1.3
matplotlib==3.7.2
matplotlib_inline==0.1.6
mistune==3.0.1
mock==5.1.0
mpmath==1.3.0
nest_asyncio==1.5.7
netaddr==0.8.0
netifaces==0.11.0
nose==1.3.7
numpy==1.25.2
packaging==23.1
pandas==2.1.0
pandocfilters==1.5.0
paramiko==3.3.1
parso==0.8.3
path==16.7.1
path.py==12.5.0
pathlib2==2.3.7.post1
paycheck==1.0.2
pbr==5.11.1
pexpect==4.8.0
pickleshare==0.7.5
Pillow==10.0.0
pkgutil_resolve_name==1.3.10
platformdirs==2.6.2
prometheus_client==0.17.1
prompt_toolkit==3.0.39
psutil==5.7.0
ptyprocess==0.7.0
pure_eval==0.2.2
pycparser==2.21
Pygments==2.16.1
PyNaCl==1.5.0
pyparsing==3.0.9
pyrsistent==0.19.3
python-dateutil==2.8.2
python_json_logger==2.0.7
pytz==2023.3
PyYAML==6.0.1
pyzmq==25.1.1
referencing==0.30.2
requests==2.31.0
rfc3339_validator==0.1.4
rfc3986_validator==0.1.1
rpds_py==0.10.0
scipy==1.11.2
Send2Trash==1.8.2
simplegeneric==0.8.1
singledispatch==4.1.0
six==1.16.0
sniffio==1.3.0
soupsieve==2.4.1
stack_data==0.6.2
sympy==1.12
terminado==0.17.1
testpath==0.6.0
tinycss2==1.2.1
tornado==6.3.3
traitlets==5.9.0
typing_extensions==4.7.1
tzdata==2023.3
urllib3==2.0.4
wcwidth==0.2.6
webencodings==0.5.1
websocket_client==1.6.2
XlsxWriter==1.4.3
zipp==3.16.2" > requirements.txt


####### Install requiremets above and  prepare setup for BUSCO ########
virtualenv ~/trinotateAnnotation
source ~/trinotateAnnotation/bin/activate
pip install --upgrade pip
pip install -r requirements.txt


##mkdir -p ~/busco_downloads/lineages
#(cd ~/busco_downloads/lineages
#wget https://busco-data.ezlab.org/v5/data/lineages/liliopsida_odb10.2024-01-08.tar.gz
#tar -xvf liliopsida_odb10.2024-01-08.tar.gz)

#DATA_DIR=~/trinotate_data
#
#export EGGNOG_DATA_DIR=${DATA_DIR}
#
#cd $SCRATCH/${SPECIES}
#
#Trinotate --db ${DATA_DIR}/Trinotate.sqlite\
# --create\
# --trinotate_data_dir ${DATA_DIR}
deactivate


##### Clean setup and prepare new environment for eggnog #######
# eggnog_emapper version used is not available for python/3.11, so here I installed python/3.8 in another virtual environment
virtualenv ~/eggnog
source ~/eggnog/bin/activate

pip install --upgrade pip
pip install eggnog_mapper==2.1.6

