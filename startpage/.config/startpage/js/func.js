
var defaultEng = Google;
var currEng = defaultEng;
var logo =  document.querySelector("i").classList;
var input = document.querySelector("input");
var form = document.querySelector("form");
var curr = 0;

//Changes all required things when changing search-engine
function setEngine(obj) {
  oldEng = currEng;
  currEng = obj;
  document.getElementById("buttons").innerHTML = null;
  for(i=0; i<currEng.links.length ; i++){
      document.getElementById("buttons").innerHTML += '<a class="btn" href="' + currEng.links[i].url + '">' + obj.links[i].name + '</a>\n';
      if(!(i%5) && i!=0){
        //document.getElementById("buttons").innerHTML += '<br><br><br>';
      }
  }
  
  if (currEng != Favs && currEng != Code && currEng != Sheets) {
    form.style.display="block";
    //form.action = currEng.url;
    //console.log(form.action);
    input.placeholder = currEng.ph;  
    //window.location. = "?engine=" + currEng.name;
    input.name = currEng.query;
    form.method = currEng.method;
  } else {
    form.style.display="none";
  }
  
  logo.remove(oldEng.icon);
  logo.remove(oldEng.preicon);
  logo.add(currEng.preicon);
  logo.add(currEng.icon);
  //DEBUG
  //console.log("OBJ SET: " + oldEng.name + " -> " + currEng.name + " ~~ " + i + "/" + currEng.links.length + " buttons added.");
  //DEBUG

  for(var i = 0; i<objects.length; i++){
    if(objects[i].name == currEng.name){
      curr = i;                         
      //Sets curr to engines array-number, so that nextSearchEngine knows what comes next
    }
  }
}

//Runs when form is submitted
function doSearch(){
  if (currEng == Facebook) {
    window.location = (currEng.url+currEng.query+input.value+'/keywords_search?epa=SEARCH_BOX');
  } else {
    window.location = (currEng.url+currEng.query+input.value);
  }
  return false;
}


function initialize(){
  if(getQueryVariable("engine")){
  var tempObj = lookupEngine();

  if(getQueryVariable("darkmode") == "true"){
    darkMode(true);
  }else{
    darkMode(false);
  }
  setEngine(tempObj);

  //DEBUG
  console.log("ENGINE SET: " + tempObj.name);
  //DEBUG

  }else{
    setEngine(defaultEng);
  }
}

function css( element, property ) {
    return window.getComputedStyle( element, null ).getPropertyValue( property );
}

// Change font
function changeFont() {
  var elem = document.getElementById('corpo');
  var font = css(elem, 'font-family'); // returns '16px' for instance
  font = font.split(",");
  var fonte = font[0].replace(/['"]+/g, '');
  //font.replace(/"/g,"")
  //console.log('Fonte: ' + font[0]);
  if (fonte == "Ubuntu") {
    elem.style.fontFamily = "Dosis, sans-serif";
  } else if (fonte == "Dosis") {
    elem.style.fontFamily = "Ubuntu, sans-serif";
  }

  var text = document.getElementById('fonte').firstChild;
  text.data = text.data == "Ubuntu" ? "Dosis" : "Ubuntu";
}

//Button-function
function howTo() {
  if(logo.contains("blur")){
    logo.remove("blur");

    form.classList.remove("blur");
    input.classList.remove("blur");
    helpText.style.visibility = "hidden";
  }else{
    logo.add("blur");
    form.classList.add("blur");
    input.classList.add("blur");
    helpText.style.visibility = "visible";
  }
}

//Button-function

function nextSearchEngine() {
  /*
    //We should first check the current engine here
    
  */ 
  
  //Sets engine to the next object in objects.js
  if(curr<objects.length){
    if(curr<(objects.length)-1){
      setEngine(objects[++curr]);
      console.log(objects.length);
      console.log(curr);
    }else{
      curr=0;
      setEngine(objects[curr]);
    }
  }else{
    console.log("critical error")
  }
}
function darkMode(mode) {

  var text = document.getElementById('modo').firstChild;
  text.data = text.data == "Darkmode" ? "Lightmode" : "Darkmode";


  var pref = document.body.classList;
  var input = document.querySelector("input").classList;
  var logo =  document.querySelector("i").classList;
  var btns = document.getElementById("buttons").classList;
  
  
  if(mode) {
    pref.add("dark");
  } else {
    pref.remove("dark");
  }
}

//Button-function
function toggleDarkMode() {
  if (!(document.body.classList.contains("dark"))) {
    darkMode(true);
  }else{
    darkMode(false);
  }

  
}

function getQueryVariable(variable){
      var query = window.location.search.substring(1);
      var vars = query.split("&");
      for (var i=0;i<vars.length;i++) {
              var pair = vars[i].split("=");
              if(pair[0] == variable){return pair[1];}
      }
      return(false);

      
}
console.log(getQueryVariable("engine"));
console.log(getQueryVariable("darkmode"));

function lookupEngine(){

  eng = getQueryVariable("engine");
  
  lookup = {

  }

  for(var i=0;i<objects.length;i++){
    lookup[objects[i].name] = objects[i];   
    //Loops through every object name, and links it to the object with that name
  }
  return lookup[eng];

  //DEBUG
  //console.log("HASH: " + hash.name);
  //DEBUG

}


initialize();

