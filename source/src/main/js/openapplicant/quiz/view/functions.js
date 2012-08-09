/**
 * Created with JetBrains PhpStorm.
 * User: gaston
 * Date: 7/10/12
 * Time: 3:43 PM
 * To change this template use File | Settings | File Templates.
 */
 
$(document).ready(function(){

	/** CARGA LA PÁGINA CON UN EFECTO DE SMOOTH **/
    $('#container *').addClass('fade-out');
    setTimeout(function(){
        $('#container *').removeClass('fade-out').addClass('fade-in');
        setTimeout(function(){
            $('#container *').removeClass('fade-in');
        },300);

    },800);
	
});