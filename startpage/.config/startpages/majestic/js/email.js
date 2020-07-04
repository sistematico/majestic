$("#formcontato").submit(function(event) {
    event.preventDefault();
    //event.stopPropagation();

    let isValid = true;

    if($('#nome').val() == '' || $('#nome').val().length > 0 && $('#nome').val().length < 3) {
        isValid = false;
        $("#nome").removeClass("is-valid");
        $("#nome").addClass("is-invalid");
        $("#nome").siblings(".invalid-feedback").text("Nome muito curto");    
    } else {
        $("#nome").removeClass("is-invalid");
        $("#nome").addClass("is-valid");
    }

    if ($('#email').val() == '' || ! /^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$/.test($('#email').val())) {
        isValid = false;
        $("#email").siblings(".invalid-feedback").text("Formato de e-mail inválido");
        $("#email").removeClass("is-valid");
        $("#email").addClass("is-invalid");
    } else {
        $("#email").removeClass("is-invalid");
        $("#email").addClass("is-valid");
    }

    if($('#mensagem').val() == '' || $('#mensagem').val().length > 0 && $('#mensagem').val().length < 3) {
        isValid = false;
        $("#mensagem").addClass("is-invalid");
        $("#mensagem").siblings(".invalid-feedback").text("Mensagem muito curta");    
    } else {
        $("#mensagem").removeClass("is-invalid");
        $("#mensagem").addClass("is-valid");
    }

    $(this).addClass("was-validated");

    if (isValid) {
        var formData = $(this).serialize();
        let spinner = '<span class="spinner-border spinner-border-sm" role="status" aria-hidden="true"></span>';
        $('#btnenviar').html(spinner + ' Enviando');

        $.ajax({
            type: 'POST',
            url: 'php/email.php',
            data: formData
        }).done(function(response) {
            if (response == 'E-mail enviado com sucesso') {
                $("#alertsuccess").html(response).fadeIn(1000);
                $('#nome,#email,#secao,#assunto,#mensagem').empty();
                $('#nome,#email,#secao,#assunto,#mensagem,#btnenviar').prop("disabled", true);
                setTimeout(function(){ $("#alertsuccess").fadeOut(1000); }, 7000);

                setTimeout(function(){ $('#btnenviar').html('Enviado!'); }, 3000);
            } else {
                $("#alerterror").html(response).fadeIn(1000);
                setTimeout(function(){ $("#alerterror").fadeOut(1000); }, 7000);

                setTimeout(function(){ $('#btnenviar').html('Re-enviar'); }, 3000);
            }
        }).fail(function(data) {
          
        }).always(function() {  });
    }
});