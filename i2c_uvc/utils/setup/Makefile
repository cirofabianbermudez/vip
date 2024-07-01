
ROOT_DIR = $(CURDIR)
export UTILS_DIR = $(abspath $(ROOT_DIR)/../)

.PHONY: create_venv message

all: create_venv message

create_venv:
	./create_venv.sh

message:
	@echo -e ""
	@echo -e "==============================================================================="
	@echo -e "To activate environment run:"
	@echo -e " bash: source $(UTILS_DIR)/venv/bin/activate"
	@echo -e "  csh: source $(UTILS_DIR)/venv/bin/activate.csh"
	@echo -e "==============================================================================="
	@echo -e ""
