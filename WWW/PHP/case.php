<?php //controlador 

include_once('./Clases/Empleados.php');
include_once('./Clases/Puestos.php');

$arrRespuesta = array(); //respuesta
$iOpcion = filter_input(INPUT_POST, 'iOpcion'); //entrada
$opcion = filter_input(INPUT_POST, 'opcion'); //entrada
$numeroempleado = filter_input(INPUT_POST, 'numeroempleado'); //entrada
$nombre = filter_input(INPUT_POST, 'nombre');
$appaterno = filter_input(INPUT_POST, 'apellidopaterno'); //entre '' el nombre en la tabla, el post lo busca como 'apellidopaterno'
$appmaterno = filter_input(INPUT_POST, 'apellidomaterno');
$direccion = filter_input(INPUT_POST, 'direccion');
$codigopostal = filter_input(INPUT_POST, 'codigopostal');
$telefono = filter_input(INPUT_POST, 'telefono');
$curp = filter_input(INPUT_POST, 'curp');
$nss = filter_input(INPUT_POST, 'nss');
$puesto = filter_input(INPUT_POST, 'puesto');
$causabaja = filter_input(INPUT_POST, 'causabaja');
$idpuesto = filter_input(INPUT_POST, 'idpuesto');
$descripcion = filter_input(INPUT_POST, 'descripcion');
$empleadoalta = filter_input(INPUT_POST, 'empleadoalta');
$empleadobaja = filter_input(INPUT_POST, 'empleadobaja');

switch($iOpcion){
    //case 1-5 es para empleados
    case '1':
        $arrRespuesta=Empleados::consultaEmpleadoActivo($opcion,$numeroempleado);
    break;

    case '2':
        $arrRespuesta=Empleados::agregarEmpleado($opcion,$numeroempleado,$nombre,$appaterno,$appmaterno,$direccion,$codigopostal,$telefono,$curp,$nss,$puesto); //lo recibe del ajax
    break;

    case '3':
        $arrRespuesta=Empleados::modificarEmpleado($opcion,$numeroempleado,$direccion,$codigopostal,$telefono,$curp,$nss,$puesto); //parametros que recibe del ajax para mdificar datos de empleado
    break;

    case '4':
        $arrRespuesta=Empleados::bajaEmpleado($opcion,$numeroempleado,$causabaja);
    break;

    //case 6-11 es para puestos
    case '6':
        $arrRespuesta=Puestos::consultaPuestoActivo($opcion,$idpuesto);
    break;

    case '7':
        $arrRespuesta=Puestos::agregarPuesto($opcion,$idpuesto,$descripcion,$empleadoalta);
    break;

    case '8':
        $arrRespuesta=Puestos::modificarPuesto($opcion,$idpuesto,$descripcion);
    break;

    case '9':
        $arrRespuesta=Puestos::bajaPuesto($opcion,$idpuesto,$empleadobaja);
    break;
}


echo json_encode($arrRespuesta);