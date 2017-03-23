document.addEventListener("turbolinks:load", function() {

    $(".categoryLink").on ("click",function(){
        console.log("clickLink");
        $("#category").toggle();

    })

$("#flash").fadeOut(3000)
})
