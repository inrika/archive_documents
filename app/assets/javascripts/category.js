document.addEventListener("turbolinks:load", function() {

    $(".categoryLink").on ("click",function(){
        console.log("clickLink");
        $("#category").toggle();

    })

    $(".document_typeLink").on ("click",function(){
      $("#document_type").toggle();

    })


$("#flash").fadeOut(3000)
})
