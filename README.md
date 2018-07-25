
<p align="center">
  <h1 align="center">
    faustgen~
  </h1>
  <p align="center">
    The FAUST compiler embedded in a Pd external
  </p>
  <p align="center">
    <a href="https://travis-ci.org/pierreguillot/faust-pd"><img src="https://img.shields.io/travis/pierreguillot/faust-pd.svg?label=travis" alt="Travis CI"></a>
    <a href="https://ci.appveyor.com/project/pierreguillot/faust-pd/history"><img src="https://img.shields.io/appveyor/ci/pierreguillot/faust-pd.svg?label=appveyor" alt="Appveyor CI"></a>
    <a href="https://www.codacy.com/app/pierreguillot/faust-pd?utm_source=github.com&amp;utm_medium=referral&amp;utm_content=pierreguillot/faust-pd&amp;utm_campaign=Badge_Grade"><img src="https://api.codacy.com/project/badge/Grade/07a9a6ada751467e8d5e72d8876551ad"/></a>
  </p>
</p>

## Presentation

The **faustgen~** object is an external with the [FAUST](http://faust.grame.fr/about/) just-in-time (JIT) compiler embedded that allows to load, compile and play FAUST files within the audio programming environment [Pure Data](http://msp.ucsd.edu/software.html). FAUST (Functional Audio Stream) is a functional programming language specifically designed for real-time signal processing and synthesis developed by the [GRAME](http://www.grame.fr/). The FAUST JIT compiler - built with [LLVM](https://llvm.org/) - brings together the convenience of a standalone interpreted language with the efficiency of a compiled language. The **faust~** object is a very first version with elementary features, any help and any contribution are welcome.

**Dependencies:**

- [LLVM](http://llvm.org)
- [FAUST](https://github.com/grame-cncm/faust.git)
- [Pure Data](https://github.com/pure-data/pure-data.git)
- [CMake](https://cmake.org/)
- [pd.build](https://github.com/pierreguillot/pd.build.git)

## Compilation

The FAUST compiler requires LLVM 5.0.0 backend (or higher - 6.0.0). Once LLVM is installed on your machine, you can use CMake to generate a project that will compile both the FAUST library and the Pure Data external. Then you can use Deken to release the external.

#### Installing LLVM

The fastest solution to install LLVM is to download the precompiled binaries from the [LLVM website](http://releases.llvm.org). For example, on the Travis CI for MacOS, we assume for example that the binaries are installed in the llvm folder at the root of the project:

```
curl -o ./llvm.tar.gz http://releases.llvm.org/5.0.0/clang+llvm-5.0.0-x86_64-apple-darwin.tar.xz
tar zxvf ./llvm.tar.gz && mv clang+llvm-5.0.0-x86_64-apple-darwin llvm
```
or a for a linux system
```
curl -o ./llvm.tar.gz http://releases.llvm.org/5.0.0/clang+llvm-5.0.0-linux-x86_64-ubuntu14.04.tar.xz
tar xvf ./llvm.tar.gz && mv clang+llvm-5.0.0-linux-x86_64-ubuntu14.04 llvm
```
You can also use HomeBrew or MacPorts on MacOS or APT on Linux the compilation of the sources last around 50 minutes and in this case, you change the LLVM_DIR with the proper location.

On Windows, you must compile from sources using the static runtime library. Compiling LLVM with the Microsoft Visual Compiler requires to use the static runtime library, for example:
```
cd llvm-6.0.0.src && mkdir build && cd build
cmake .. -G "Visual Studio 14 2015 Win64" -DLLVM_USE_CRT_DEBUG=MTd -DLLVM_USE_CRT_RELEASE=MT -DLLVM_BUILD_TESTS=Off -DCMAKE_INSTALL_PREFIX="./llvm" -Thost=x64
cmake --build . --target ALL_BUILD (--config Debug/Release)
cmake --build . --target INSTALL (optional)
```
You can also use the pre-compiled libraries used on the Appveyor CI.

#### Compiling the FAUST library and the Pd external

```
git submodule update --init --recursive
mkdir build && cd build
cmake ..
cmake --build .
```
Useful CMake options:
- `USE_LLVM_CONFIG` to disable default LLVM location for FAUST (for example: `-DUSE_LLVM_CONFIG=off`).
- `LLVM_DIR` to define LLVM location for FAUST and the Pd external (for example: `-DLLVM_DIR=./llvm/lib/cmake/llvm`).

see also the files `.travis.yml` and `appveyor.yml`.

#### Publishing with Deken

Once the binaries are compiled or uploaded with Travis and Appveyor to the releases section of GitHub, the external can be published using [Deken](https://github.com/pure-data/deken). First of all, you must have an account on the website https://puredata.info and the [Deken plugin for developers](https://github.com/pure-data/deken/blob/master/developer/README.md) installed. On Windows run the script FaustDeken.bat with the version of the external, for example: `FaustDeken 0.0.1`. On Unix systems, run the script FaustDeken.sh with the version of the external, for example: `FaustDeken.sh 0.0.1`.

## Credits

**FAUST institution**: GRAME  
**FAUST website**: faust.grame.fr  
**FAUST developers**: Yann Orlarey, Stéphane Letz, Dominique Fober and others  

**faustgen~ institutions**: CICM - ANR MUSICOLL  
**faustgen~ website**: github.com/grame-cncm/faust-pd  
**faustgen~ developer**: Pierre Guillot

## Legacy

This **faustgen~** object for Pd is inspired by the **faustgen~** object for Max developed by Martin Di Rollo and Stéphane Letz.

Another **faust~** object has been developed by Albert Graef using the programming language [Pure](https://github.com/agraef/pure-lang).
