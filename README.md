# Prototype repo for new qt toolkit

## Introduction

This toolkit is an open source resource intended for use with the ArcGIS Runtime
SDK for Qt. It provides ready made UI components to complement mapping and GIS
applications. Because it is open source you are encouraged to modify these tools
and add your own.

## Structure

This repo contains 3 toolkit projects, each intended for use with a different
flavor of the ArcGIS Runtime SDK for Qt:

- toolkitqml (for use with QML only apps)
- toolkitcpp (for use with C++ apps which use a QtQuick UI)
- toolkitwidgets (for use with C++ apps which use a QWidgets UI)

You need to clone this repository locally to incorporate it into your own
project.

### toolkitqml.pri

#### importing the toolkit (toolkitqml.pri)

A good way to start using the toolkit is to use one of the template apps which
get added to QtCreator when you install the ArcGIS Runime SDK for Qt.

- In QtCreator choose `File/New file or project/ArcGIS/ArcGIS Runtime 100.X
  Quick QML App
- choose settings to match the platform etc. you are building for
- in the .pro` file of your new app, add a line to add the toolkit for your
  QML application. For example:

```pro
include(path/to/toolkitqml.pri)
```

#### using a tool from the toolkit (toolkitqml.pri)

Once you have successfully imported the toolkit, you can access individual tools
in your own QML files.

- add an import statement for the toolkit:
  `import "qrc:///Esri/ArcGISRuntime/Toolkit" as Toolkit`
- declare the tool you wish to use. Generally you will also have to supply the
  `GeoView` etc. you wish the tool to work with. For example, to add a
  `NorthArrow`:

```qml
import Esri.ArcGISRuntime 100.X
import "qrc:///Esri/ArcGISRuntime/Toolkit" as Toolkit

MapView {
    id: mapView

    Map {
      BasemapTopographic {}
    }

    Toolkit.NorthArrow {
        id: arrow
        width: 32
        height: 32
        anchors {
            right: parent.right
            bottom: view.bottom
        }
        geoView: mapView
    }
}
```

### toolkitcpp.pri

#### importing the toolkit (toolkitcpp.pri)

A good way to start using the toolkit is to use one of the template apps which
get added to QtCreator when you install the ArcGIS Runime SDK for Qt.

- In QtCreator choose `File/New file or project/ArcGIS/ArcGIS Runtime 100.X Qt
  Quick C++ App
- choose settings to match the platform etc. you are building for
- in the .pro` file of your new app, add a line to add the library for your QML
  plugin - for example:

```pro
include(path/to/toolkitcpp.pri)
```

- in the Run environment settings for the app, add a new environment variable to
  import the QML module - e.g:

- in `main.cpp` add a line to import the toolkit registration function.

```cpp
#include "Esri/ArcGISRuntime/Toolkit/register.h"
```

- in `main.cpp` (inside the main function) call the registration function.

```cpp
Esri::ArcGISRuntime::Toolkit::registerComponents(myQmlEngine);
```

#### using a tool from the toolkit (toolkitcpp.pri)

Once you have successfully imported the toolkit, you can access individual tools
in your own QML files.

- add an import statement for the toolkit:
`import esri.arcgisruntime.toolkit 1.0`
- declare the tool you wish to use. Generally you will also have to supply the
  `GeoView` etc. you wish the tool to work with. For example, to add a `NorthArrow`:

```qml
import Esri.ArcGISRuntime 100.X
import "qrc:///Esri/ArcGISRuntime/Toolkit" as Toolkit

MapView {
    id: mapView

    Map {
      BasemapTopographic {}
    }

    Toolkit.NorthArrow {
        id: arrow
        width: 32
        height: 32
        anchors {
            right: parent.right
            bottom: view.bottom
        }
        geoView: mapView
    }
}
```

### toolkitwidgets.pri

#### importing the toolkit (toolkitwidgets.pri)

A good way to start using the toolkit is to use one of the template apps which
get added to QtCreator when you install the ArcGIS Runtime SDK for Qt.

- In QtCreator choose `File/New file or project/ArcGIS/ArcGIS Runtime 100.X Qt
  Widgets App
- choose settings to match the platform etc. you are building for
- in the .pro` file of your new app, add a line to add the library for your QML
  plugin - for example:

```pro
include(path/to/toolkitwidgets.pri)
```

#### using a tool from the toolkit (toolkitwidgets.pri)

Once you have successfully imported the toolkit, you can create individual tools
in your own widgets files.

- in your widgets code, create a new instance of the tool you wish to use and
  add it your widgets layout. You will also normally need to pass the `GeoView`
  which the tool is designed to work with:

```cpp
  #include "Esri/ArcGISRuntime/Toolkit/NorthArrow.h"
  ...
  auto northArrow = new NorthArrow(this);
  northArrow->setMapView(m_mapView);
  northArrow->show();
```
