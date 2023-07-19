CREATE TABLE tbcatempleadosprueba(
  --NOMBRECAMBIO TIPOCAMPO ;
  keyx INT GENERATED ALWAYS AS IDENTITY, --serial
  nombre VARCHAR(50),
  apellidopaterno VARCHAR(50),
  apellidomaterno VARCHAR(50),
  direccion VARCHAR(60),
  codigopostal VARCHAR(5),
  telefono VARCHAR(10),
  curp VARCHAR(18),
  nss VARCHAR(11),
  fechaalta DATE,
  numeroempleado INTEGER PRIMARY KEY,
  puesto INTEGER,
  fechabaja DATE DEFAULT '1900-01-01', --AAAA/MM/DD;
  estatus SMALLINT DEFAULT 1,
  causabaja VARCHAR DEFAULT ''
);

CREATE TABLE tbcatpuestosprueba(
    keyx INT GENERATED ALWAYS AS IDENTITY, --serial
    fechaalta DATE,
    idpuesto INTEGER PRIMARY KEY NOT NULL,
    descripcion VARCHAR(100),
    estatus INTEGER DEFAULT 1,
    fechabaja DATE DEFAULT '1900-01-01', --AAAA/MM/DD;
    empleadoregistra INTEGER NOT NULL,
    empleadobaja INTEGER NOT NULL 
);

CREATE OR REPLACE FUNCTION fnoperacionesempleados(
    iOpcion INTEGER,
    iNumEmpleado INTEGER,
    sNombre VARCHAR(50),
    sApPaterno VARCHAR(50),
    sApMaterno VARCHAR(50),
    sDireccion VARCHAR(60),
    sCodigoPostal VARCHAR(5),
    sTelefono VARCHAR(10),
    sCurp VARCHAR(18),
    sNss VARCHAR(11),
    iPuesto INTEGER,
    sCausaBaja VARCHAR)

RETURNS TABLE(tnumempleado INTEGER, tnombre VARCHAR(50), tappaterno VARCHAR(50), tapmaterno VARCHAR(50), tdireccion VARCHAR(60), tcodigopostal VARCHAR(5), ttelefono VARCHAR(10), tcurp VARCHAR(18), tnss VARCHAR(11), tdescripcionpuesto VARCHAR(100), testatus integer, tmensaje TEXT) AS $BODY$ --retorna todos estos datos como respuesta

DECLARE 
    -- tnumempleado INTEGER;
    -- tnombre VARCHAR(50);
    -- tappaterno VARCHAR(50);
    -- tapmaterno VARCHAR(50);
    -- tdireccion VARCHAR(60);
    -- tcodigopostal VARCHAR(5);
    -- ttelefono VARCHAR(10);
    -- tcurp VARCHAR(18);
    -- tnss VARCHAR(11);
    -- tdescripcionpuesto VARCHAR(100);
    -- testatus integer;
    -- tmensaje TEXT;

BEGIN
    CASE 
        WHEN iOpcion = 1 THEN  --OPCION QUE AGREGA LA INFORMACION DEL EMPLEADO A LA BASE DE DATOS
            IF EXISTS(SELECT 'OK' FROM tbcatempleadosprueba WHERE numeroempleado = iNumEmpleado) THEN --si existe el num de empleado en la tabla
                RETURN QUERY SELECT 
                        iNumEmpleado, 
                        sNombre,
                        sApPaterno,
                        sApMaterno,
                        sDireccion,
                        sCodigoPostal,
                        sTelefono,
                        sCurp,
                        sNss,
                        (SELECT descripcion from tbcatpuestosprueba WHERE idpuesto = iPuesto),
                        -1,
                        (SELECT concat('Empleado ',iNumEmpleado,' ya se encuentra registrado'));
            ELSE  --No existe el num de empleado en la tabla
                INSERT INTO tbcatempleadosprueba (nombre,apellidopaterno, apellidomaterno, direccion,codigopostal, telefono, curp, nss, fechaalta,numeroempleado, puesto, causabaja)
                VALUES (sNombre,sApPaterno,sApMaterno,sDireccion,sCodigoPostal,sTelefono,sCurp,sNss, NOW(),iNumEmpleado,iPuesto,sCausaBaja);
                RETURN QUERY SELECT 
                        iNumEmpleado, 
                        sNombre,
                        sApPaterno,
                        sApMaterno,
                        sDireccion,
                        sCodigoPostal,
                        sTelefono,
                        sCurp,
                        sNss,
                        (SELECT descripcion from tbcatpuestosprueba WHERE idpuesto = iPuesto),
                        1,
                        (SELECT concat('Empleado ',iNumEmpleado,' registrado exitosamente'));
            END IF;

        WHEN iOpcion = 2 THEN --OPCION QUE ACTUALIZA CIERTA INFORMACION DEL EMPLEADO
            IF EXISTS(SELECT 'OK' FROM tbcatempleadosprueba WHERE numeroempleado = iNumEmpleado) THEN
                --si existe el num de empleado en la tabla
                UPDATE tbcatempleadosprueba SET direccion = sDireccion, codigopostal = sCodigoPostal, telefono = sTelefono,
                curp = sCurp, nss = sNss, puesto = iPuesto WHERE numeroempleado = iNumEmpleado;
                RETURN QUERY SELECT 
                        iNumEmpleado, 
                        sNombre,
                        sApPaterno,
                        sApMaterno,
                        sDireccion,
                        sCodigoPostal,
                        sTelefono,
                        sCurp,
                        sNss,
                        (SELECT descripcion from tbcatpuestosprueba WHERE idpuesto = iPuesto),
                        1,
                        (SELECT concat('Empleado ',iNumEmpleado,' modificado exitosamente'));
            ELSE   
                --No existe el num de empleado en la tabla
                RETURN QUERY SELECT 
                        iNumEmpleado, 
                        sNombre,
                        sApPaterno,
                        sApMaterno,
                        sDireccion,
                        sCodigoPostal,
                        sTelefono,
                        sCurp,
                        sNss,
                        (SELECT descripcion from tbcatpuestosprueba WHERE idpuesto = iPuesto),
                        -1,
                        (SELECT concat('Empleado ',iNumEmpleado,' no se modificó información'));
            END IF;

        WHEN iOpcion = 3 THEN --OPCION QUE MODIFICA LA INFORMACION DEL EMPLEADO PARA DAR DE BAJA
            IF EXISTS(SELECT 'OK' FROM tbcatempleadosprueba WHERE numeroempleado = iNumEmpleado)THEN   --si existe el num de empleado en la tabla y tiene estatus 1
                UPDATE tbcatempleadosprueba SET estatus = 0, fechabaja = NOW(), causabaja = sCausaBaja  WHERE numeroempleado = iNumEmpleado;
                RETURN QUERY SELECT 
                        iNumEmpleado, 
                        sNombre,
                        sApPaterno,
                        sApMaterno,
                        sDireccion,
                        sCodigoPostal,
                        sTelefono,
                        sCurp,
                        sNss,
                        (SELECT descripcion from tbcatpuestosprueba WHERE idpuesto = iPuesto),
                        1,
                        (SELECT concat('Empleado ',iNumEmpleado,' dado de baja correctamente'));
            
            ELSE--No existe el num de empleado en la tabla
                RETURN QUERY SELECT 
                        iNumEmpleado, 
                        sNombre,
                        sApPaterno,
                        sApMaterno,
                        sDireccion,
                        sCodigoPostal,
                        sTelefono,
                        sCurp,
                        sNss,
                        (SELECT descripcion from tbcatpuestosprueba WHERE idpuesto = iPuesto),
                        -1,
                        (SELECT concat('Empleado ',iNumEmpleado,' no se pudo dar de baja correctamente debido a que no existe'));
            END IF;

        WHEN iOpcion = 4 AND iNumEmpleado != 0 THEN --OPCION QUE CONSULTA LOS DATOS DE UN EMPLEADO ACTIVO
            IF EXISTS(SELECT 'OK' FROM tbcatempleadosprueba WHERE numeroempleado = iNumEmpleado) THEN --si existe el num de empleado en la tabla
                IF((SELECT estatus  FROM tbcatempleadosprueba WHERE numeroempleado = iNumEmpleado) = 1 AND (SELECT fechabaja  FROM tbcatempleadosprueba WHERE numeroempleado = iNumEmpleado) = '1900-01-01' AND (SELECT causabaja FROM tbcatempleadosprueba WHERE numeroempleado = iNumEmpleado) = '') THEN --si el empleado esta activo,fecha baja 1900-01-01 y causa baja esta vacio se regresa lo siguiente
                    RETURN QUERY SELECT 
                            e.numeroempleado,
                            e.nombre,
                            e.apellidopaterno,
                            e.apellidomaterno,
                            e.direccion,
                            e.codigopostal,
                            e.telefono,
                            e.curp,
                            e.nss,
                            p.descripcion, 
                            1,
                            (SELECT concat('Empleado ',iNumEmpleado,' encontrado'))
                            FROM tbcatempleadosprueba AS e
                            INNER JOIN tbcatpuestosprueba AS p ON (e.puesto = p.idpuesto)
                            WHERE e.numeroempleado = iNumEmpleado;

                ELSE  --el empleado existe pero está dado de baja

                    RETURN QUERY SELECT 
                            numeroempleado, 
                            nombre,
                            apellidopaterno,
                            apellidomaterno,
                            direccion,
                            codigopostal,
                            telefono,
                            curp,
                            nss,
                            (SELECT descripcion from tbcatpuestosprueba WHERE idpuesto = iPuesto), 
                            -1,
                            (SELECT concat('Empleado ',iNumEmpleado,' se encuentra dado de baja')) FROM tbcatempleadosprueba WHERE numeroempleado = iNumEmpleado;
                END IF;

            ELSE--No existe el num de empleado en la tabla
                RETURN QUERY SELECT 
                        iNumEmpleado, 
                        sNombre,
                        sApPaterno,
                        sApMaterno,
                        sDireccion,
                        sCodigoPostal,
                        sTelefono,
                        sCurp,
                        sNss,
                        (SELECT descripcion from tbcatpuestosprueba WHERE idpuesto = iPuesto),
                        -1,
                        (SELECT concat('Empleado ',iNumEmpleado,' no encontrado'));
            END IF;

        WHEN iOpcion = 4 AND iNumEmpleado = 0 THEN --OPCION QUE CONSULTA LA INFORMACION DE TODOD LOS EMPLEADOS ACTIVOS EN LA BASE DE DATOS
            IF EXISTS(SELECT 'OK' FROM tbcatempleadosprueba WHERE estatus = 1 AND fechabaja = '1900-01-01'  AND causabaja = '') THEN 
                RETURN QUERY SELECT --obtiene todos los empleados que estan activos
                        e.numeroempleado,
                        e.nombre,
                        e.apellidopaterno,
                        e.apellidomaterno,
                        e.direccion,
                        e.codigopostal,
                        e.telefono,
                        e.curp,
                        e.nss,
                        p.descripcion, 
                        1,
                        (SELECT concat('Empleados encontrados')) 
                        FROM tbcatempleadosprueba AS e
                        INNER JOIN tbcatpuestosprueba AS p ON (e.puesto = p.idpuesto)
                        WHERE e.estatus = 1 AND e.fechabaja = '1900-01-01' AND e.causabaja = '';
            ELSE 
                RETURN QUERY SELECT --NO ENCONTRO EMPLEADOS ACTIVOS
                        iNumEmpleado, 
                        sNombre,
                        sApPaterno,
                        sApMaterno,
                        sDireccion,
                        sCodigoPostal,
                        sTelefono,
                        sCurp,
                        sNss,
                        (SELECT descripcion from tbcatpuestosprueba WHERE idpuesto = iPuesto),
                        -1,
                        (SELECT concat('No se encontraron empleados registrados'));
            END IF;
        ELSE
            RETURN QUERY SELECT --SI NO INGRESA ALGUNA OPCION VALIDA
                            iNumEmpleado, 
                            sNombre,
                            sApPaterno,
                            sApMaterno,
                            sDireccion,
                            sCodigoPostal,
                            sTelefono,
                            sCurp,
                            sNss,
                            (SELECT descripcion from tbcatpuestosprueba WHERE idpuesto = iPuesto),
                            -1,
                            (SELECT concat('Opción no valida'));
    END CASE;
END; 
$BODY$
  LANGUAGE plpgsql VOLATILE;


CREATE OR REPLACE FUNCTION fnoperacionespuestos(
    iOpcion INTEGER,
    iIdPuesto INTEGER,
    iDescripcion VARCHAR(100),
    iEmpleadoRegistra INTEGER,
    iEmpleadoBaja INTEGER)

RETURNS TABLE(tidpuesto INTEGER, tdescripcion VARCHAR(100), testatus INTEGER, tmensaje TEXT) AS $BODY$ --retorna todos estos datos como respuesta
DECLARE 

BEGIN
    CASE
        WHEN iOpcion = 1 THEN  --OPCION QUE AGREGA UN NUEVO PUESTO 
            IF EXISTS(SELECT 'OK' FROM tbcatpuestosprueba WHERE idpuesto = iIdPuesto AND descripcion = iDescripcion) THEN --si existe el id del puesto y descripcion en la tabla
                    RETURN QUERY SELECT --EL PUESTO YA EXISTE POR LO QUE NO SE PUEDE DAR DE ALTA
                            iIdPuesto,
                            iDescripcion,
                            -1,
                            (SELECT concat('No se agregó el puesto solicitado'));

            ELSE --EL PUESTO NO EXISTE POR LO QUE SE DA DE ALTA
                INSERT INTO tbcatpuestosprueba(fechaalta,idpuesto,descripcion,empleadoregistra,empleadobaja)
                VALUES(NOW(),iIdPuesto,iDescripcion,iEmpleadoRegistra,iEmpleadoBaja);
                RETURN QUERY SELECT
                            iIdPuesto,
                            iDescripcion,
                            1,
                            (SELECT concat('Puesto agregado correctamente'));
            END IF;

        WHEN iOpcion = 2 THEN --OPCION QUE ACTUALIZA LA INFORMACION DEL PUESTO
            IF EXISTS(SELECT 'OK' FROM tbcatpuestosprueba WHERE idpuesto = iIdPuesto) THEN --SI EL PUESTO EXISTE SE MODIFICA LA DESCRIPCION
            UPDATE tbcatpuestosprueba SET descripcion = iDescripcion WHERE idpuesto = iIdPuesto;
                RETURN QUERY SELECT 
                        iIdPuesto,
                        iDescripcion,
                        1,
                        (SELECT concat('Puesto modificado correctamente'));
            ELSE
                RETURN QUERY SELECT --EL PUESTO NO EXISTE POR LO QUE NO SE MODIFICA LA DESCRIPCION
                        iIdPuesto,
                        iDescripcion,
                        -1,
                        (SELECT concat('No se modificó el puesto solicitado'));
            END IF;
        
        WHEN iOpcion = 3 THEN --OPCION QUE ACTUALIZA LA INFORMACION DEL PUESTO PARA DARLO DE BAJA
            IF EXISTS(SELECT 'OK' FROM tbcatpuestosprueba WHERE idpuesto = iIdPuesto AND estatus = 1) THEN --SI EL PUESTO EXISTE Y TIENE ESTATUS 1, SE PUEDE DAR DE BAJA
            UPDATE tbcatpuestosprueba SET estatus = 0, fechabaja = NOW(), empleadobaja = iEmpleadoBaja WHERE idpuesto = iIdPuesto;
                RETURN QUERY SELECT 
                        iIdPuesto,
                        iDescripcion,
                        1,
                        (SELECT concat('Puesto dado de baja correctamente'));
            ELSE 
                RETURN QUERY SELECT  --EL PUESTO NO EXISTE, NO SE PUEDE DAR DE BAJA
                        iIdPuesto,
                        iDescripcion,
                        -1,
                        (SELECT concat('No se dio de baja el puesto solicitado'));
            END IF;

        WHEN iOpcion = 4 AND iIdPuesto != -1 THEN --OPCION QUE CONSULTA UN PUESTO ACTIVO
            IF EXISTS(SELECT 'OK' FROM tbcatpuestosprueba WHERE idpuesto = iIdPuesto) THEN --SI EXISTE EL PUESTO EN LA TABLA
                IF((SELECT estatus  FROM tbcatpuestosprueba WHERE idpuesto = iIdPuesto) = 1) THEN --SI EL PUESTO ESTA DADO DE ALTA (ESTATUS = 1)
                    RETURN QUERY SELECT 
                        idpuesto,
                        descripcion,
                        1,
                        (SELECT concat('Puesto encontrado')) FROM tbcatpuestosprueba WHERE idpuesto = iIdPuesto;
                ELSE 
                    RETURN QUERY SELECT 
                        idpuesto,
                        descripcion,
                        -1,
                        (SELECT concat('Puesto dado de baja')) FROM tbcatpuestosprueba WHERE idpuesto = iIdPuesto;
                END IF;
                
            ELSE --NO EXISTE EL PUESTO EN BASE DE DATOS
                RETURN QUERY SELECT 
                    iIdPuesto,
                    iDescripcion,
                    -1,
                    (SELECT concat('Puesto no encontrado'));
            END IF;

        WHEN iOpcion = 4 AND iIdPuesto = -1 THEN --OPCION QUE CONSULTA TODOS LOS PUESTOS ACTIVOS 
            IF EXISTS(SELECT 'OK' FROM tbcatpuestosprueba WHERE estatus = 1) THEN --SI EXISTEN PUESTOS ACTIVOS MUESTRA SUS DATOS
                RETURN QUERY SELECT 
                        idpuesto,
                        descripcion,
                        1,
                        (SELECT concat('Puestos encontrados')) FROM tbcatpuestosprueba WHERE estatus = 1;
            ELSE --NO EXISTE EL PUESTO EN LA TABLA
                RETURN QUERY SELECT 
                    iIdPuesto,
                    iDescripcion,
                    -1,
                    (SELECT concat('No se encontraron los puestos registrados'));
            END IF;
        ELSE
            RETURN QUERY SELECT --SI NO INGRESA ALGUNA OPCION VALIDA
                    iIdPuesto,
                    iDescripcion,
                    -1,
                    (SELECT concat('Opción no valida'));
    END CASE;
END; 
$BODY$
  LANGUAGE plpgsql VOLATILE;
