################################################################################
# Copyright 2012-2017 Esri
#
#  Licensed under the Apache License, Version 2.0 (the "License");
#  you may not use this file except in compliance with the License.
#  You may obtain a copy of the License at
#
#  http://www.apache.org/licenses/LICENSE-2.0
#
#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.
################################################################################

TARGET = $$qtLibraryTarget(ArcGISRuntimeToolkitCppApi)
TEMPLATE = lib

QT += core gui opengl network positioning sensors qml quick
CONFIG += c++11 plugin

DEFINES += QTRUNTIME_TOOLKIT_BUILD

HEADERS += $$PWD/include/*.h
SOURCES += $$PWD/source/*.cpp

INCLUDEPATH +=  $$PWD/include/

RUNTIME_PRI = arcgis_runtime_qml_cpp.pri
#RUNTIME_PRI = esri_runtime_qt.pri # use this for widgets

ARCGIS_RUNTIME_VERSION = 100.2
include($$PWD/arcgisruntime.pri)

ios {
  RESOURCES += $${PWD}/ArcGISRuntimeToolkit.qrc
  # the following file is needed to generate universal iOS libs
  # prior to Qt 5.8
  equals(QT_MAJOR_VERSION, 5):lessThan(QT_MINOR_VERSION, 8) {
    CONFIG += bitcode device iphoneos simulator iphonesimulator
    include ($$PWD/ios_config.prf)
  }
}

macx: {
  QMAKE_MACOSX_DEPLOYMENT_TARGET = 10.11
  QMAKE_POST_LINK =
}

CONFIG(release) {
  BUILDTYPE = release
}
else {
  BUILDTYPE = debug
}

equals(ANDROID_ARCH, "") {
  PLATFORM_OUTPUT = $$PLATFORM
} else {
  PLATFORM_OUTPUT = $$PLATFORM/$$ANDROID_ARCH
}

DESTDIR = $$PWD/output/$$PLATFORM_OUTPUT
OBJECTS_DIR = $$DESTDIR/$$BUILDTYPE/obj
MOC_DIR = $$DESTDIR/$$BUILDTYPE/moc
RCC_DIR = $$DESTDIR/$$BUILDTYPE/qrc