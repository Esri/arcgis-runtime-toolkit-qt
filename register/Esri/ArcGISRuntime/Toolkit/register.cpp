/*******************************************************************************
 *  Copyright 2012-2020 Esri
 *
 *  Licensed under the Apache License, Version 2.0 (the "License");
 *  you may not use this file except in compliance with the License.
 *  You may obtain a copy of the License at
 *
 *  http://www.apache.org/licenses/LICENSE-2.0
 *
 *  Unless required by applicable law or agreed to in writing, software
 *  distributed under the License is distributed on an "AS IS" BASIS,
 *  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *  See the License for the specific language governing permissions and
 *  limitations under the License.
 ******************************************************************************/
#include "register.h"

// Toolkit includes
#include "AuthenticationController.h"
#include "CoordinateConversionController.h"
#include "CoordinateConversionOption.h"
#include "CoordinateConversionResult.h"
#include "NorthArrowController.h"
#include "PopupViewController.h"

// ArcGIS includes
#include <Point.h>

// Qt Includes
#include <QQmlEngine>
#include <QQmlFileSelector>

// std includes
#include <type_traits>

namespace Esri
{
namespace ArcGISRuntime
{
namespace Toolkit
{

/*!
  \headerfile Esri/ArcGISRuntime/Toolkit/register
  
  This file contains the registration function required to register the C++
  controllers provided by the Toolkit with your application.
  
   If you intend to utilize the toolkit with [Map|Scene]QuickView in your
  application, invoking registerComponents is required! Please refer to
  \c README.md for more information on workflows.
*/

constexpr char const* NAMESPACE = "Esri.ArcGISRuntime.Toolkit.CppInternal";

constexpr int VERSION_MAJOR = 1;

constexpr int VERSION_MINOR = 0;

namespace
{
/*
 \internal
 \brief Function for registration. Registers the C++ type Foo as
 FooCPP in QML with the appropriate version and namespace information.
 
 \note In QML, we alias the QML type \c FooCPP to QML type \c Foo using the
 qml files found in the `+cpp_api` folder of our QML directory.
 
 \list
  \li \c T Type to register in QML.
 \endlist
 */
template <typename T>
void registerComponent()
{
  static_assert(std::is_base_of<QObject, T>::value, "Must inherit QObject");
  auto name = QString("%1CPP").arg(T::staticMetaObject.className());
  name.remove("Esri::ArcGISRuntime::Toolkit::");
  qmlRegisterType<T>(NAMESPACE, VERSION_MAJOR, VERSION_MINOR, name.toLatin1());
}

/*
 \internal
 \brief Adds the \c cpp_api file selector to the QML engine.
 \list
   \li \a engine Engine to add the file selector to.
 \endlist
 */
void addFileSelector(QQmlEngine* engine)
{
  auto fileSelector = QQmlFileSelector::get(engine);
  if (!fileSelector)
    fileSelector = new QQmlFileSelector(engine, engine);

  fileSelector->setExtraSelectors({"cpp_api"});
}

} // namespace

/*!
  \fn void Esri::ArcGISRuntime::Toolkit::registerComponents(QQmlEngine* engine)
  \relates Esri/ArcGISRuntime/Toolkit/register
  \brief This registration function is required to register all the C++
  controllers within your application in QML.

  For example this will expose the class provided by \c NorthArrowController.h
  in QML as \c NorthArrowController.
  
  Internally, this function add a new \c cpp_api selector to the file selector
  of \a engine. This is the mechanism utilized to override, say,
  \c NorthArrowController.qml with the \c NorthArrowController provided by C++.
 
  This register function also registers the following ArcGISRuntime
  types in the Qt Metatype system.
 
  \list
  \li \c Esri::ArcGISRuntime::Point
  \endlist
 */
void registerComponents(QQmlEngine* engine)
{
  addFileSelector(engine);
  registerComponent<AuthenticationController>();
  registerComponent<CoordinateConversionController>();
  registerComponent<CoordinateConversionOption>();
  registerComponent<CoordinateConversionResult>();
  registerComponent<NorthArrowController>();
  registerComponent<PopupViewController>();

  qRegisterMetaType<Point>("Esri::ArcGISRuntime::Point");
}

} // Toolkit
} // ArcGISRuntime
} // Esri
