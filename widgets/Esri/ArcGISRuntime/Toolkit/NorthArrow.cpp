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
#include "NorthArrow.h"

// Qt headers
#include <QMouseEvent>

// ArcGIS Headers
#include <MapGraphicsView.h>
#include <SceneGraphicsView.h>

#include "Esri/ArcGISRuntime/Toolkit/NorthArrowController.h"

namespace Esri
{
namespace ArcGISRuntime
{
namespace Toolkit
{

NorthArrow::NorthArrow(QWidget* parent) :
  QLabel(parent),
  m_controller(new NorthArrowController(this))
{
  m_image = QPixmap(":/esri/arcgisruntime/tookit/images/compass.png");

  if (!m_image.isNull())
  {
    this->setPixmap(m_image);
  }

  connect(m_controller, &NorthArrowController::headingChanged, this, [this]()
  {
    if (m_image.isNull())
      return;

    QMatrix rm;
    rm.rotate(-m_controller->heading());
    const int imageWidth = m_image.width();
    const int imageHeight = m_image.height();
    auto pix = m_image.transformed(rm, Qt::SmoothTransformation);
    pix = pix.copy((pix.width() - imageWidth)/2,
                   (pix.height() - imageHeight)/2,
                   imageWidth,
                   imageHeight);
    this->setPixmap(pix);
  });
}

NorthArrow::~NorthArrow()
{
}

void NorthArrow::setMapView(MapGraphicsView* mapView)
{
  m_controller->setGeoView(mapView);
}

void NorthArrow::setSceneView(SceneGraphicsView* sceneView)
{
  m_controller->setGeoView(sceneView);
}

void NorthArrow::mouseDoubleClickEvent(QMouseEvent* event)
{
  m_controller->setHeading(0);
  event->accept();
}

NorthArrowController* NorthArrow::controller() const
{
  return m_controller;
}

} // Toolkit
} // ArcGISRuntime
} // Esri