# Leeswijzer

## Concept onderzoek

## Proof of concepts

[Custom vision AI - Azure][Onderzoek customAI.pdf]

[Face detection - Google][Face detection - Google.zip]

[Image labelling - Google][Image labelling - Google.zip]

[Object detection - Google][Object detection - Google.zip]

[Text recognition - Google][Text recognition - Google.zip]

## Prototypes 

| Naam service/Product | Platform Cloud Hosting | Onderzocht | Conclusie |
| :------------------: | :--------------------: | :--------: | :-------: |
|  Language Understanding | Microsoft Azure | ✅ | [Onderzoek Stagegesprek bot][link] <br> [Onderzoek internbot][link2] |
|  QnA Maker | Microsoft Azure | ✅ | [Veelgestelde vragen onderzoek][link2] |
|  Bot Framework SDK | Microsoft Azure | ✅ | [Bot Framework SDK - Azure][BotFramework SDK Microsoft Azure.zip] |
|  Anomaly Detector | Microsoft Azure | ✅ | 
|  Content Moderator | Microsoft Azure | 🚫 | 
|  Personalizer | Microsoft Azure | 🚫 |
|  Metrics Advisor | Microsoft Azure | 🚫 | 
|  Text analytics |Microsoft Azure | 🚫 |
|  Translator | Microsoft Azure | 🚫 | 
|  Insluitende lezer | Microsoft Azure | 🚫 |
|  Speech to Text |Microsoft Azure | 🚫 |
|  Text to Speech | Microsoft Azure | 🚫 |
|  Speech Translation | Microsoft Azure | 🚫 |
|  Speaker Recognition | Microsoft Azure | 🚫 |
|  Computer Vision | Microsoft Azure | ✅ | 
|  Custom Vision | Microsoft Azure | ✅ | [Onderzoek custom AI][Onderzoek customAI.pdf] |
|  Face Recognition | Microsoft Azure | 🚫 | 
|  Form Recognizer | Microsoft Azure | 🚫 | 
|  Video Indexer | Microsoft Azure | 🚫 | 
|  Face Detection | Google Cloud Firebase ML Kit | ✅ | 
|  Text Recognition | Google Cloud Firebase ML Kit | ✅ |
|  Diaglogflow | Google Cloud | ✅ | [Veel gestelde vragen onderzoek][link2]  |

[Schematische Cognitive Service.xlsx]:https://github.com/teundeclercq/Research-AI-services/files/5765295/Schematische.Cognitive.Service.xlsx
[Onderzoek customAI.pdf]:https://github.com/teundeclercq/Research-AI-services/files/5768963/Onderzoek.customAI.pdf
[Face detection - Google.zip]:https://github.com/teundeclercq/Research-AI-services/files/5769353/Face.detection.-.Google.zip
[Image labelling - Google.zip]:https://github.com/teundeclercq/Research-AI-services/files/5769356/Image.labelling.-.Google.zip
[Object detection - Google.zip]:https://github.com/teundeclercq/Research-AI-services/files/5769358/Object.detection.-.Google.zip
[Text recognition - Google.zip]:https://github.com/teundeclercq/Research-AI-services/files/5769359/Text.recognition.-.Google.zip
[BotFramework SDK Microsoft Azure.zip]:https://github.com/teundeclercq/Research-AI-services/files/5769467/BotFramework.SDK.Microsoft.Azure.zip


[Internbot.zip]:https://github.com/teundeclercq/Research-AI-services/files/5769471/Internbot.zip

[CV Checker.zip]:https://github.com/teundeclercq/Research-AI-services/files/5769469/CV.Checker.zip


<!-- Tab links -->
<div class="tab">
  <button class="tablinks" onclick="openCity(event, 'London')">London</button>
  <button class="tablinks" onclick="openCity(event, 'Paris')">Paris</button>
  <button class="tablinks" onclick="openCity(event, 'Tokyo')">Tokyo</button>
</div>

<!-- Tab content -->
<div id="London" class="tabcontent">
  <h3>London</h3>
  <p>London is the capital city of England.</p>
</div>

<div id="Paris" class="tabcontent">
  <h3>Paris</h3>
  <p>Paris is the capital of France.</p>
</div>

<div id="Tokyo" class="tabcontent">
  <h3>Tokyo</h3>
  <p>Tokyo is the capital of Japan.</p>
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
 /* Style the tab */
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
