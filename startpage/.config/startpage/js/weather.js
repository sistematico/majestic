fetch('https://api.openweathermap.org/data/2.5/weather?lat={lat}&lon={lon}&appid={your api key}')
.then(function(response) {
  return response.json();
})
.then(function(json) {
  console.log(json);
});
