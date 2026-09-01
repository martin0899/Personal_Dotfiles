local function write_file(path, content)
  local file = io.open(path, "w")
  if file then
    file:write(content)
    file:close()
  end
end

local function generate_project(name, lang)
  local base_dir = vim.fn.getcwd() .. "/" .. name
  vim.fn.mkdir(base_dir, "p")

  local templates = {
    cpp = function()
      vim.fn.mkdir(base_dir .. "/src", "p")
      vim.fn.mkdir(base_dir .. "/include", "p")
      vim.fn.mkdir(base_dir .. "/lib", "p")
      vim.fn.mkdir(base_dir .. "/tests", "p")
      vim.fn.mkdir(base_dir .. "/build", "p")

      write_file(base_dir .. "/CMakeLists.txt", string.format([[cmake_minimum_required(VERSION 3.14)
project(%s
    VERSION 1.0.0
    LANGUAGES CXX
    DESCRIPTION "Proyecto C++ con CMake"
)

# Estándar C++
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

# Configuración por defecto
if(NOT CMAKE_BUILD_TYPE)
    set(CMAKE_BUILD_TYPE Release)
endif()

# Compilador
set(CMAKE_CXX_FLAGS_RELEASE "-O2")
set(CMAKE_CXX_FLAGS_DEBUG "-g -O0 -Wall -Wextra")

# Output directories
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin)
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib)
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib)

# Incluir directorios
include_directories(${CMAKE_SOURCE_DIR}/include)

# Ejecutable principal
add_executable(${PROJECT_NAME} src/main.cpp)

# Librerías (descomentar cuando las tengas)
# add_subdirectory(lib)

# Tests (descomentar cuando tengas Google Test)
# enable_testing()
# add_subdirectory(tests)
]], name))

      write_file(base_dir .. "/src/main.cpp", string.format([[#include <iostream>
#include "%s.h"

int main() {
    std::cout << "=== %s ===" << std::endl;
    std::cout << "Proyecto creado con exito!" << std::endl;
    std::cout << std::endl;

    // Tu codigo aqui

    return 0;
}
]], name, name))

      write_file(base_dir .. "/include/" .. name .. ".h", string.format([[#ifndef %s_H
#define %s_H

// Headers estandar
#include <string>
#include <vector>

// Tus declaraciones aqui

#endif // %s_H
]], string.upper(name), string.upper(name), string.upper(name)))

      write_file(base_dir .. "/lib/CMakeLists.txt", [[# Librerías del proyecto
# add_library(mylib src/mylib.cpp)
# target_include_directories(mylib PUBLIC include)
]])

      write_file(base_dir .. "/tests/CMakeLists.txt", [[# Tests (requiere Google Test)
# find_package(GTest REQUIRED)
# add_executable(tests test_main.cpp)
# target_link_libraries(tests GTest::gtest_main)
# add_test(NAME tests COMMAND tests)
]])

      write_file(base_dir .. "/tests/test_main.cpp", [[// Tests del proyecto
// Descomentar cuando tengas Google Test configurado

// #include <gtest/gtest.h>
//
// TEST(SampleTest, BasicAssertion) {
//     EXPECT_EQ(1 + 1, 2);
// }
]])

      write_file(base_dir .. "/.gitignore", [[# Build
build/
cmake-build-*/
CMakeFiles/
CMakeCache.txt
cmake_install.cmake
Makefile

# Compiled
*.o
*.obj
*.exe
*.out
*.dll
*.so
*.dylib

# IDE
.vscode/
.idea/
*.swp
*.swo
*~

# OS
.DS_Store
Thumbs.db
]])

      write_file(base_dir .. "/README.md", string.format([[# %s

Proyecto C++ con CMake.

## Requisitos

- CMake 3.14 o superior
- Compilador C++17 (GCC, Clang, o MSVC)

## Build

```bash
mkdir build
cd build
cmake ..
cmake --build .
```

## Ejecutar

```bash
./build/bin/%s
```

## Estructura

```
%s/
├── CMakeLists.txt    # Configuracion principal
├── src/              # Codigo fuente
├── include/          # Headers publicos
├── lib/              # Librerias
├── tests/            # Tests
└── build/            # Compilacion (no versionar)
```
]], name, name, name))
    end,

    csharp = function()
      vim.fn.mkdir(base_dir .. "/src", "p")
      vim.fn.mkdir(base_dir .. "/tests", "p")

      write_file(base_dir .. "/src/" .. name .. ".csproj", string.format([[<Project Sdk="Microsoft.NET.Sdk">

  <PropertyGroup>
    <OutputType>Exe</OutputType>
    <TargetFramework>net8.0</TargetFramework>
    <RootNamespace>%s</RootNamespace>
  </PropertyGroup>

</Project>
]], name))

      write_file(base_dir .. "/src/Program.cs", string.format([[namespace %s;

class Program
{
    static void Main(string[] args)
    {
        Console.WriteLine("Hello from %s!");
    }
}
]], name, name))

      write_file(base_dir .. "/" .. name .. ".sln", string.format([[Microsoft Visual Studio Solution File, Format Version 12.00
# Visual Studio Version 17
VisualStudioVersion = 17.0.31903.59
MinimumVisualStudioVersion = 10.0.40219.1
Project("{FAE04EC0-301F-11D3-BF4B-00C04F79EFBC}") = "%s", "src\\%s.csproj", "{GUID}"
EndProject
]], name, name))
    end,

    java = function()
      local pkg = name:gsub("-", "/")
      vim.fn.mkdir(base_dir .. "/src/main/java/" .. pkg, "p")
      vim.fn.mkdir(base_dir .. "/src/test/java/" .. pkg, "p")

      write_file(base_dir .. "/pom.xml", string.format([[<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
    <modelVersion>4.0.0</modelVersion>

    <groupId>com.example</groupId>
    <artifactId>%s</artifactId>
    <version>1.0-SNAPSHOT</version>
    <packaging>jar</packaging>

    <properties>
        <maven.compiler.source>17</maven.compiler.source>
        <maven.compiler.target>17</maven.compiler.target>
        <project.build.sourceEncoding>UTF-8</project.build.sourceEncoding>
    </properties>
</project>
]], name))

      write_file(base_dir .. "/src/main/java/" .. pkg .. "/App.java", string.format([[package %s;

public class App {
    public static void main(String[] args) {
        System.out.println("Hello from %s!");
    }
}
]], pkg, name))

      write_file(base_dir .. "/src/test/java/" .. pkg .. "/AppTest.java", string.format([[package %s;

import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;

class AppTest {
    @Test
    void testBasic() {
        assertEquals(2, 1 + 1);
    }
}
]], pkg))
    end,

    node = function()
      vim.fn.mkdir(base_dir .. "/src", "p")
      vim.fn.mkdir(base_dir .. "/tests", "p")

      write_file(base_dir .. "/package.json", string.format([[{
  "name": "%s",
  "version": "1.0.0",
  "description": "",
  "main": "src/index.js",
  "scripts": {
    "start": "node src/index.js",
    "test": "jest"
  },
  "keywords": [],
  "author": "",
  "license": "ISC"
}
]], name))

      write_file(base_dir .. "/src/index.js", string.format([[console.log("Hello from %s!");
]], name))

      write_file(base_dir .. "/tests/index.test.js", string.format([[describe("%s", () => {
  it("should work", () => {
    expect(1 + 1).toBe(2);
  });
});
]], name))

      write_file(base_dir .. "/.gitignore", [[node_modules/
.env
dist/
]])
    end,

    python = function()
      vim.fn.mkdir(base_dir .. "/src", "p")
      vim.fn.mkdir(base_dir .. "/tests", "p")

      write_file(base_dir .. "/pyproject.toml", string.format([[build-system = {requires = ["setuptools>=61.0"], build-backend = "setuptools.backends._legacy:_Backend"}

[project]
name = "%s"
version = "0.1.0"
description = ""
requires-python = ">=3.10"
]], name))

      write_file(base_dir .. "/src/__init__.py", "")

      write_file(base_dir .. "/main.py", string.format([[def main():
    print("Hello from %s!")

if __name__ == "__main__":
    main()
]], name))

      write_file(base_dir .. "/tests/__init__.py", "")

      write_file(base_dir .. "/tests/test_main.py", [[from main import main

def test_basic():
    assert 1 + 1 == 2
]])
    end,

    go = function()
      vim.fn.mkdir(base_dir .. "/cmd", "p")
      vim.fn.mkdir(base_dir .. "/internal", "p")
      vim.fn.mkdir(base_dir .. "/pkg", "p")

      write_file(base_dir .. "/go.mod", string.format([[module github.com/user/%s

go 1.21
]], name))

      write_file(base_dir .. "/cmd/main.go", string.format([[package main

import "fmt"

func main() {
	fmt.Println("Hello from %s!")
}
]], name))
    end,

    rust = function()
      vim.fn.mkdir(base_dir .. "/src", "p")

      write_file(base_dir .. "/Cargo.toml", string.format([[package]
name = "%s"
version = "0.1.0"
edition = "2021"

[dependencies]
]], name))

      write_file(base_dir .. "/src/main.rs", string.format([[fn main() {
    println!("Hello from %s!");
}
]], name))

      write_file(base_dir .. "/src/lib.rs", string.format([[pub fn hello() -> &'static str {
    "Hello from %s!"
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_hello() {
        assert_eq!(hello(), "Hello from %s!");
    }
}
]], name, name))
    end,
  }

  if templates[lang] then
    templates[lang]()
    vim.notify("Proyecto '" .. name .. "' creado en " .. base_dir, vim.log.levels.INFO)
    vim.cmd("edit " .. base_dir)
  else
    vim.notify("Lenguaje no soportado: " .. lang, vim.log.levels.ERROR)
  end
end

local function create_project()
  vim.ui.input({ prompt = "Nombre del proyecto: " }, function(name)
    if not name or name == "" then
      return
    end

    local languages = {
      { name = "C++", value = "cpp" },
      { name = "C#", value = "csharp" },
      { name = "Java", value = "java" },
      { name = "Node.js", value = "node" },
      { name = "Python", value = "python" },
      { name = "Go", value = "go" },
      { name = "Rust", value = "rust" },
    }

    local pickers = require("telescope.pickers")
    local finders = require("telescope.finders")
    local conf = require("telescope.config").values
    local actions = require("telescope.actions")
    local action_state = require("telescope.actions.state")

    pickers
      .new({}, {
        prompt_title = "Elegir lenguaje",
        finder = finders.new_table({
          results = languages,
          entry_maker = function(entry)
            return {
              value = entry.value,
              display = entry.name,
              ordinal = entry.name,
            }
          end,
        }),
        sorter = conf.generic_sorter({}),
        attach_mappings = function(prompt_bufnr)
          actions.select_default:replace(function()
            actions.close(prompt_bufnr)
            local selection = action_state.get_selected_entry()
            if selection then
              generate_project(name, selection.value)
            end
          end)
          return true
        end,
      })
      :find()
  end)
end

return {
  create_project = create_project,
}
