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
#include "OAuth2View.h"
#include "ui_OAuth2View.h"

#include "AuthenticationController.h"

namespace Esri
{
namespace ArcGISRuntime
{
namespace Toolkit
{

namespace 
{
  bool isSuccess(const QString& title)
  {
    return title.indexOf("SUCCESS code=") > -1;
  }

  bool isInvalidRequest(const QString& title) 
  {
      return (title.indexOf("Denied error=invalid_request") > -1);
  }

  bool isError(const QString& title) 
  {
    return (title.indexOf("Denied error=") > -1) || (title.indexOf("Error: ") > -1);
  }
}

/*!
  \brief Constructor.
  \list
    \li \a parent Parent widget.
  \endlist
 */
OAuth2View::OAuth2View(AuthenticationController* controller, QWidget* parent) :
  QWidget(parent),
  m_controller(controller),
  m_ui(new Ui::OAuth2View)
{
  m_ui->setupUi(this);

  connect(m_ui->buttonBox, &QDialogButtonBox::rejected,
        [this]
        {
          if(m_controller)
          {
            m_controller->cancel();
          }
        });

  connect(m_ui->webView, &QWebEngineView::titleChanged, this,
  [this](const QString& title)
  {
    setWindowTitle(title);
    if (isSuccess(title))
    {
      auto authCode = title;
      authCode.replace("SUCCESS code=", "");
      m_controller->continueWithOAuthAuthorizationCode(authCode);
    } 
    else if (isInvalidRequest(title))
    {
      m_controller->cancelWithError(title, "Invalid request");
    }
    else if (isError(title))
    {
      m_controller->cancelWithError(title, "Unspecified error");
    }
  });

  connect(m_ui->webView, &QWebEngineView::loadFinished, this,
  [this](bool ok)
  {
    if(!ok)
    {
      m_controller->cancelWithError("Failed to load", "");
    }
  });
  m_ui->webView->load(m_controller->currentChallengeUrl());
}

OAuth2View::~OAuth2View()
{
  delete m_ui;
}

} // Toolkit
} // ArcGISRuntime
} // Esri
