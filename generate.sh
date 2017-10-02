#!/bin/bash
if [[ "$OSTYPE" == "linux-gnu" ]]; then
	bx/tools/bin/linux/genie "$@"
elif [[ "$OSTYPE" == "darwin"* ]]; then
	bx/tools/bin/darwin/genie "$@"
elif [[ "$OSTYPE" == "msys" ]] || [[ "$OSTYPE" == "win32" ]]; then
	bx/tools/bin/windows/genie.exe "$@"
fi
