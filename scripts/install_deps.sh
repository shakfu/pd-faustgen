
CWD=`pwd`
THIRDPARTY=${CWD}/build/thirdparty
PREFIX=${THIRDPARTY}/install
FAUST_VERSION=2.69.3
# FAUST_VERSION=2.72.14
MACOSX_DEPLOYMENT_TARGET=10.15

function setup() {
	mkdir -p ${PREFIX}/include && \
	mkdir -p ${PREFIX}/lib
}

function install_faust() {
	VERSION=${FAUST_VERSION}
	SRC=${THIRDPARTY}/faust
    if [ ! -d ${THIRDPARTY}/faust/architecture ]; then
    	rm -rf ${THIRDPARTY}/faust && \
		git clone -b "${VERSION}" --depth=1 https://github.com/grame-cncm/faust.git ${THIRDPARTY}/faust
	fi
}

# function install_pd() {
# 	VERSION="0.54-1"
# 	SRC=${THIRDPARTY}/pure-data
#     if [ ! -d ${THIRDPARTY}/pure-data/src ]; then
#     	rm -rf ${THIRDPARTY}/pure-data && \
# 		git clone -b "${VERSION}" --depth=1 https://github.com/pure-data/pure-data.git ${THIRDPARTY}/pure-data
# 	fi
# }

function install_libfaust() {
	VERSION=${FAUST_VERSION}
	if [ "$(uname)" = "Darwin" ]; then
	    if [ ! -f ${THIRDPARTY}/libfaust/lib/libfaustwithllvm.a ]; then
	    	rm -rf ${THIRDPARTY}/libfaust
			if [ "$(uname -m)" = "arm64" ]; then
				if [ ! -f Faust-$VERSION-arm64.dmg ]; then
					curl -L https://github.com/grame-cncm/faust/releases/download/$VERSION/Faust-$VERSION-arm64.dmg -o Faust-$VERSION-arm64.dmg
					hdiutil attach Faust-$VERSION-arm64.dmg
					mkdir -p ${THIRDPARTY}/libfaust
					cp -Rf /Volumes/Faust-$VERSION/Faust-$VERSION/* ${THIRDPARTY}/libfaust/
					hdiutil detach /Volumes/Faust-$VERSION/
					rm -f Faust-$VERSION-arm64.dmg
				fi					
			else
				if [ ! -f Faust-$VERSION-x64.dmg ]; then
					curl -L https://github.com/grame-cncm/faust/releases/download/$VERSION/Faust-$VERSION-x64.dmg -o Faust-$VERSION-x64.dmg
					hdiutil attach Faust-$VERSION-x64.dmg
					mkdir -p ${THIRDPARTY}/libfaustd
					cp -Rf /Volumes/Faust-$VERSION/Faust-$VERSION/* ${THIRDPARTY}/libfaust/
					hdiutil detach /Volumes/Faust-$VERSION/
					rm -f Faust-$VERSION-x64.dmg
				fi
			fi
		fi
	fi
}


function install_libsndfile() {
	SRC=${THIRDPARTY}/libsndfile
	BUILD=${THIRDPARTY}/libsndfile/build
	if [ ! -f ${THIRDPARTY}/install/lib/libsndfile.a ]; then
		rm -rf ${THIRDPARTY}/libsndfile && \
		mkdir -p build/thirdparty && \
		git clone --depth=1 https://github.com/libsndfile/libsndfile.git ${THIRDPARTY}/libsndfile && \
		mkdir -p ${BUILD} && \
		cd ${BUILD} && \
		cmake .. \
			-DCMAKE_VERBOSE_MAKEFILE=ON \
			-DCMAKE_C_FLAGS="-fPIC" \
			-DCMAKE_CXX_FLAGS="-fPIC" \
			-DBUILD_TESTING=OFF \
			-DENABLE_EXTERNAL_LIBS=OFF \
			-DENABLE_MPEG=OFF \
			-DBUILD_PROGRAMS=OFF \
			-DBUILD_EXAMPLES=OFF \
			-DENABLE_CPACK=OFF \
			-DCMAKE_INSTALL_PREFIX=${PREFIX} && \
		cmake --build . --config Release && \
		cmake --build . --target install
	fi
}


setup
install_faust
install_libfaust
install_libsndfile
# install_pd

