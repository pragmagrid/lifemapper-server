#!/bin/bash

# Purpose: fetch species data 

create_species_data () {
  echo "Fetch species data"
  FILES="gbif_export.tar.gz gbif_orgs.tar.gz gbif_taxonomy.tar.gz marinelist.tar.gz"
  LMURL="http://lifemapper.org/dl"
  for i in $FILES; do
    curl -L "$LMURL/$i" -o ../lmdata-species/$i
  done 
}

### main ###
create_species_data
