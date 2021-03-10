//console.log('ayy' + ' ' + 'lmao');

window.onload = greeting;

function greeting() {

function checkTime(i) {
  if (i < 10) {
    i = "0" + i;
  }
  return i;
}

function time() {
  var today = new Date();
  var h = today.getHours();
  var m = today.getMinutes();
  var s = today.getSeconds();
  // add a zero in front of numbers<10
  m = checkTime(m);
  s = checkTime(s);
  document.getElementById('time').innerHTML = h + ":" + m + ":" + s;
  t = setTimeout(function() {
    time()
  }, 500);
}
time();

var dateJS = new Date();
var hrs = dateJS.getHours();

	var greeting;

	if (hrs < 12)
	        greeting = 'Bom dia!';
	    else if (hrs >= 12 && hrs <= 17)
	        greeting = 'Boa tarde!';
	    else if (hrs >= 17 && hrs <= 24)
	        greeting = 'Boa noite!';

	document.getElementById('greet').innerHTML =
	        greeting;
}