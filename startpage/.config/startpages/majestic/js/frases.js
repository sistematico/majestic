(function() {

    startDots();

    setInterval(function(){
        $("#frases,#autores").fadeOut(1000).promise().done(function(){
            stopDots();
            $("#frases").text('');
            $.getJSON("json/frases.json", function(data) {
                let rdm = data.frases[Math.floor(Math.random() * data.frases.length)];
                $("#frases").html(rdm.frase);
                $("#autores").html('-- ' + rdm.autor);
            }).promise().done(function(json){
                $("#frases").fadeIn(1000);
                $("#autores").fadeIn(1000);
            });            
        });
    }, 5000);


})();

var interval;

function startDots(){
    stopDots();
    dotCount = 1;
    interval = setInterval(function(){

        $(".dots").text('.'.repeat(dotCount));

        dotCount++;
        if(dotCount > 3){
            dotCount = 0;
        }

    },400);
}

function stopDots(){
    clearInterval(interval);
    dotCount = 0;
    $(".dots").text('');
}