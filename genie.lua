BGFX_DIR = path.getabsolute("bgfx/")
BX_DIR = path.getabsolute("bx/")
BIMG_DIR = path.getabsolute("bimg/")

local PROJ_DIR = path.getabsolute(".")
local BGFX_SCRIPTS_DIR = path.join(BGFX_DIR, "scripts/")
local BX_SCRIPTS_DIR = path.join(BX_DIR, "scripts/")
local BIMG_SCRIPTS_DIR = path.join(BIMG_DIR, "scripts/")

newoption
{
    trigger = "with-tools",
    description = "Enable building tools.",
}

function copyLib()
end

solution "ProceduralSky"
	defines
	{
		"ENTRY_CONFIG_IMPLEMENT_MAIN=1",
		"BX_CONFIG_ENABLE_MSVC_LEVEL4_WARNINGS=1",
		"ENTRY_DEFAULT_WIDTH=1920",
		"ENTRY_DEFAULT_HEIGHT=1027",
		"BGFX_CONFIG_RENDERER_OPENGL=21",
	}

	configuration { "vs* or mingw-*" }
		defines
		{
			"BGFX_CONFIG_RENDERER_DIRECT3D9=1",
			"BGFX_CONFIG_RENDERER_DIRECT3D11=1",
		}

	configurations {
		"Debug",
		"Release",
	}

	if _ACTION == "xcode4" then
		platforms {
			"Universal",
		}
	else
		platforms {
			"x32",
			"x64",
			"Native", -- for targets where bitness is not specified
		}
	end
	
	language "C++"
	
	location ("projects/" .. _ACTION)
	
	startproject "ProceduralSky"
	
	flags { "StaticRuntime",  "FloatFast"}	
	
	configuration {"Debug"}	
		flags { "Symbols" }
	configuration {"Release"}
		flags { "Optimize" }	

	configuration {}	
		
	dofile (path.join(BX_SCRIPTS_DIR, "toolchain.lua"))
	
	toolchain()
	
	dofile (path.join(BGFX_SCRIPTS_DIR, "bgfx.lua"))
	dofile (path.join(BX_SCRIPTS_DIR, "bx.lua"))
	dofile (path.join(BIMG_SCRIPTS_DIR, "bimg.lua"))
	dofile (path.join(BIMG_SCRIPTS_DIR, "bimg_decode.lua"))
	dofile (path.join(BIMG_SCRIPTS_DIR, "bimg_encode.lua"))
	dofile (path.join(BGFX_SCRIPTS_DIR, "example-common.lua"))

	bgfxProject("", "StaticLib", {})	

project "ProceduralSky"	
	kind "ConsoleApp"	
	language "C++"	
	files { 
		path.join(PROJ_DIR, "sources/*.h"),
		path.join(PROJ_DIR, "sources/*.cpp")
	}	

	includedirs {	
		path.join(BGFX_DIR, "3rdparty"),
		path.join(BGFX_DIR, "include"),	
		path.join(BGFX_DIR, "examples/common"),
		path.join(BX_DIR, "include"),
		path.join(BIMG_DIR, "include")
	}	
  	
	links { "bgfx", "bx", "bimg", "bimg_decode", "example-common", "example-glue" }
  	
	configuration { "vs20*", "x32 or x64" }
		links {
			"gdi32",
			"psapi",
		}

	configuration { "linux-* or freebsd" }
		links {
			"X11",
			"GL",
			"pthread",
		}
	
	configuration { "asmjs" }
		kind "ConsoleApp"
		targetextension ".bc"

	configuration {"Debug"}	
		debugdir "."	
		debugargs { "" }	
		defines { "DEBUG",  "_LIB" }	
		flags { "Symbols"}	

	configuration {"Release"}	
		defines { "NDEBUG",  "_LIB" }	
		flags { "Optimize" }
	

if _OPTIONS["with-tools"] then
    dofile (path.join(BGFX_SCRIPTS_DIR, "shaderc.lua"))
    dofile (path.join(BGFX_SCRIPTS_DIR, "texturec.lua"))
    dofile (path.join(BGFX_SCRIPTS_DIR, "geometryc.lua"))
end
