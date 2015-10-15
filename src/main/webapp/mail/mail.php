<?php
if(isset($_POST['email'])) {
 
    // EDIT THE 2 LINES BELOW AS REQUIRED
    $email_to = "rogelio.esperon@infotec.mx";
    $email_subject = "Cloudino Contact";
 
    function died($error) {
        // your error code can go here
        echo "Por favor revisa tus datos, algo no está bien,  ";
        echo "Estos son los errores.<br /><br />";
        echo $error."<br /><br />";
        echo "Regresa y corrige los errores.<br /><br />";
        die();
    }
 
    // validation expected data exists
    if(!isset($_POST['name']) ||
		!isset($_POST['telephone']) || 
        !isset($_POST['email']) ||        
        !isset($_POST['message'])) {
        died('Al parecer hay un error con el correo.');       
    }
	
    $first_name = $_POST['name']; // required
	$telephone = $_POST['telephone']; // not required
    $email_from = $_POST['email']; // required    
    $comments = $_POST['message']; // required
 
    $error_message = "";
    $email_exp = '/^[A-Za-z0-9._%-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}$/';
  if(!preg_match($email_exp,$email)) {
    $error_message .= 'Dirección de correo inválida.<br />';
  }
    $string_exp = "/^[A-Za-z\s.'-]+$/";
  if(!preg_match($string_exp,$name)) {
    $error_message .= 'Por favor no utilices acentos ni la letra "&ntilde;".<br />';
  }
  if(strlen($comments) < 2) {
    $error_message .= 'Por favor no utilices acentos ni la letra "&ntilde;".<br />';
  }
  if(strlen($error_message) > 0) {
    died($error_message);
  }
    $email_message = "Este es el mensaje:\n\n";
 
    function clean_string($string) {
      $bad = array("content-type","bcc:","to:","cc:","href");
      return str_replace($bad,"",$string);
    }
 
    $email_message .= "Nombre: ".clean_string($name)."\n";
	$email_message .= "Tel: ".clean_string($telephone)."\r\n";
    $email_message .= "Correo: ".clean_string($email)."\n";   
    $email_message .= "Mensaje: ".clean_string($message)."\n";
 
// create email headers
$headers = 'From: '.$email_from."\r\n".
'Reply-To: '.$email_from."\r\n" .
'X-Mailer: PHP/' . phpversion();
@mail($email_to, $email_subject, $email_message, $headers);
sleep(2);
echo "<meta http-equiv='refresh' content=\"0; url=http://www.cloudino.io/thanks.html\">";
?>
 
<?php
}
?>

