"""
Basecall ONT runs from FAST5.

Adopted from https://github.com/paudano/ont_basecall
"""

### Libraries ###

import datetime
import numpy as np
import os, sys
import pandas as pd
import shutil
import time
import getpass
import glob

### Get install directory ###


INSTALL_DIR = os.path.dirname(workflow.snakefile)


configfile: "config/config.json"


### Setup cell table ###

CELL_DF = pd.read_csv("config/manifest.tab", sep="\t", index_col=["SAMPLE","SEQ_TYPE","CHEMISTRY","RUN_ID"])


### Includes ###

shell.prefix("source ~/.bash_profile; ")

wildcard_constraints:
    sample="|".join(CELL_DF.index.get_level_values("SAMPLE")),
    seq_type="|".join(CELL_DF.index.get_level_values("SEQ_TYPE")),
    run_id="|".join(CELL_DF.index.get_level_values("RUN_ID")),
    profile="|".join(list(config["profile"].keys())),
    modbase="|".join(list(config["mod_base_profile"].keys())),
    version_dash="|".join(["0-8-2"])

include: "rules/basecall.snake"


localrules:
    basecall_all,


rule basecall_all:
    input:
        _gather_dorado_files,
