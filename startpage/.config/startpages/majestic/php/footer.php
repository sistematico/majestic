        <footer class="mt-auto text-white-50">
            <p>
                &copy; 2020 Lucas Saliés Brum
                <br />
                <small id="frases">Carregando frases<span class="dots"></span></small>
                <br />
                <small id="autores">Carregando autores<span class="dots"></span></small>
                <br />
                <small><?php include('php/counter.php'); ?></small>
            </p>
        </footer>
    </div>    
    <script src="js/jquery-3.5.1.min.js"></script>
    <script src="js/bootstrap.bundle.min.js"></script>
    <script src="js/pushstate.js?v=<?php echo uniqid(); ?>"></script>
    <script src="js/email.js?v=<?php echo uniqid(); ?>"></script>
    <script src="js/frases.js?v=<?php echo uniqid(); ?>"></script>
    <script src="js/script.js?v=<?php echo uniqid(); ?>"></script>
</body>
</html>