#!/bin/bash
if [[ "$OSTYPE" == "linux-gnu" ]]; then
	PATH=$PATH:$(pwd)/bx/tools/bin/linux/
	PATH=$PATH:$(pwd)/bgfx/tools/bin/linux/
elif [[ "$OSTYPE" == "darwin"* ]]; then
	PATH=$PATH:$(pwd)/bx/tools/bin/darwin/
	PATH=$PATH:$(pwd)/bgfx/tools/bin/darwin/
elif [[ "$OSTYPE" == "msys" ]] || [[ "$OSTYPE" == "win32" ]]; then
	PATH=$PATH:$(pwd)/bx/tools/bin/windows/
	PATH=$PATH:$(pwd)/bgfx/tools/bin/windows/
fi

ninja
