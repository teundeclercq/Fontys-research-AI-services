# Leeswijzer

## Concept onderzoek

## Proof of concepts

[Custom vision AI - Azure][Onderzoek customAI.pdf]

[Face detection - Google][Face detection - Google.zip]

[Image labelling - Google][Image labelling - Google.zip]

[Object detection - Google][Object detection - Google.zip]

[Text recognition - Google][Text recognition - Google.zip]

## Prototypes 

<!-- Tab links -->
<div class="tab">
  <button class="tablinks active" onclick="openCity(event, 'Azure')">Azure</button>
  <button class="tablinks" onclick="openCity(event, 'Google')">Google</button>
</div>

<!-- Tab content -->
<div id="Azure" class="tabcontent">
  <table style="margin-left: auto; margin-right: auto;">
    <tr>
        <th>Naam service</th>
        <th>Platform Cloud Hosting</th>
        <th>Onderzocht</th>
        <th>Conclusie</th>
    </tr>
    <tr>
        <td>Language Understanding</td>
        <td>Microsoft Azure</td>
        <td>✅</td>
        <td></td>
    </tr>
    <tr>
        <td>QnA Maker</td>
        <td>Microsoft Azure</td>
        <td>✅</td>
        <td>[Veelgestelde vragen onderzoek][link2]</td>
    </tr>
    <tr>
        <td>Bot Framework SDK</td>
        <td>Microsoft Azure</td>
        <td>✅</td>
        <td><a href="https://github.com/teundeclercq/Research-AI-services/files/5769467/BotFramework.SDK.Microsoft.Azure.zip">Bot Framework SDK</a></td>
    </tr>
    <tr>
        <td>Anomaly Detector</td>
        <td>Microsoft Azure</td>
        <td>✅</td>
        <td></td>
    </tr>
    <tr>
        <td>Content Moderator</td>
        <td>Microsoft Azure</td>
        <td>🚫</td>
        <td></td>
    </tr>
    <tr>
        <td>Personalizer</td>
        <td>Microsoft Azure</td>
        <td>🚫</td>
        <td></td>
    </tr>
    <tr>
        <td>Metrics Advisor</td>
        <td>Microsoft Azure</td>
        <td>🚫</td>
        <td></td>
    </tr>
    <tr>
        <td>Text analytics</td>
        <td>Microsoft Azure</td>
        <td>🚫</td>
        <td></td>
    </tr>
    <tr>
        <td>Translator</td>
        <td>Microsoft Azure</td>
        <td>🚫</td>
        <td></td>
    </tr>    
    <tr>
        <td>Insluitende lezer</td>
        <td>Microsoft Azure</td>
        <td>🚫</td>
        <td></td>
    </tr>
    <tr>
        <td>Speech to Text</td>
        <td>Microsoft Azure</td>
        <td>🚫</td>
        <td></td>
    </tr>
    <tr>
        <td>Text to Speech</td>
        <td>Microsoft Azure</td>
        <td>🚫</td>
        <td></td>
    </tr>
    <tr>
        <td>Speech Translation </td>
        <td>Microsoft Azure</td>
        <td>🚫</td>
        <td></td>
    </tr>
    <tr>
        <td>Computer Vision</td>
        <td>Microsoft Azure</td>
        <td>✅</td>
        <td></td>
    </tr>
    <tr>
        <td>Custom Vision</td>
        <td>Microsoft Azure</td>
        <td>✅</td>
        <td><a href="https://github.com/teundeclercq/Research-AI-services/files/5768963/Onderzoek.customAI.pdf">Custom Vision AI</a></td>
    </tr>
    <tr>
        <td>Face Recognition</td>
        <td>Microsoft Azure</td>
        <td>🚫</td>
        <td></td>
    </tr>
    <tr>
        <td>Form Recognizer</td>
        <td>Microsoft Azure</td>
        <td>🚫</td>
        <td></td>
    </tr>
    <tr>
        <td>Video Indexer</td>
        <td>Microsoft Azure</td>
        <td>🚫</td>
        <td></td>
    </tr>    
    <tr>
        <td>Video Indexer</td>
        <td>Microsoft Azure</td>
        <td>🚫</td>
        <td></td>
    </tr>
  </table>
  

</div>

<div id="Google" class="tabcontent">
   <table>
    <tr>
       <th>Naam service</th>
       <th>Platform Cloud Hosting</th>
       <th>Onderzocht</th>
       <th>Conclusie</th>
    </tr>
    <tr>
        <td>Face detection</td>
        <td>Google Cloud Firebase ML Kit</td>    
        <td>✅</td>
        <td></td>
    </tr>    
    <tr>
        <td>Text Recognition</td>
        <td>Google Cloud Firebase ML Kit</td>    
        <td>✅</td>
        <td></td>
    </tr>
    <tr>
        <td>Dialogflow</td>
        <td>Google Cloud</td>    
        <td>✅</td>
        <td></td>
    </tr>
   </table>

</div>


<script>
function openCity(evt, cityName) {
  // Declare all variables
  var i, tabcontent, tablinks;

  // Get all elements with class="tabcontent" and hide them
  tabcontent = document.getElementsByClassName("tabcontent");
  for (i = 0; i < tabcontent.length; i++) {
    tabcontent[i].style.display = "none";
  }

  // Get all elements with class="tablinks" and remove the class "active"
  tablinks = document.getElementsByClassName("tablinks");
  for (i = 0; i < tablinks.length; i++) {
    tablinks[i].className = tablinks[i].className.replace(" active", "");
  }

  // Show the current tab, and add an "active" class to the button that opened the tab
  document.getElementById(cityName).style.display = "block";
  evt.currentTarget.className += " active";
} 
</script>

<style>
.tab {
  overflow: hidden;
  border: 1px solid #ccc;
  background-color: #f1f1f1;
}

/* Style the buttons that are used to open the tab content */
.tab button {
  background-color: inherit;
  float: left;
  border: none;
  outline: none;
  cursor: pointer;
  padding: 14px 16px;
  transition: 0.3s;
}

/* Change background color of buttons on hover */
.tab button:hover {
  background-color: #ddd;
}

/* Create an active/current tablink class */
.tab button.active {
  background-color: #ccc;
}

/* Style the tab content */
.tabcontent {
  display: none;
  padding: 6px 12px;
  border: 1px solid #ccc;
  border-top: none;
} 
</style>


[Schematische Cognitive Service.xlsx]:https://github.com/teundeclercq/Research-AI-services/files/5765295/Schematische.Cognitive.Service.xlsx
[Onderzoek customAI.pdf]:https://github.com/teundeclercq/Research-AI-services/files/5768963/Onderzoek.customAI.pdf
[Face detection - Google.zip]:https://github.com/teundeclercq/Research-AI-services/files/5769353/Face.detection.-.Google.zip
[Image labelling - Google.zip]:https://github.com/teundeclercq/Research-AI-services/files/5769356/Image.labelling.-.Google.zip
[Object detection - Google.zip]:https://github.com/teundeclercq/Research-AI-services/files/5769358/Object.detection.-.Google.zip
[Text recognition - Google.zip]:https://github.com/teundeclercq/Research-AI-services/files/5769359/Text.recognition.-.Google.zip
[BotFramework SDK Microsoft Azure.zip]:https://github.com/teundeclercq/Research-AI-services/files/5769467/BotFramework.SDK.Microsoft.Azure.zip


[Internbot.zip]:https://github.com/teundeclercq/Research-AI-services/files/5769471/Internbot.zip

[CV Checker.zip]:https://github.com/teundeclercq/Research-AI-services/files/5769469/CV.Checker.zip
