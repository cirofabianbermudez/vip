#!/bin/bash

echo -e "\n[INFO]: Checking dependencies"
DEPENDENCIES=("tar" "wget" "python3")
for item in "${DEPENDENCIES[@]}"; do
  if command -v $item &> /dev/null; then
    printf "  > %8s is INSTALLED\n" "$item"
  else 
    printf "  > %8s is NOT INSTALLED\n" "$item"
    exit 1
  fi
done
echo -e "[INFO]: All dependencies found\n"

if [ -n "$VIRTUAL_ENV" ]; then
    echo "> You are running inside a virtual environment!"
    echo "> Run 'deactivate' and retry"
    exit 1
fi

echo "[INFO]: Checking Python Version"
PYTHON_VERSION=$(python3 --version 2>&1 | awk '{print $2}')
CUR_VERSION=$(echo $PYTHON_VERSION | awk -F. '{print $1"."$2}' )
MIN_VERSION="3.5"
COMPARE=$(echo $PYTHON_VERSION $MIN_VERSION | awk '{ print ( $1 >= $2) }')
printf "  > Detected Python Version: Python %s\n" "$PYTHON_VERSION"
printf "  > Requirement: >= %s\n" "$MIN_VERSION"
if [ "$COMPARE" -eq 1 ]; then
  echo -e "[INFO]: Python Version requirement met"
else
  echo -e "[ERROR] Python Version requirement NOT met"
  exit 1
fi

#echo -e "\n[INFO]: Creating Virtual Environment"
#rm -rf $UTILS_DIR/venv
#/usr/bin/python3 -m venv $UTILS_DIR/venv
#source $UTILS_DIR/venv/bin/activate
#set +e
#pip install --upgrade pip
#set -e
#pip install -r .python_requirements

if [ `uname -p` = "x86_64" ]; then
  echo -e "\n[INFO]: Installing Verible"
  rm -rf $UTILS_DIR/verible
  mkdir -p $UTILS_DIR/verible
  cd $UTILS_DIR/verible
  VERIBLE_VER=v0.0-3716-g914652db
  #wget -q https://github.com/chipsalliance/verible/releases/download/${VERIBLE_VER}/verible-${VERIBLE_VER}-linux-static-x86_64.tar.gz
  #tar -xzf verible*.tar.gz
  #rm -rf verible*.tar.gz
  echo "export PATH=$UTILS_DIR/verible/verible-${VERIBLE_VER}/bin:\$PATH" >> $UTILS_DIR/venv/bin/activate
  echo "setenv PATH $UTILS_DIR/verible/verible-${VERIBLE_VER}/bin:\$PATH" >> $UTILS_DIR/venv/bin/activate.csh
  echo -e "\n[INFO]: Creating format flow"
  rm -rf $UTILS_DIR/format
  mkdir -p $UTILS_DIR/format
  cd $UTILS_DIR/format

  SV_FILES=($(find ../../sv ../../vip_vrf -type f -name "*.sv"))
  NUM_ELEM=${#SV_FILES[@]}

  echo -e "ROOT_DIR = \$(realpath \$(CURDIR)/../../)\n" >> Makefile
  echo -e "SRCS = \\" >> Makefile

  if [ $NUM_ELEM -gt 0 ]; then
    for ((i = 0; i < ${NUM_ELEM}; i++)) do
      temp=$(echo "${SV_FILES[i]}" | sed 's/\.\.\/\.\./$(ROOT_DIR)/g')
      if [ $i -eq $(($NUM_ELEM -1)) ]; then
        printf "\t%s\n" "$temp" >> Makefile
      else
        printf "\t%s\\" "$temp" >> Makefile
        printf "\n" >> Makefile
      fi
    done
  else
    echo "[WARNING]: No .sv file found"
  fi
  echo -e "\n.PHONY: format preview lint clean\n\nall: format\n\nformat:\n\tverible-verilog-format --inplace \$(SRCS)" >> Makefile
  echo -e "\npreview:\n\trm -rf preview\n\tmkdir -p preview\n\t\$(foreach file, \$(SRCS), verible-verilog-format \$(file) > preview/format_\$(notdir \$(file)); )" >> Makefile
  echo -e "\nlint:\n\tverible-verilog-lint \$(SRCS) || true" >> Makefile
  echo -e "\nclean:\n\trm -rf" preview>> Makefile
  echo -e "" >> Makefile
else
  echo "[WARNING]: Skiping Verible installation"
fi


