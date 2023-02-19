<?php

/*
Para generar las claves privadas y publicas:

openssl genrsa -out rsaprivkey.pem 512
openssl rsa -in rsaprivkey.pem -pubout -outform PEM -out rsapubkey.pem
*/
echo "<h1>Podemos encriptar con la publica y desencriptar con la privada</h1><br><br>";

$mensaje="Cristian se compromete a pagar";
echo "<h3>mensaje:</h3><br>".$mensaje."<br><br>";



$encriptado=encrypt_RSA($mensaje); // 53 caracteres maximo generando 88 caracteres de salida
echo "<h3>Mensaje firmado con clave privada = </h3>";
echo "<br>";
echo $encriptado;
echo "<br>";echo "<br>";

echo "<h3>Mando el mensaje encriptado con la clave publica y cualquiera lo podrá desencriptar de la siguiente forma:</h3>";
echo "<br>";

$desencriptado=decrypt_RSA($encriptado);
echo $desencriptado;
echo "<br>";echo "<br>";



echo "<h1>Podemos encriptar con la privada y desencriptar con la publica</h1><br><br>";

$mensaje="Cristian se compromete a pagar";
echo "<h3>mensaje:</h3><br>".$mensaje."<br><br>";


echo "<h3>Firmo mensaje con la clave privada:</h3>";//encrypt_wrong_RSA($plainData)
echo "<br>";
$encriptado=encrypt_private_RSA($mensaje); // 53 caracteres maximo generando 88 caracteres de salida
echo $encriptado;
echo "<br>";
echo "<br>";

echo "<h3>desencripto con la clave publica</h3>:";//encrypt_wrong_RSA($plainData)
echo "<br>";
$desencriptado=decrypt_public_RSA($encriptado);
echo $desencriptado;
echo "<br>";
echo "<br>";



echo "<h1>Si alguien intenta de hacerse pasar por mi firmando con la clave publica</h1><br><br>";

$mensaje="Cristian se compromete a pagar";
echo "<h3>mensaje:</h3><br>".$mensaje."<br><br>";


echo "<h3>Firmo mensaje con la clave publica:</h3>";//encrypt_wrong_RSA($plainData)
echo "<br>";
$encriptado=encrypt_RSA($mensaje); // 53 caracteres maximo generando 88 caracteres de salida
echo $encriptado;
echo "<br>";
echo "<br>";

echo "<h3>desencripto con la clave publica</h3>:";//encrypt_wrong_RSA($plainData)
echo "<br>";
$desencriptado=decrypt_public_RSA($encriptado);
echo $desencriptado;
echo "<br>";
echo "<br>";






function encrypt_RSA($plainData)
{

$publicPEMKey="-----BEGIN PUBLIC KEY-----
MFwwDQYJKoZIhvcNAQEBBQADSwAwSAJBAORXBJI5dKBUgd5vnbX2QngppT/f+vR8
z1HZs2THd122nC+L+w843IUsepFwDFwRfCPLprn+LyIE8IOhtn2zXsECAwEAAQ==
-----END PUBLIC KEY-----
";

    $publicPEMKey=openssl_get_publickey($publicPEMKey);
    if (!$publicPEMKey) 
    {
        return "Cannot get public key";
    }
    $finaltext="";
    openssl_public_encrypt($plainData,$finaltext,$publicPEMKey);
    if (!empty($finaltext)) 
    {
        openssl_free_key($publicPEMKey);
        return base64_encode( $finaltext);
    }
    else
    {
        return "Cannot Encrypt";
    }
}

function decrypt_RSA($data)
{

$privatePEMKey="-----BEGIN RSA PRIVATE KEY-----
MIIBOwIBAAJBAORXBJI5dKBUgd5vnbX2QngppT/f+vR8z1HZs2THd122nC+L+w84
3IUsepFwDFwRfCPLprn+LyIE8IOhtn2zXsECAwEAAQJBAJzQZgNGEiJJ5yar4NOm
W9/KOgKz/9UIIhlEOT9s/T0Nb/0M71HUKn6mJfRc4fc21JPju4QM2TMch1UewKER
EEECIQDzxbOWIebnYDyeaA4yfWCWkQ3aMCrd+xCTQEE1JxmfEwIhAO/LJfO4+Mrm
xrL3lfYmQ0IoCPktlrj9g6OxRxTzfEFbAiEA8ggP53cfmAiQB0MPHYgoVzYMB98d
IKr+6QS5+Xkp0isCIGCt4DxWjICJ8PzBE8YtgRqQN6X3OniVRdjepdENpkBXAiAI
v6SqWl5mslgbIT2IZkDU6sAe4UpPH/zLb7Y8JiZ7BA==
-----END RSA PRIVATE KEY-----
";

    $data = base64_decode($data);
    $privatePEMKey=openssl_get_privatekey($privatePEMKey);
    $finaltext="";
    $Crypted=openssl_private_decrypt($data,$finaltext,$privatePEMKey);
    if (!$finaltext) 
    {
        return "Cannot Decrypt";
    }
    else
    {
        return $finaltext;
    }
}

function decrypt_public_RSA($data)
{

$publicPEMKey="-----BEGIN PUBLIC KEY-----
MFwwDQYJKoZIhvcNAQEBBQADSwAwSAJBAORXBJI5dKBUgd5vnbX2QngppT/f+vR8
z1HZs2THd122nC+L+w843IUsepFwDFwRfCPLprn+LyIE8IOhtn2zXsECAwEAAQ==
-----END PUBLIC KEY-----
";

    $data = base64_decode($data);
    $publicPEMKey=openssl_get_publickey($publicPEMKey);
    $finaltext="";
    $Crypted=openssl_public_decrypt($data,$finaltext,$publicPEMKey);
    if (!$finaltext) 
    {
        return "Cannot Decrypt";
    }
    else
    {
        return $finaltext;
    }
}


function encrypt_private_RSA($plainData)
{

$privatePEMKey="-----BEGIN RSA PRIVATE KEY-----
MIIBOwIBAAJBAORXBJI5dKBUgd5vnbX2QngppT/f+vR8z1HZs2THd122nC+L+w84
3IUsepFwDFwRfCPLprn+LyIE8IOhtn2zXsECAwEAAQJBAJzQZgNGEiJJ5yar4NOm
W9/KOgKz/9UIIhlEOT9s/T0Nb/0M71HUKn6mJfRc4fc21JPju4QM2TMch1UewKER
EEECIQDzxbOWIebnYDyeaA4yfWCWkQ3aMCrd+xCTQEE1JxmfEwIhAO/LJfO4+Mrm
xrL3lfYmQ0IoCPktlrj9g6OxRxTzfEFbAiEA8ggP53cfmAiQB0MPHYgoVzYMB98d
IKr+6QS5+Xkp0isCIGCt4DxWjICJ8PzBE8YtgRqQN6X3OniVRdjepdENpkBXAiAI
v6SqWl5mslgbIT2IZkDU6sAe4UpPH/zLb7Y8JiZ7BA==
-----END RSA PRIVATE KEY-----
";

    $privatePEMKey=openssl_get_privatekey($privatePEMKey);
    if (!$privatePEMKey) 
    {
        return "Cannot get private key";
    }
    $finaltext="";
    openssl_private_encrypt($plainData,$finaltext,$privatePEMKey);
    if (!empty($finaltext)) 
    {
        openssl_free_key($privatePEMKey);
        return base64_encode( $finaltext);
    }
    else
    {
        return "Cannot Encrypt";
    }
}


?>