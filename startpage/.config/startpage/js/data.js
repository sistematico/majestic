// var currentdate = new Date(); 
// var datetime = "Last Sync: " + currentdate.getDate() + "/"
//                 + (currentdate.getMonth()+1)  + "/" 
//                 + currentdate.getFullYear() + " @ "  
//                 + currentdate.getHours() + ":"  
//                 + currentdate.getMinutes() + ":" 
//                 + currentdate.getSeconds();

var currentdate = new Date(); 
var datetime = "Last Sync: " + currentdate.getDate() + "/"
                + (currentdate.getMonth()+1)  + "/" 
                + currentdate.getFullYear() + " @ "  
                + ('0' + currentdate.getHours()).slice(-2) + ":"  
                + ('0' + currentdate.getMinutes()).slice(-2) + ":" 
                + ('0' + currentdate.getSeconds()).slice(-2);

//document.getElementById("data").innerHTML = datetime;
document.querySelector('.data').innerHTML = datetime;