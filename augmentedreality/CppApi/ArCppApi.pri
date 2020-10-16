###############################################################################
# Copyright 2012-2019 Esri
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
###############################################################################

# This file is a part of the AR features provides in the toolkit.
# This file must be imported in the project to use the C++ API of the
# ArcGIS Runtime SDK for Qt. See AR.md for details.

isEmpty(ARCGIS_TOOLKIT_PATH) {
    error(ARCGIS_TOOLKIT_PATH is not set)
}

AUGMENTED_REALITY_PATH = $$ARCGIS_TOOLKIT_PATH/augmentedreality

include($$AUGMENTED_REALITY_PATH/Common/AR.pri)

HEADERS += \
    $$AUGMENTED_REALITY_PATH/CppApi/include/ArcGISArView.h

SOURCES += \
    $$AUGMENTED_REALITY_PATH/CppApi/source/ArcGISArView.cpp

INCLUDEPATH += $$AUGMENTED_REALITY_PATH/Common/include \
               $$AUGMENTED_REALITY_PATH/CppApi/include
DEPENDPATH += $$AUGMENTED_REALITY_PATH/CppApi/include

# only arm64-v8a supported for Android
ANDROID_ABIS = arm64-v8a
