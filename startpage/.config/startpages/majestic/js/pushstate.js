$(document).ready(function(){

	const site = 'Lucas Saliés Brum';

	const getLocation = function(href) {
		var l = document.createElement("a");
		l.href = href;
		if (typeof l.href === 'undefined')
			return null;
		return l.hostname;
	};

	const loadContent = (url) => {
		$('#conteudo').fadeOut('slow', function(data) {
			$.ajax({
				url: url,
				error: function() {
					$("#conteudo").text('Erro 404').fadeIn('slow');
				},
				success: function(data)	{
					$("#conteudo").html(data).fadeIn('slow');
					if (url.indexOf('contato') > -1 ) {
						$.getScript("/js/email.js");
					} else if (url.indexOf('index') > -1 ) {
						$.getScript("/js/tooltip.js");
					}
				}
			});
		});
	};

	$(document).on('click', 'a.pushstate', function (e) {
		var url = $(this).attr("href");
		var titulo = $(this).text();
		var hosts = getLocation(url);

		if (document.location.hostname === hosts) {
			e.preventDefault();
		}


		if (url.startsWith("index")) {
			url = '/';	
		}

		titulo = site + ' - ' + titulo.charAt(0).toUpperCase() + titulo.substr(1).toLowerCase();

		history.pushState({
			url: url,
			title: titulo
		}, titulo, url);

		document.title = titulo;

		loadContent(url);

		$("nav a").removeClass("active");
		$(this).addClass('active');
	});

	$(window).on('popstate', function (e) {
		var state = e.originalEvent.state;
		if (state !== null) {
			document.title = state.title;
			loadContent(state.url);
		} else {
			document.title = site;
			loadContent('index.php');
		};
	});
});