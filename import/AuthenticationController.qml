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
import QtQml 2.12

import Esri.ArcGISRuntime 100.8

/*!
  \qmltype AuthenticationController
  \inqmlmodule Esri.ArcGISRuntime.Toolkit
  \since Esri.ArcGISRutime 100.9
  \brief In MVC architecture, this is the controller for the corresponding
  AuthenticationView.  
  
  This controller is a thin wrapper around a AuthenticationManager. As
  AuthenticationManager challenges are queued, the controller holds onto a 
  "current" challenge, which is the challenge the user is presented with, which
  will be discarded once the user chooses an action to perform on the challenge.
 */

QtObject {
    id: authenticationController
    /*!
      \qmlproperty url currentChallengeUrl
      \brief The authorization url of the current AuthenticationChallenge.
     */
    property url currentChallengeUrl: internal.currentChallenge ? internal.currentChallenge.authorizationUrl : "";
    
    /*!
        \qmlproperty string currentAuthenticatingHost
        \brief Returns the authorization hostname of the current 
        AuthenticationChallenge.
    */
    property string currentAuthenticatingHost: internal.currentChallenge ? internal.currentChallenge.authenticatingHost.toString() : "";
    
    /*!
        \qmlproperty int currentChallengeType
        \brief The type of the current challenge as an int.
    */
    property int currentChallengeType: internal.currentChallenge ? internal.currentChallenge.authenticationChallengeType : Enums.AuthenticationChallengeTypeUnknown;
    
    /*!
        \qmlproperty int currentChallengeFailureCount
        \brief The failure count of the current AuthenticationChallenge.
    */
    property int currentChallengeFailureCount: internal.currentChallenge ? internal.currentChallenge.failureCount : 0;
    
    /*!
    \qmlproperty int clientCertificateInfos
    \brief The list of ClientCertificateInfo strings currently held by the
    AuthenticationManager.
    */
    property var clientCertificateInfos: AuthenticationManager.clientCertificateInfos

    /*!
    \signal clientCertificatePasswordRequired(url certificate)
    \brief Emitted when a certificate that was added to the 
    AuthenticationManager requires a password.
    \sa addClientCertificate
    */
    signal clientCertificatePasswordRequired(url certificate);
  
    function addClientCertificate(...args) {
        return AuthenticationManager.addClientCertificate(...args);
    }
  
    function continueWithUsernamePassword(...args) {
        internal.currentChallenge.continueWithUsernamePassword(...args);
        internal.currentChallenge = null;
    }
  
    function continueWithOAuthAuthorizationCode(...args) {
        internal.currentChallenge.continueWithOAuthAuthorizationCode(...args);
        internal.currentChallenge = null;
    }
  
    function continueWithClientCertificate(...args) {
        internal.currentChallenge.continueWithClientCertificate(...args);
        internal.currentChallenge = null;
    }
  
    function continueWithSslHandshake(...args) {
        internal.currentChallenge.continueWithSslHandshake(...args);
        internal.currentChallenge = null;
    }
  
    function cancel(...args) {
        internal.currentChallenge.cancel(...args);
        internal.currentChallenge = null;
    }
    
    property QtObject internal: QtObject {
        property AuthenticationChallenge currentChallenge: null;
  
        property Connections managerConnection: Connections {
            target: AuthenticationManager
            ignoreUnknownSignals: false
            onAuthenticationChallenge: {
                if (internal.challenge)
                  internal.challenge.cancel();
  
                internal.currentChallenge = challenge;
            }
            onClientCertificatePasswordRequired: {
                authenticationController.clientCertificatePasswordRequired(certificate);
            }
        }
    }
}