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

echo -e "\n[INFO]: Creating Virtual Environment"
rm -rf $UTILS_DIR/venv
/usr/bin/python3 -m venv $UTILS_DIR/venv
source $UTILS_DIR/venv/bin/activate
set +e
pip install --upgrade pip
set -e
pip install -r .python_requirements

if [ `uname -p` = "x86_64" ]; then
  echo -e "\n[INFO]: Installing Verible"
  rm -rf $UTILS_DIR/verible
  mkdir -p $UTILS_DIR/verible
  cd $UTILS_DIR/verible
  VERIBLE_VER=v0.0-3716-g914652db
  wget -q https://github.com/chipsalliance/verible/releases/download/${VERIBLE_VER}/verible-${VERIBLE_VER}-linux-static-x86_64.tar.gz
  tar -xzf verible*.tar.gz
  rm -rf verible*.tar.gz
  echo "export PATH=$UTILS_DIR/verible/verible-${VERIBLE_VER}/bin:\$PATH" >> $UTILS_DIR/venv/bin/activate
  echo "setenv PATH $UTILS_DIR/verible/verible-${VERIBLE_VER}/bin:\$PATH" >> $UTILS_DIR/venv/bin/activate.csh
  echo -e "\n[INFO]: Creating Verible Makefile"
  rm -rf $UTILS_DIR/format
  mkdir -p $UTILS_DIR/format
  cd $UTILS_DIR/format

  SV_FILES=($(find ../../sv ../../vip_vrf -type f -name "*.sv"))
  NUM_ELEM=${#SV_FILES[@]}

  {
    echo "ROOT_DIR = \$(realpath \$(CURDIR)/../../)"
    echo ""
    echo "SRCS = \\"

    for ((i = 0; i < ${NUM_ELEM}; i++)) do
      temp=$(echo "${SV_FILES[i]}" | sed 's/\.\.\/\.\./$(ROOT_DIR)/g')
      if [ $i -eq $(($NUM_ELEM -1)) ]; then
        printf "\t%s\n" "$temp"
      else
        printf "\t%s\\" "$temp"
        printf "\n"
      fi
    done

    echo ""
    echo ".PHONY: format preview lint clean"
    echo ""
    echo "all: lint"
    echo ""
    echo "format:"
    echo -e "\tverible-verilog-format --inplace \$(SRCS)"
    echo ""
    echo "preview:"
    echo -e "\trm -rf preview"
    echo -e "\tmkdir -p preview"
    echo -e "\t\$(foreach file, \$(SRCS), verible-verilog-format \$(file) > preview/format_\$(notdir \$(file)); )"
    echo ""
    echo "lint:"
    echo -e "\tverible-verilog-lint \$(SRCS) || true"
    echo ""
    echo "clean:"
    echo -e "\trm -rf preview"
    echo ""
  } > Makefile

  if [ $NUM_ELEM -eq 0 ]; then
    echo "[WARNING]: No .sv file found"
  fi

  {
    echo "--inplace"
    echo "--line_break_penalty=8"
    echo "--column_limit=200"
    echo "--over_column_limit_penalty=100"
  } > .rules.verible_format

  {
    echo  "-explicit-parameter-storage-type"
    echo  "-forbidden-macro"
    echo  "+line-length=length:250"
    echo  "+macro-string-concatenation"
    echo  "+mismatched-labels"
    echo  "+one-module-per-file"
    echo  "+parameter-name-style=parameter_style:ALL_CAPS"
    echo  "+parameter-name-style=localparam_style:ALL_CAPS"
    echo  "+port-name-suffix"
    echo  "+proper-parameter-declaration"
    echo  "+signal-name-style"
    echo  "+suspicious-semicolon"
    echo  "+uvm-macro-semicolon"
  } > .rules.verible_lint

else
  echo "[WARNING]: Skiping Verible installation"
fi


